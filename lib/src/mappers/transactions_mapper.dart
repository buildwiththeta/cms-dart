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
    return TransactionModel(
      userId: json['user_id'] as String,
      prjId: json['prj_id'] as int,
      paymentIntentId: json['paymentIntentId'] as String,
      state: json['state'] as String,
      ammount: json['amount'] as String,
      items: _productMapper.mapProducts(
        jsonDecode(json['items'] as String) as List<Map<String, dynamic>>,
      ),
    );
  }
}
