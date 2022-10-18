import 'dart:convert';

import 'package:teta_cms/src/mappers/product_mapper.dart';
import 'package:teta_cms/src/models/response.dart';

class TransactionsMapper {
  TransactionsMapper(this.productMapper);

  final ProductMapper productMapper;

  List<TransactionModel> mapTransactions(
          final List<Map<String, dynamic>> json) =>
      json.map(mapTransaction).toList(
            growable: true,
          );

  TransactionModel mapTransaction(Map<String, dynamic> json) {
    return TransactionModel(
      userId: json['user_id'] as String,
      paymentIntentId: json['paymentIntentId'] as String,
      state: json['state'] as String,
      ammount: json['amount'] as String,
      items: productMapper.mapProducts(
        jsonDecode(json['items'] as String) as List<Map<String, dynamic>>,
      ),
    );
  }
}
