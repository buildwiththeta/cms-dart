import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:teta_cms/teta_cms.dart';

void main() {
  if (true) {
    test(
      'Put new collection',
      () async {
        await TetaCMS.instance.client.createCollection(
          98521,
          'Collection 1',
        );
      },
    );
  }
  test(
    'Get collections',
    () async {
      final collections = await TetaCMS.instance.client.getCollections(1);
      final firstCollection = await TetaCMS.instance.client.getCollection(
        1,
        collections.first.id,
      );
      debugPrint('$firstCollection');
    },
  );
}
