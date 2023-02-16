part of '../index.dart';

class SocketChangeEvent {
  SocketChangeEvent();

  SocketChangeEvent.fromJson(final Map<String, dynamic> json)
      : action = json['action'] as String,
        collectionId = json['collection_id'] as String,
        collectionName = json['collection_name'] as String,
        prjId = json['prj_id'] as String?,
        documentId = json['document_id'] as String?,
        type = json['type'] as String;

  late String action;
  late String collectionId;
  late String collectionName;
  String? prjId;
  String? documentId;
  late String type;
}
