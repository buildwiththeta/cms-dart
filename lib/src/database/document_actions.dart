import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:teta_cms/src/constants.dart';
import 'package:teta_cms/src/data_stores/local/server_request_metadata_store.dart';
import 'package:teta_cms/teta_cms.dart';

/// Set of methods to edit documents
class TetaDocumentActions {
  /// Set of methods to edit documents
  TetaDocumentActions(this.documentId, this._serverRequestMetadata);

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
    } catch (e) {
      TetaCMS.printError(
        'Error inserting a new event in Teta Analytics, error: $e',
      );
    }
  }

  /// Deletes the document with id [documentId] on [collectionId] if prj_id is [prjId].
  ///
  /// Throws an exception on request error ( statusCode != 200 )
  ///
  /// Returns `true` on success
  Future<TetaResponse<Map<String, dynamic>?, TetaErrorResponse?>>
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

  /// Deletes the document with id [documentId] on [collectionName] if prj_id is [prjId].
  ///
  /// Throws an exception on request error ( statusCode != 200 )
  ///
  /// Returns `true` on success
  Future<TetaResponse<Map<String, dynamic>?, TetaErrorResponse?>>
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
      TetaCMS.printError(
        'deleteDocumentByName returned status ${res.statusCode}, error: ${res.body}',
      );
      return TetaResponse(
        data: null,
        error: TetaErrorResponse(
          code: res.statusCode,
          message:
              'deleteDocumentByName returned status ${res.statusCode}, error: ${res.body}',
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

  /// Updates the document with id [documentId] on [collectionId] with [content] if prj_id is [prjId].
  ///
  /// Throws an exception on request error ( statusCode != 200 )
  ///
  /// Returns `true` on success
  Future<TetaResponse<Map<String, dynamic>?, TetaErrorResponse?>>
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

  /// Updates the document with id [documentId] on [collectionName] with [content] if prj_id is [prjId].
  ///
  /// Throws an exception on request error ( statusCode != 200 )
  ///
  /// Returns `true` on success
  Future<TetaResponse<Map<String, dynamic>?, TetaErrorResponse?>>
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
      return TetaResponse(
        data: null,
        error: TetaErrorResponse(
          code: res.statusCode,
          message:
              'updateDocumentByName returned status ${res.statusCode}, error: ${res.body}',
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
}
