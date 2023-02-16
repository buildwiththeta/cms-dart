import 'package:teta_cms/teta_cms.dart';

Future<void> insert(final List<String> args) async {
  const collectionId = '0';
  await TetaCMS.instance.client.insertDocument(
    collectionId,
    <String, dynamic>{'name': 'Giulia', 'city': 'Roma'},
  );
}

Future<void> insertByCollName(final List<String> args) async {
  const collectionName = 'abc';
  await TetaCMS.instance.client.insertDocumentByCollName(
    collectionName,
    <String, dynamic>{'name': 'Giulia', 'city': 'Roma'},
  );
}

Future<void> update(final List<String> args) async {
  const collectionId = '0';
  const documentId = '0';
  await TetaCMS.instance.client.updateDocument(
    collectionId,
    documentId,
    <String, dynamic>{'name': 'Alessia', 'city': 'Milano'},
  );
}

Future<void> delete(final List<String> args) async {
  const collectionId = '0';
  const documentId = '0';
  await TetaCMS.instance.client.deleteDocument(
    collectionId,
    documentId,
  );
}

Future<void> createCollection(final List<String> args) async {
  const collectionName = '0';
  await TetaCMS.instance.client.createCollection(
    collectionName,
  );
}

Future<void> updateCollection(final List<String> args) async {
  const collectionId = '0';
  const newName = '0';
  await TetaCMS.instance.client.updateCollection(
    collectionId,
    newName,
    <String, dynamic>{'key': 'value', 'key1': 'value1'},
  );
}

Future<void> deleteCollection(final List<String> args) async {
  const collectionId = '0';
  await TetaCMS.instance.client.deleteCollection(
    collectionId,
  );
}
