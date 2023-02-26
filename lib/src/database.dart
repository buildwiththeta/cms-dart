import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:teta_cms/src/constants.dart';
import 'package:teta_cms/src/data_stores/local/server_request_metadata_store.dart';
import 'package:teta_cms/src/database/collection_query.dart';
import 'package:teta_cms/src/db/backups.dart';
import 'package:teta_cms/src/db/policy.dart';
import 'package:teta_cms/src/models/stream_actions.dart';
import 'package:teta_cms/teta_cms.dart';

/// The CMS client to interact with the db
@lazySingleton
class TetaDatabase {
  /// Client to interact with the Teta CMS's db
  TetaDatabase(
    this.backups,
    this.policies,
    this._serverRequestMetadata,
  ) : _realtime = TetaRealtime(_serverRequestMetadata);

  final TetaRealtime _realtime;

  /// Backups area
  final TetaBackups backups;

  /// Policies area
  final TetaPolicies policies;

  ///This stores the token and project id headers.
  final ServerRequestMetadataStore _serverRequestMetadata;

  /// Http header for count
  Map<String, String> get _countHeader => {'cms-count-only': '1'};

  ///Get token
  String get token => _serverRequestMetadata.getMetadata().token;

  /// Get current project id
  int get prjId => _serverRequestMetadata.getMetadata().prjId;

  Map<String, String> get _getPrjHeader => <String, String>{
        'x-teta-prj-id': prjId.toString(),
      };

  Map<String, String> get _getJsonHeader => <String, String>{
        'content-type': 'application/json',
      };

  /// Get auth token, content-type and prj id headers
  Map<String, String> get _getDefaultHeaders {
    return <String, String>{
      'authorization': 'Bearer $token',
      ..._getJsonHeader,
      ..._getPrjHeader,
    };
  }

  /// Get auth token, content-type and prj id headers
  Map<String, String> get _getDefaultHeadersForNameEndpoints {
    return <String, String>{
      'authorization': 'Bearer $token',
      'use-name': 'true',
      ..._getJsonHeader,
      ..._getPrjHeader,
    };
  }

  void _registerEvent({
    required final TetaAnalyticsType event,
    required final String description,
    final Map<String, dynamic> props = const <String, dynamic>{},
    final bool useUserId = false,
  }) {
    try {
      unawaited(
        TetaCMS.instance.analytics.insertEvent(
          event,
          description,
          props,
          isUserIdPreferableIfExists: useUserId,
        ),
      );
    } catch (e) {
      TetaCMS.printError(
        'Error inserting a new event in Teta Analytics, error: $e',
      );
    }
  }

  TetaCollectionQuery from({final String? name, final String? id}) {
    assert(
      name != null && id == null || name == null && id != null,
      'Only oe between name and id must be not null',
    );
    return TetaCollectionQuery(_serverRequestMetadata, id: id, name: name);
  }

  StreamController<List<CollectionObject>> streamCollections() {
    return _realtime.streamCollections();
  }

  Future<RealtimeHandler> on({
    final StreamAction action = StreamAction.all,
    final String? collectionId,
    final String? collectionName,
    final String? documentId,
    final dynamic Function(SocketChangeEvent)? callback,
  }) {
    return _realtime.on(
      action: action,
      collectionId: collectionId,
      collectionName: collectionName,
      callback: callback,
    );
  }

  /// Creates a new collection with name [collectionName] and prj_id [prjId].
  ///
  /// Throws an exception on request error ( statusCode != 200 )
  ///
  /// Returns the created collection as `Map<String,dynamic`
  Future<TetaResponse<Map<String, dynamic>?, TetaErrorResponse?>>
      createCollection(
    final String collectionName,
  ) async {
    final uri = Uri.parse(
      '${Constants.tetaUrl}collection',
    );
    final res = await http.post(
      uri,
      headers: _getDefaultHeaders,
      body: json.encode(
        <String, dynamic>{'name': collectionName},
      ),
    );
    if (res.statusCode != 200) {
      TetaCMS.printError(
        'createCollection returned status ${res.statusCode}, error: ${res.body}',
      );
      return TetaResponse(
        data: null,
        error: TetaErrorResponse(
          code: res.statusCode,
          message:
              'createCollection returned status ${res.statusCode}, error: ${res.body}',
        ),
      );
    }
    final data = json.decode(res.body) as Map<String, dynamic>;
    _registerEvent(
      event: TetaAnalyticsType.createCollection,
      description: 'Teta CMS: create collection request',
    );
    return TetaResponse(data: data, error: null);
  }

  /// Gets all collection where prj_id is [prjId].
  ///
  /// Throws an exception on request error ( statusCode != 200 )
  ///
  /// Returns the collections as `List<Map<String,dynamic>>` without `docs`
  Future<TetaResponse<List<CollectionObject>?, TetaErrorResponse?>>
      getCollections() async {
    final uri = Uri.parse('${Constants.tetaUrl}collection/list');
    final res = await http.get(
      uri,
      headers: _getDefaultHeaders,
    );
    if (res.statusCode != 200) {
      TetaCMS.printError(
        'getCollections returned status ${res.statusCode}, error: ${res.body}',
      );
      return TetaResponse(
        data: null,
        error: TetaErrorResponse(
          code: res.statusCode,
          message:
              'getCollections returned status ${res.statusCode}, error: ${res.body}',
        ),
      );
    }
    final data = json.decode(res.body) as List<dynamic>;
    final collections = data
        .map(
          (final dynamic e) =>
              CollectionObject.fromJson(json: e as Map<String, dynamic>),
        )
        .toList();
    _registerEvent(
      event: TetaAnalyticsType.getCollections,
      description: 'Teta CMS: get collections request',
    );
    return TetaResponse(data: collections, error: null);
  }

  /// Performs a custom Ayaya query
  Future<TetaResponse<List<dynamic>?, TetaErrorResponse?>> query(
    final String query,
  ) async {
    final uri = Uri.parse('${Constants.tetaUrl}cms/aya');

    final res = await http.post(
      uri,
      headers: {
        'authorization': 'Bearer $token',
      },
      body: '''
      ON prj_id* $prjId;
      $query
      ''',
    );

    TetaCMS.log('custom query: ${res.body}');

    if (res.statusCode != 200) {
      return TetaResponse<List<dynamic>?, TetaErrorResponse>(
        data: null,
        error: TetaErrorResponse(
          code: res.statusCode,
          message: res.body,
        ),
      );
    }

    try {
      unawaited(
        TetaCMS.instance.analytics.insertEvent(
          TetaAnalyticsType.customQuery,
          'Teta CMS: custom queries request',
          <String, dynamic>{
            'weight': res.bodyBytes.lengthInBytes + utf8.encode(query).length,
          },
          isUserIdPreferableIfExists: false,
        ),
      );
    } catch (_) {}

    final docs = json.decode(res.body) as List<dynamic>;

    return TetaResponse<List<dynamic>, TetaErrorResponse?>(
      data: docs,
      error: null,
    );
  }

  ///This is used to proxy calls to Google Api for Desktop and Web.
  Future<String> proxy(
    final String url,
    final Map<String, String> headers,
  ) async {
    final serverMetadata = _serverRequestMetadata.getMetadata();

    final enc = Uri.encodeComponent(url);
    final uri = Uri.parse('${Constants.reverseProxyUrl}/$enc');
    final res = await http.get(
      uri,
      headers: {
        'authorization': 'Bearer ${serverMetadata.token}',
        ...headers,
      },
    );

    if (res.statusCode == 200) {
      return res.body;
    } else {
      throw Exception('Request failed.: ${res.body}');
    }
  }
}
