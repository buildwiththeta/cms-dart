import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:teta_cms/src/mappers/product_mapper.dart';
import 'package:teta_cms/src/models/response.dart';

@lazySingleton
class TransactionsMapper {
  TransactionsMapper(this._productMapper);

  final ProductMapper _productMapper;

  List<TransactionModel> mapTransactions(
          final List<Map<String, dynamic>> json) =>
      json.map(mapTransaction).toList(
            growable: true,
          );

  TransactionModel mapTransaction(Map<String, dynamic> json) {
    final decodedList = (json['items']  as List<dynamic>)
        .map((final dynamic e) => e as Map<String, dynamic>)
        .toList(growable: false);

    return TransactionModel(
      userId: json['user_id'] as String,
      prjId: json['prj_id'] as int,
      paymentIntentId: json['paymentIntentId'] as String,
      state: json['state'] as String,
      ammount: json['amount'] as String,
      items: _productMapper.mapProducts(
        decodedList,
      ),
    );
  }
}
