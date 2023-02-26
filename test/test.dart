// ignore_for_file: avoid_redundant_argument_values

import 'package:teta_cms/src/models/stream_actions.dart';
import 'package:teta_cms/teta_cms.dart';

Future<void> insert(final List<String> args) async {
  const collectionId = '0';
  await TetaCMS.I.db.from('users').insert(
    <String, dynamic>{'name': 'Giulia', 'city': 'Roma'},
  );
}

Future<void> update(final List<String> args) async {
  await TetaCMS.I.db.fromId('').doc('id').update(
    <String, dynamic>{'name': 'Alessia', 'city': 'Milano'},
  );
}

Future<void> delete(final List<String> args) async {
  const collectionName = '0';
  const documentId = '0';
  await TetaCMS.I.db.from(collectionName).doc(documentId).delete();
}

Future<void> createCollectionByName(final List<String> args) async {
  const collectionName = '0';
  await TetaCMS.I.db.createCollection(
    collectionName,
  );
}

Future<void> updateCollection(final List<String> args) async {
  const newName = '0';
  await TetaCMS.I.db.from('users').update(
    newName,
    <String, dynamic>{
      'key': 'value',
      'key1': 'value1',
    },
  );
}

Future<void> deleteCollection(final List<String> args) async {
  await TetaCMS.I.db.from('users').delete();
}

Future<void> getCollection(final List<String> args) async {
  await TetaCMS.I.db.from('posts').get();
}

Future<void> streamCollection(final List<String> args) async {
  final sub = TetaCMS.I.db.from('posts').stream();
  await sub.close();
}

Future<void> getCollectionCount(final List<String> args) async {
  await TetaCMS.I.db.from('posts').count();
}

Future<void> getCollectionChanges(final List<String> args) async {
  await TetaCMS.I.db.from('posts').on(
        action: StreamAction.all,
        callback: (final e) {},
      );
}

Future<void> getDocumentChanges(final List<String> args) async {
  const docId = '0';
  await TetaCMS.I.db.from('posts').doc(docId).on(
        action: StreamAction.updateDoc,
        callback: (final e) {},
      );
}
