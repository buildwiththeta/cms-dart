import 'dart:convert';

import 'package:clear_response/clear_response.dart';
import 'package:http/http.dart' as http;
import 'package:light_logger/light_logger.dart';
import 'package:teta_cms/src/constants.dart';
import 'package:teta_cms/src/data_stores/local/server_request_metadata_store.dart';
import 'package:teta_cms/teta_cms.dart';

/// Set of methods to edit collections
class CollectionActions {
  /// Set of methods to edit collections
  CollectionActions(
    this._serverRequestMetadata,
  );

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

  /// Deletes the collection with id [collectionId] if prj_id is [prjId].
  ///
  /// Throws an exception on request error ( statusCode != 200 )
  ///
  /// Returns `true` on success
  Future<ClearResponse<Map<String, dynamic>?, ClearErrorResponse?>>
      deleteCollection(
    final String collectionId,
  ) async {
    final uri = Uri.parse('${Constants.tetaUrl}collection/$collectionId');
    final res = await http.delete(
      uri,
      headers: _getDefaultHeaders,
    );
    if (res.statusCode != 200) {
      Logger.printError(
        'deleteDocument returned status ${res.statusCode}, error: ${res.body}',
      );
      return ClearResponse(
        data: null,
        error: ClearErrorResponse(
          code: res.statusCode,
          message:
              'deleteDocument returned status ${res.statusCode}, error: ${res.body}',
        ),
      );
    }
    final data = json.decode(res.body) as Map<String, dynamic>;
    return ClearResponse(data: data, error: null);
  }

  /// Deletes the collection with id [collectionName] if prj_id is [prjId].
  ///
  /// Throws an exception on request error ( statusCode != 200 )
  ///
  /// Returns `true` on success
  Future<ClearResponse<Map<String, dynamic>?, ClearErrorResponse?>>
      deleteCollectionByName(
    final String collectionName,
  ) async {
    final uri = Uri.parse('${Constants.tetaUrl}collection/$collectionName');
    final res = await http.delete(
      uri,
      headers: _getDefaultHeadersForNameEndpoints,
    );
    if (res.statusCode != 200) {
      Logger.printError(
        'deleteDocumentByName returned status ${res.statusCode}, error: ${res.body}',
      );
      return ClearResponse(
        data: null,
        error: ClearErrorResponse(
          code: res.statusCode,
          message:
              'deleteDocumentByName returned status ${res.statusCode}, error: ${res.body}',
        ),
      );
    }
    final data = json.decode(res.body) as Map<String, dynamic>;
    return ClearResponse(data: data, error: null);
  }

