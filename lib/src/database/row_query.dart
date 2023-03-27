import 'dart:async';

import 'package:clear_response/clear_response.dart';
import 'package:teta_cms/src/data_stores/local/server_request_metadata_store.dart';
import 'package:teta_cms/src/database/row_actions.dart';
import 'package:teta_cms/src/models/stream_actions.dart';
import 'package:teta_cms/teta_cms.dart';

/// Query builder for documents actions
class TetaRowQuery {
  /// Query builder for documents actions
  TetaRowQuery(
    final String rowId,
    final ServerRequestMetadataStore _serverRequestMetadata, {
    final String? collectionId,
    final String? collectionName,
  })  : _rowId = rowId,
        _collectionId = collectionId,
        _collectionName = collectionName,
        _doc = DocumentActions(rowId, _serverRequestMetadata),
        _realtime = Realtime(_serverRequestMetadata);

  /// Document id
  final String _rowId;

  /// Current collection id
  final String? _collectionId;

  /// Current collection name
  final String? _collectionName;

  final DocumentActions _doc;

  final Realtime _realtime;

  /// Delete the current document
  Future<ClearResponse<Map<String, dynamic>?, ClearErrorResponse?>>
      delete() async {
    if (_collectionName == null && _collectionId == null) {
      return ClearResponse(
        data: null,
        error: ClearErrorResponse(
          message:
              'Call .select() choosing one between id and name before this.',
        ),
      );
    } else if (_collectionName != null) {
      return _doc.deleteDocumentByCollName(_collectionName!);
    } else {
      return _doc.deleteDocument(_collectionId!);
    }
  }

  /// Detect realtime changes on the current document
  Future<RealtimeHandler> on({
    final StreamAction action = StreamAction.all,
    final dynamic Function(SocketChangeEvent)? callback,
  }) {
    if (_collectionName == null && _collectionId == null) {
      throw Exception(
        'Call .select() choosing one between id and name before this.',
      );
    } else if (_collectionName != null) {
      return _realtime.on(
        action: action,
        collectionName: _collectionName,
        documentId: _rowId,
        callback: callback,
      );
    } else {
      return _realtime.on(
        action: action,
        collectionId: _collectionId,
        documentId: _rowId,
        callback: callback,
      );
    }
  }

  /// Update the document
  Future<ClearResponse<Map<String, dynamic>?, ClearErrorResponse?>> update(
    final Map<String, dynamic> content,
  ) async {
    if (_collectionName == null && _collectionId == null) {
      return ClearResponse(
        data: null,
        error: ClearErrorResponse(
          message:
              'Call .select() choosing one between id and name before this.',
        ),
      );
    } else if (_collectionName != null) {
      return _doc.updateDocumentByCollName(_collectionName!, content);
    } else {
      return _doc.updateDocument(_collectionId!, content);
    }
  }
}
