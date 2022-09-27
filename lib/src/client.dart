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
    this.serverRequestMetadata,
  );

  /// Backups area
  final TetaBackups backups;

  /// Policies area
  final TetaPolicies policies;

  ///This stores the token and project id headers.
  final ServerRequestMetadataStore serverRequestMetadata;

  /// Http header for count
  Map<String, String> get countHeader => {'cms-count-only': '1'};

  ///Get token
  String get token => serverRequestMetadata.getMetadata().token;

  /// Get current project id
  int get prjId => serverRequestMetadata.getMetadata().prjId;

  /// Creates a new collection with name [collectionName] and prj_id [prjId].
  ///
  /// Throws an exception on request error ( statusCode != 200 )
  ///
  /// Returns the created collection as `Map<String,dynamic`
  Future<Map<String, dynamic>> createCollection(
    final String collectionName,
  ) async {
    final serverMetadata = serverRequestMetadata.getMetadata();

    final uri = Uri.parse(
      '${Constants.tetaUrl}cms/${serverMetadata.prjId}/$collectionName',
    );

    final res = await http.post(
      uri,
      headers: {'authorization': 'Bearer ${serverMetadata.token}'},
    );

    TetaCMS.log('createCollection: ${res.body}');

    if (res.statusCode != 200) {
      throw Exception('createCollection returned status ${res.statusCode}');
    }

    final data = json.decode(res.body) as Map<String, dynamic>;

    try {
      unawaited(
        TetaCMS.instance.analytics.insertEvent(
          TetaAnalyticsType.createCollection,
          'Teta CMS: create collection request',
          <String, dynamic>{},
          isUserIdPreferableIfExists: false,
        ),
      );
    } catch (_) {}

    return data;
  }

  /// Deletes the collection with id [collectionId] if prj_id is [prjId].
  ///
  /// Throws an exception on request error ( statusCode != 200 )
  ///
  /// Returns `true` on success
  Future<bool> deleteCollection(
    final String collectionId,
  ) async {
    final serverMetadata = serverRequestMetadata.getMetadata();

    final uri = Uri.parse(
      '${Constants.tetaUrl}cms/${serverMetadata.prjId}/$collectionId',
    );

    final res = await http.delete(
      uri,
      headers: {
        'authorization': 'Bearer ${serverMetadata.token}',
      },
    );

    TetaCMS.log('deleteCollection: ${res.body}');

    if (res.statusCode != 200) {
      throw Exception('deleteDocument returned status ${res.statusCode}');
    }

    try {
      unawaited(
        TetaCMS.instance.analytics.insertEvent(
          TetaAnalyticsType.deleteCollection,
          'Teta CMS: delete collection request',
          <String, dynamic>{},
          isUserIdPreferableIfExists: false,
        ),
      );
    } catch (_) {}

    return true;
  }

  /// Inserts the document [document] on [collectionId] if prj_id is [prjId].
  ///
  /// Throws an exception on request error ( statusCode != 200 )
  ///
  /// Returns `true` on success
  Future<bool> insertDocument(
    final String collectionId,
    final Map<String, dynamic> document,
  ) async {
    final serverMetadata = serverRequestMetadata.getMetadata();

    final uri = Uri.parse(
      '${Constants.tetaUrl}cms/${serverMetadata.prjId}/$collectionId',
    );

    final res = await http.put(
      uri,
      headers: {
        'content-type': 'application/json',
        'authorization': 'Bearer ${serverMetadata.token}',
      },
      body: json.encode(document),
    );

    TetaCMS.log('insertDocument: ${res.body}');

    if (res.statusCode != 200) {
      throw Exception('insertDocument returned status ${res.statusCode}');
    }

    try {
      unawaited(
        TetaCMS.instance.analytics.insertEvent(
          TetaAnalyticsType.insertDocument,
          'Teta CMS: insert document request',
          <String, dynamic>{
            'weight': utf8.encode(json.encode(document)).length
          },
          isUserIdPreferableIfExists: true,
        ),
      );
    } catch (_) {}

    return true;
  }

  /// Deletes the document with id [documentId] on [collectionId] if prj_id is [prjId].
  ///
  /// Throws an exception on request error ( statusCode != 200 )
  ///
  /// Returns `true` on success
  Future<bool> deleteDocument(
    final String collectionId,
    final String documentId,
  ) async {
    final serverMetadata = serverRequestMetadata.getMetadata();

    final uri = Uri.parse(
      '${Constants.tetaUrl}cms/${serverMetadata.prjId}/$collectionId/$documentId',
    );

    final res = await http.delete(
      uri,
      headers: {
        'authorization': 'Bearer ${serverMetadata.token}',
      },
    );

    TetaCMS.log('deleteDocument: ${res.body}');

    if (res.statusCode != 200) {
      throw Exception('deleteDocument returned status ${res.statusCode}');
    }

    try {
      unawaited(
        TetaCMS.instance.analytics.insertEvent(
          TetaAnalyticsType.deleteDocument,
          'Teta CMS: delete document request',
          <String, dynamic>{},
          isUserIdPreferableIfExists: true,
        ),
      );
    } catch (_) {}

    return true;
  }

  /// Gets the collection with id [collectionId] if prj_id is [prjId].
  ///
  /// Throws an exception on request error ( statusCode != 200 )
  ///
  /// Returns the collection as `Map<String,dynamic>`
  Future<List<dynamic>> getCollection(
    final String collectionId, {
    final List<Filter> filters = const [],
    final int page = 0,
    final int limit = 20,
    final bool showDrafts = false,
  }) async {
    final serverMetadata = serverRequestMetadata.getMetadata();

    final finalFilters = [
      ...filters,
      if (!showDrafts) Filter('_vis', 'public'),
    ];
    final uri = Uri.parse('${Constants.tetaUrl}cms/${serverMetadata.prjId}/$collectionId');

    final res = await http.get(
      uri,
      headers: {
        'authorization': 'Bearer ${serverMetadata.token}',
        'cms-filters':
            json.encode(finalFilters.map((final e) => e.toJson()).toList()),
        'cms-pagination': json.encode(<String, dynamic>{
          'page': page,
          'pageElems': limit,
        }),
      },
    );

    TetaCMS.log('getCollection: ${res.body}');

    if (res.statusCode != 200) {
      throw Exception('getCollection returned status ${res.statusCode}');
    }

    try {
      unawaited(
        TetaCMS.instance.analytics.insertEvent(
          TetaAnalyticsType.getCollection,
          'Teta CMS: cms request',
          <String, dynamic>{
            'weight': res.bodyBytes.lengthInBytes,
          },
          isUserIdPreferableIfExists: true,
        ),
      );
    } catch (_) {}

    final data = json.decode(res.body) as Map<String, dynamic>;

    final docs = data['docs'] as List<dynamic>;

    return docs;
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
    final serverMetadata = serverRequestMetadata.getMetadata();

    final finalFilters = [
      ...filters,
      if (!showDrafts) Filter('_vis', 'public'),
    ];
    final uri = Uri.parse('${Constants.tetaUrl}cms/${serverMetadata.prjId}/$collectionId');

    final res = await http.get(
      uri,
      headers: {
        'authorization': 'Bearer ${serverMetadata.token}',
        'cms-filters':
            json.encode(finalFilters.map((final e) => e.toJson()).toList()),
        'cms-pagination': json.encode(<String, dynamic>{
          'page': page,
          'pageElems': limit,
        }),
        ...countHeader,
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
  Future<List<CollectionObject>> getCollections() async {
    final serverMetadata = serverRequestMetadata.getMetadata();

    final uri = Uri.parse('${Constants.tetaUrl}cms/${serverMetadata.prjId}');

    final res = await http.get(
      uri,
      headers: {
        'authorization': 'Bearer ${serverMetadata.token}',
      },
    );

    TetaCMS.log('getCollections: ${res.body}');

    if (res.statusCode != 200) {
      throw Exception('getCollections returned status ${res.statusCode}');
    }

    final data = json.decode(res.body) as List<dynamic>;

    try {
      unawaited(
        TetaCMS.instance.analytics.insertEvent(
          TetaAnalyticsType.getCollections,
          'Teta CMS: get collections request',
          <String, dynamic>{
            'weight': res.bodyBytes.lengthInBytes,
          },
          isUserIdPreferableIfExists: false,
        ),
      );
    } catch (_) {}

    TetaCMS.log('getCollections data: $data');

    final list = data
        .map(
          (final dynamic e) =>
              CollectionObject.fromJson(json: e as Map<String, dynamic>),
        )
        .toList();

    TetaCMS.log('getCollections list: $list');

    return list;
  }

  /// Updates the collection [collectionId] with [name] if prj_id is [prjId].
  ///
  /// Throws an exception on request error ( statusCode != 200 )
  ///
  /// Returns the updated collection as `Map<String,dynamic>`
  Future<bool> updateCollection(
    final String collectionId,
    final String name,
    final Map<String, dynamic>? attributes,
  ) async {
    final serverMetadata = serverRequestMetadata.getMetadata();

    final uri = Uri.parse(
      '${Constants.tetaUrl}cms/${serverMetadata.prjId}/$collectionId',
    );

    final res = await http.patch(
      uri,
      headers: {
        'content-type': 'application/json',
        'authorization': 'Bearer ${serverMetadata.token}',
      },
      body: json.encode(<String, dynamic>{
        'name': name,
        if (attributes != null) ...attributes,
      }),
    );

    TetaCMS.log(res.body);

    try {
      unawaited(
        TetaCMS.instance.analytics.insertEvent(
          TetaAnalyticsType.updateCollection,
          'Teta CMS: update collection request',
          <String, dynamic>{
            'weight': res.bodyBytes.lengthInBytes,
          },
          isUserIdPreferableIfExists: true,
        ),
      );
    } catch (_) {}

    if (res.statusCode != 200) {
      throw Exception('updateCollection returned status ${res.statusCode}');
    }

    return true;
  }

  /// Updates the document with id [documentId] on [collectionId] with [content] if prj_id is [prjId].
  ///
  /// Throws an exception on request error ( statusCode != 200 )
  ///
  /// Returns `true` on success
  Future<bool> updateDocument(
    final String collectionId,
    final String documentId,
    final Map<String, dynamic> content,
  ) async {
    final serverMetadata = serverRequestMetadata.getMetadata();

    final uri = Uri.parse(
      '${Constants.tetaUrl}cms/${serverMetadata.prjId}/$collectionId/$documentId',
    );

    final res = await http.put(
      uri,
      headers: {
        'content-type': 'application/json',
        'authorization': 'Bearer ${serverMetadata.token}',
      },
      body: json.encode(content),
    );

    TetaCMS.log(res.body);

    try {
      unawaited(
        TetaCMS.instance.analytics.insertEvent(
          TetaAnalyticsType.updateDocument,
          'Teta CMS: update document request',
          <String, dynamic>{
            'weight': res.bodyBytes.lengthInBytes,
          },
          isUserIdPreferableIfExists: true,
        ),
      );
    } catch (_) {}

    if (res.statusCode != 200) {
      throw Exception('updateDocument returned status ${res.statusCode}');
    }

    return true;
  }

  /// Performs a custom Ayaya query
  Future<TetaResponse<List<dynamic>?, TetaErrorResponse?>> query(
    final String query,
  ) async {
    final serverMetadata = serverRequestMetadata.getMetadata();

    final uri = Uri.parse('${Constants.tetaUrl}cms/aya');

    final res = await http.post(
      uri,
      headers: {
        'authorization': 'Bearer ${serverMetadata.token}',
      },
      body: '''
      ON prj_id* ${serverMetadata.prjId};
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
    final serverMetadata = serverRequestMetadata.getMetadata();

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