  /// Gets the collection with id [collectionId] if prj_id is [prjId].
  ///
  /// Throws an exception on request error ( statusCode != 200 )
  ///
  /// Returns the collection as `Map<String,dynamic>`
  Future<ClearResponse<List<dynamic>?, ClearErrorResponse?>> getCollection(
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
      Logger.printError(
        'getCollection returned status ${res.statusCode}, error: ${res.body}',
      );
      return ClearResponse(
        data: null,
        error: ClearErrorResponse(
          code: res.statusCode,
          message:
              'getCollection returned status ${res.statusCode}, error: ${res.body}',
        ),
      );
    }
    final data = json.decode(res.body) as List<dynamic>;
    return ClearResponse(data: data, error: null);
  }

  /// Gets the collection with id [collectionName] if prj_id is [prjId].
  ///
  /// Throws an exception on request error ( statusCode != 200 )
  ///
  /// Returns the collection as `Map<String,dynamic>`
  Future<ClearResponse<List<dynamic>?, ClearErrorResponse?>>
      getCollectionByName(
    final String collectionName, {
    final List<Filter> filters = const [],
    final int page = 0,
    final int limit = 20,
    final bool showDrafts = false,
  }) async {
    final finalFilters = [
      ...filters,
      if (!showDrafts) Filter('_vis', 'public'),
    ];
    final uri = Uri.parse('${Constants.tetaUrl}document/$collectionName/list');
    final res = await http.get(
      uri,
      headers: {
        ..._getDefaultHeadersForNameEndpoints,
        'cms-filters':
            json.encode(finalFilters.map((final e) => e.toJson()).toList()),
        'cms-pagination': json.encode(<String, dynamic>{
          'page': page,
          'pageElems': limit,
        }),
      },
    );
    if (res.statusCode != 200) {
      Logger.printError(
        'getCollectionByName returned status ${res.statusCode}, error: ${res.body}',
      );
      return ClearResponse(
        data: null,
        error: ClearErrorResponse(
          code: res.statusCode,
          message:
              'getCollectionByName returned status ${res.statusCode}, error: ${res.body}',
        ),
      );
    }
    final data = json.decode(res.body) as List<dynamic>;
    return ClearResponse(data: data, error: null);
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
    return count;
  }

  /// Gets the collection with id [collectionName] if prj_id is [prjId].
  ///
  /// Throws an exception on request error ( statusCode != 200 )
  ///
  /// Returns the collection as `Map<String,dynamic>`
  Future<int> getCollectionCountByName(
    final String collectionName, {
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
      '${Constants.tetaUrl}collection/$prjId/$collectionName',
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
        'use-name': 'true',
      },
    );

    if (res.statusCode != 200) {
      throw Exception('getCollectionByName returned status ${res.statusCode}');
    }

    final data = json.decode(res.body) as Map<String, dynamic>;

    final count = data['count'] as int? ?? 0;

    return count;
  }

  /// Updates the collection [collectionId] with [name] if prj_id is [prjId].
  ///
  /// Throws an exception on request error ( statusCode != 200 )
  ///
  /// Returns the updated collection as `Map<String,dynamic>`
  Future<ClearResponse<Map<String, dynamic>?, ClearErrorResponse?>>
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
      Logger.printError(
        'updateCollection returned status ${res.statusCode}, error: ${res.body}',
      );
      return ClearResponse(
        data: null,
        error: ClearErrorResponse(
          code: res.statusCode,
          message:
              'updateCollection returned status ${res.statusCode}, error: ${res.body}',
        ),
      );
    }
    final data = json.decode(res.body) as Map<String, dynamic>;
    return ClearResponse(data: data, error: null);
  }

  /// Updates the collection [collectionName] with [name] if prj_id is [prjId].
  ///
  /// Throws an exception on request error ( statusCode != 200 )
  ///
  /// Returns the updated collection as `Map<String,dynamic>`
  Future<ClearResponse<Map<String, dynamic>?, ClearErrorResponse?>>
      updateCollectionByName(
    final String collectionName,
    final String name,
    final Map<String, dynamic>? attributes,
  ) async {
    final uri = Uri.parse(
      '${Constants.tetaUrl}collection/$collectionName',
    );
    final res = await http.patch(
      uri,
      headers: _getDefaultHeadersForNameEndpoints,
      body: json.encode(<String, dynamic>{
        'name': name,
        if (attributes != null) ...attributes,
      }),
    );
    if (res.statusCode != 200) {
      Logger.printError(
        'updateCollectionByName returned status ${res.statusCode}, error: ${res.body}',
      );
      return ClearResponse(
        data: null,
        error: ClearErrorResponse(
          code: res.statusCode,
          message:
              'updateCollectionByName returned status ${res.statusCode}, error: ${res.body}',
        ),
      );
    }
    final data = json.decode(res.body) as Map<String, dynamic>;
    return ClearResponse(data: data, error: null);
  }

  /// Inserts the document [document] on [collectionId] if prj_id is [prjId].
  ///
  /// Throws an exception on request error ( statusCode != 200 )
  ///
  /// Returns `true` on success
  Future<ClearResponse<Map<String, dynamic>?, ClearErrorResponse?>>
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
      Logger.printError(
        'insertDocument returned status ${res.statusCode}, error: ${res.body}',
      );
      return ClearResponse(
        data: null,
        error: ClearErrorResponse(
          code: res.statusCode,
          message:
              'insertDocument returned status ${res.statusCode}, error: ${res.body}',
        ),
      );
    }
    final data = json.decode(res.body) as Map<String, dynamic>;
    return ClearResponse(data: data, error: null);
  }

  /// Inserts the document [document] on [collectionName] if prj_id is [prjId].
  ///
  /// Throws an exception on request error ( statusCode != 200 )
  ///
  /// Returns `true` on success
  Future<ClearResponse<Map<String, dynamic>?, ClearErrorResponse?>>
      insertDocumentByCollName(
    final String collectionName,
    final Map<String, dynamic> document,
  ) async {
    final uri = Uri.parse(
      '${Constants.tetaUrl}document/$collectionName',
    );
    final res = await http.post(
      uri,
      headers: {..._getDefaultHeadersForNameEndpoints},
      body: json.encode(document),
    );
    if (res.statusCode != 200) {
      Logger.printError(
        'insertDocumentByName returned status ${res.statusCode}, error: ${res.body}',
      );
      return ClearResponse(
        data: null,
        error: ClearErrorResponse(
          code: res.statusCode,
          message:
              'insertDocumentByName returned status ${res.statusCode}, error: ${res.body}',
        ),
      );
    }
    final data = json.decode(res.body) as Map<String, dynamic>;
    return ClearResponse(data: data, error: null);
  }
}
