import 'dart:convert';

import 'package:clear_response/clear_response.dart';
import 'package:http/http.dart' as http;
import 'package:light_logger/light_logger.dart';
import 'package:teta_cms/src/constants.dart';
import 'package:teta_cms/src/data_stores/local/server_request_metadata_store.dart';

/// Set of methods to edit documents
class DocumentActions {
  /// Set of methods to edit documents
  DocumentActions(this.documentId, this._serverRequestMetadata);

  /// Document Id
  final String documentId;

  ///This stores the token and project id headers.
  final ServerRequestMetadataStore _serverRequestMetadata;

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

  /// Deletes the document with id [documentId] on [collectionId] if prj_id is [prjId].
  ///
  /// Throws an exception on request error ( statusCode != 200 )
  ///
  /// Returns `true` on success
  Future<ClearResponse<Map<String, dynamic>?, ClearErrorResponse?>>
      deleteDocument(
    final String collectionId,
  ) async {
    final uri =
        Uri.parse('${Constants.tetaUrl}document/$collectionId/$documentId');
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

  /// Deletes the document with id [documentId] on [collectionName] if prj_id is [prjId].
  ///
  /// Throws an exception on request error ( statusCode != 200 )
  ///
  /// Returns `true` on success
  Future<ClearResponse<Map<String, dynamic>?, ClearErrorResponse?>>
      deleteDocumentByCollName(
    final String collectionName,
  ) async {
    final uri =
        Uri.parse('${Constants.tetaUrl}document/$collectionName/$documentId');
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

  /// Updates the document with id [documentId] on [collectionId] with [content] if prj_id is [prjId].
  ///
  /// Throws an exception on request error ( statusCode != 200 )
  ///
  /// Returns `true` on success
  Future<ClearResponse<Map<String, dynamic>?, ClearErrorResponse?>>
      updateDocument(
    final String collectionId,
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
      return ClearResponse(
        data: null,
        error: ClearErrorResponse(
          code: res.statusCode,
          message:
              'updateDocument returned status ${res.statusCode}, error: ${res.body}',
        ),
      );
    }
    final data = json.decode(res.body) as Map<String, dynamic>;
    return ClearResponse(data: data, error: null);
  }

  /// Updates the document with id [documentId] on [collectionName] with [content] if prj_id is [prjId].
  ///
  /// Throws an exception on request error ( statusCode != 200 )
  ///
  /// Returns `true` on success
  Future<ClearResponse<Map<String, dynamic>?, ClearErrorResponse?>>
      updateDocumentByCollName(
    final String collectionName,
    final Map<String, dynamic> content,
  ) async {
    final uri = Uri.parse(
      '${Constants.tetaUrl}document/$collectionName/$documentId',
    );

    final res = await http.put(
      uri,
      headers: _getDefaultHeadersForNameEndpoints,
      body: json.encode(content),
    );
    if (res.statusCode != 200) {
      return ClearResponse(
        data: null,
        error: ClearErrorResponse(
          code: res.statusCode,
          message:
              'updateDocumentByName returned status ${res.statusCode}, error: ${res.body}',
        ),
      );
    }
    final data = json.decode(res.body) as Map<String, dynamic>;
    return ClearResponse(data: data, error: null);
  }
}
