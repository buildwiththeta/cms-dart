import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:teta_cms/src/constants.dart';
import 'package:teta_cms/src/data_stores/local/server_request_metadata_store.dart';
import 'package:teta_cms/src/db/backups.dart';
import 'package:teta_cms/src/db/policy.dart';
import 'package:teta_cms/teta_cms.dart';

/// The CMS client to interact with the db
@lazySingleton
class TetaClient {
  /// Client to interact with the Teta CMS's db
  TetaClient(
    this.backups,
    this.policies,
    this._serverRequestMetadata,
  );

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

  void _registerEvent({
    required final TetaAnalyticsType event,
    required final String description,
    final Map<String, dynamic> props = const <String, dynamic>{},
    final bool useUserId = false,
  }) {
    try {
      TetaCMS.instance.analytics.insertEvent(
        event,
        description,
        props,
        isUserIdPreferableIfExists: useUserId,
      );
    } catch (_) {}
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

  /// Deletes the collection with id [collectionId] if prj_id is [prjId].
  ///
  /// Throws an exception on request error ( statusCode != 200 )
  ///
  /// Returns `true` on success
  Future<TetaResponse<Map<String, dynamic>?, TetaErrorResponse?>>
      deleteCollection(
    final String collectionId,
  ) async {
    final uri = Uri.parse('${Constants.tetaUrl}collection/$collectionId');
    final res = await http.delete(
      uri,
      headers: _getDefaultHeaders,
    );
    if (res.statusCode != 200) {
      TetaCMS.printError(
        'deleteDocument returned status ${res.statusCode}, error: ${res.body}',
      );
      return TetaResponse(
        data: null,
        error: TetaErrorResponse(
          code: res.statusCode,
          message:
              'deleteDocument returned status ${res.statusCode}, error: ${res.body}',
        ),
      );
    }
    final data = json.decode(res.body) as Map<String, dynamic>;
    _registerEvent(
      event: TetaAnalyticsType.deleteCollection,
      description: 'Teta CMS: delete collection request',
    );
    return TetaResponse(data: data, error: null);
  }

  /// Inserts the document [document] on [collectionId] if prj_id is [prjId].
  ///
  /// Throws an exception on request error ( statusCode != 200 )
  ///
  /// Returns `true` on success
  Future<TetaResponse<Map<String, dynamic>?, TetaErrorResponse?>>
      insertDocument(
    final String collectionId,
    final Map<String, dynamic> document,
  ) async {
    final uri = Uri.parse(
      '${Constants.tetaUrl}document/$collectionId',
    );
    final res = await http.post(
      uri,
      headers: {..._getDefaultHeaders},
      body: json.encode(document),
    );
    if (res.statusCode != 200) {
      TetaCMS.printError(
        'insertDocument returned status ${res.statusCode}, error: ${res.body}',
      );
      return TetaResponse(
        data: null,
        error: TetaErrorResponse(
          code: res.statusCode,
          message:
              'insertDocument returned status ${res.statusCode}, error: ${res.body}',
        ),
      );
    }
    final data = json.decode(res.body) as Map<String, dynamic>;
    _registerEvent(
      event: TetaAnalyticsType.insertDocument,
      description: 'Teta CMS: insert document request',
      props: <String, dynamic>{
        'weight': utf8.encode(json.encode(document)).length
      },
      useUserId: true,
    );
    return TetaResponse(data: data, error: null);
  }

  /// Deletes the document with id [documentId] on [collectionId] if prj_id is [prjId].
  ///
  /// Throws an exception on request error ( statusCode != 200 )
  ///
  /// Returns `true` on success
  Future<TetaResponse<Map<String, dynamic>?, TetaErrorResponse?>>
      deleteDocument(
    final String collectionId,
    final String documentId,
  ) async {
    final uri =
        Uri.parse('${Constants.tetaUrl}document/$collectionId/$documentId');
    final res = await http.delete(
      uri,
      headers: _getDefaultHeaders,
    );
    if (res.statusCode != 200) {
      TetaCMS.printError(
        'deleteDocument returned status ${res.statusCode}, error: ${res.body}',
      );
      return TetaResponse(
        data: null,
        error: TetaErrorResponse(
          code: res.statusCode,
          message:
              'deleteDocument returned status ${res.statusCode}, error: ${res.body}',
        ),
      );
    }
    final data = json.decode(res.body) as Map<String, dynamic>;
    _registerEvent(
      event: TetaAnalyticsType.deleteDocument,
      description: 'Teta CMS: delete document request',
      useUserId: true,
    );
    return TetaResponse(data: data, error: null);
  }

  /// Gets the collection with id [collectionId] if prj_id is [prjId].
  ///
  /// Throws an exception on request error ( statusCode != 200 )
  ///
  /// Returns the collection as `Map<String,dynamic>`
  Future<TetaResponse<List<dynamic>?, TetaErrorResponse?>> getCollection(
    final String collectionId, {
    final List<Filter> filters = const [],
    final int page = 0,
    final int limit = 20,
    final bool showDrafts = false,
  }) async {
    final finalFilters = [
      ...filters,
      if (!showDrafts) Filter('_vis', 'public'),
    ];
    final uri = Uri.parse('${Constants.tetaUrl}document/$collectionId/list');
    final res = await http.get(
      uri,
      headers: {
        ..._getDefaultHeaders,
        'cms-filters':
            json.encode(finalFilters.map((final e) => e.toJson()).toList()),
        'cms-pagination': json.encode(<String, dynamic>{
          'page': page,
          'pageElems': limit,
        }),
      },
    );
    if (res.statusCode != 200) {
      TetaCMS.printError(
        'getCollection returned status ${res.statusCode}, error: ${res.body}',
      );
      return TetaResponse(
        data: null,
        error: TetaErrorResponse(
          code: res.statusCode,
          message:
              'getCollection returned status ${res.statusCode}, error: ${res.body}',
        ),
      );
    }
    final data = json.decode(res.body) as List<dynamic>;
    _registerEvent(
      event: TetaAnalyticsType.getCollection,
      description: 'Teta CMS: cms request',
      props: <String, dynamic>{
        'weight': res.bodyBytes.lengthInBytes,
      },
      useUserId: true,
    );
    return TetaResponse(data: data, error: null);
  }

  /// Gets the collection with id [collectionId] if prj_id is [prjId].
  ///
  /// Throws an exception on request error ( statusCode != 200 )
  ///
  /// Returns the collection as `Map<String,dynamic>`
  Future<int> getCollectionCount(
    final String collectionId, {
    final List<Filter> filters = const [],
    final int page = 0,
    final int limit = 20,
    final bool showDrafts = false,
  }) async {
    final finalFilters = [
      ...filters,
      if (!showDrafts) Filter('_vis', 'public'),
    ];
    final uri = Uri.parse(
      '${Constants.tetaUrl}collection/$prjId/$collectionId',
    );

    final res = await http.get(
      uri,
      headers: {
        'authorization': 'Bearer $token',
        'cms-filters':
            json.encode(finalFilters.map((final e) => e.toJson()).toList()),
        'cms-pagination': json.encode(<String, dynamic>{
          'page': page,
          'pageElems': limit,
        }),
        ..._countHeader,
      },
    );

    if (res.statusCode != 200) {
      throw Exception('getCollection returned status ${res.statusCode}');
    }

    final data = json.decode(res.body) as Map<String, dynamic>;

    final count = data['count'] as int? ?? 0;

    try {
      unawaited(
        TetaCMS.instance.analytics.insertEvent(
          TetaAnalyticsType.getCollectionCount,
          'Teta CMS: count request',
          <String, dynamic>{},
          isUserIdPreferableIfExists: true,
        ),
      );
    } catch (_) {}

    return count;
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

  /// Updates the collection [collectionId] with [name] if prj_id is [prjId].
  ///
  /// Throws an exception on request error ( statusCode != 200 )
  ///
  /// Returns the updated collection as `Map<String,dynamic>`
  Future<TetaResponse<Map<String, dynamic>?, TetaErrorResponse?>>
      updateCollection(
    final String collectionId,
    final String name,
    final Map<String, dynamic>? attributes,
  ) async {
    final uri = Uri.parse(
      '${Constants.tetaUrl}collection/$collectionId',
    );
    final res = await http.patch(
      uri,
      headers: _getDefaultHeaders,
      body: json.encode(<String, dynamic>{
        'name': name,
        if (attributes != null) ...attributes,
      }),
    );
    if (res.statusCode != 200) {
      TetaCMS.printError(
        'updateCollection returned status ${res.statusCode}, error: ${res.body}',
      );
      return TetaResponse(
        data: null,
        error: TetaErrorResponse(
          code: res.statusCode,
          message:
              'updateCollection returned status ${res.statusCode}, error: ${res.body}',
        ),
      );
    }
    final data = json.decode(res.body) as Map<String, dynamic>;
    _registerEvent(
      event: TetaAnalyticsType.updateCollection,
      description: 'Teta CMS: update collection request',
      props: <String, dynamic>{
        'weight': res.bodyBytes.lengthInBytes,
      },
      useUserId: true,
    );
    return TetaResponse(data: data, error: null);
  }

  /// Updates the document with id [documentId] on [collectionId] with [content] if prj_id is [prjId].
  ///
  /// Throws an exception on request error ( statusCode != 200 )
  ///
  /// Returns `true` on success
  Future<TetaResponse<Map<String, dynamic>?, TetaErrorResponse?>>
      updateDocument(
    final String collectionId,
    final String documentId,
    final Map<String, dynamic> content,
  ) async {
    final uri = Uri.parse(
      '${Constants.tetaUrl}document/$collectionId/$documentId',
    );

    final res = await http.put(
      uri,
      headers: _getDefaultHeaders,
      body: json.encode(content),
    );
    if (res.statusCode != 200) {
      return TetaResponse(
        data: null,
        error: TetaErrorResponse(
          code: res.statusCode,
          message:
              'updateDocument returned status ${res.statusCode}, error: ${res.body}',
        ),
      );
    }
    final data = json.decode(res.body) as Map<String, dynamic>;
    _registerEvent(
      event: TetaAnalyticsType.updateDocument,
      description: 'Teta CMS: update document request',
      props: <String, dynamic>{
        'weight': res.bodyBytes.lengthInBytes,
      },
      useUserId: true,
    );
    return TetaResponse(data: data, error: null);
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
