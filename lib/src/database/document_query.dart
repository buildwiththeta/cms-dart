import 'dart:async';

import 'package:teta_cms/src/data_stores/local/server_request_metadata_store.dart';
import 'package:teta_cms/src/database/document_actions.dart';
import 'package:teta_cms/src/models/stream_actions.dart';
import 'package:teta_cms/teta_cms.dart';

class TetaDocumentQuery {
  TetaDocumentQuery(
    this.documentId,
    this._serverRequestMetadata, {
    this.collectionId,
    this.collectionName,
  })  : _doc = TetaDocumentActions(documentId, _serverRequestMetadata),
        _realtime = TetaRealtime(_serverRequestMetadata);

  final String documentId;
  final String? collectionId;
  final String? collectionName;

  final TetaDocumentActions _doc;

  final TetaRealtime _realtime;

  ///This stores the token and project id headers.
  final ServerRequestMetadataStore _serverRequestMetadata;

  Future<TetaResponse<Map<String, dynamic>?, TetaErrorResponse?>>
      delete() async {
    if (collectionName == null && collectionId == null) {
      return TetaResponse(
        data: null,
        error: TetaErrorResponse(
          message:
              'Call .select() choosing one between id and name before this.',
        ),
      );
    } else if (collectionName != null) {
      return _doc.deleteDocumentByCollName(collectionName!);
    } else {
      return _doc.deleteDocument(collectionId!);
    }
  }

  Future<RealtimeHandler> on({
    final StreamAction action = StreamAction.all,
    final dynamic Function(SocketChangeEvent)? callback,
  }) {
    if (collectionName == null && collectionId == null) {
      throw Exception(
        'Call .select() choosing one between id and name before this.',
      );
    } else if (collectionName != null) {
      return _realtime.on(
        action: action,
        collectionName: collectionName,
        documentId: documentId,
        callback: callback,
      );
    } else {
      return _realtime.on(
        action: action,
        collectionId: collectionId,
        documentId: documentId,
        callback: callback,
      );
    }
  }

  /// Updates the document with id [documentId] on [collectionName] with [content] if prj_id is [prjId].
  ///
  /// Throws an exception on request error ( statusCode != 200 )
  ///
  /// Returns `true` on success
  Future<TetaResponse<Map<String, dynamic>?, TetaErrorResponse?>> update(
    final Map<String, dynamic> content,
  ) async {
    if (collectionName == null && collectionId == null) {
      return TetaResponse(
        data: null,
        error: TetaErrorResponse(
          message:
              'Call .select() choosing one between id and name before this.',
        ),
      );
    } else if (collectionName != null) {
      return _doc.updateDocumentByCollName(collectionName!, content);
    } else {
      return _doc.updateDocument(collectionId!, content);
    }
  }
}
