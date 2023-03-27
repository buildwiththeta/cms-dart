import 'package:clear_response/clear_response.dart';
import 'package:teta_cms/src/models/store/credentials.dart';
import 'package:teta_cms/src/models/store/product.dart';
import 'package:teta_cms/src/models/store/shipping.dart';
import 'package:teta_cms/src/models/store/shop_settings.dart';

class ProductResponse extends ClearResponse<Product?, ClearErrorResponse?> {
  ProductResponse({
    final Product? data,
    final ClearErrorResponse? error,
  }) : super(data: data, error: error);
}

class ProductsResponse
    extends ClearResponse<List<Product>?, ClearErrorResponse?> {
  ProductsResponse({
    final List<Product>? data,
    final ClearErrorResponse? error,
  }) : super(data: data, error: error);
}

class PaymentIntentResponse
    extends ClearResponse<PaymentIntentData?, ClearErrorResponse?> {
  PaymentIntentResponse({
    final PaymentIntentData? data,
    final ClearErrorResponse? error,
  }) : super(data: data, error: error);
}

class PaymentIntentData {
  PaymentIntentData({
    required this.paymentIntent,
    required this.paymentIntentClientSecret,
    required this.stripePublishableKey,
    required this.merchantIdentifier,
  });

  final String paymentIntent;
  final String paymentIntentClientSecret;
  final String stripePublishableKey;
  final String merchantIdentifier;
}

class CredentialsResponse
    extends ClearResponse<ShopCredentials?, ClearErrorResponse?> {
  CredentialsResponse({
    final ShopCredentials? data,
    final ClearErrorResponse? error,
  }) : super(data: data, error: error);
}

class ReceiptResponse extends ClearResponse<String?, ClearErrorResponse?> {
  ReceiptResponse({
    final String? data,
    final ClearErrorResponse? error,
  }) : super(data: data, error: error);
}

class TransactionsResponse
    extends ClearResponse<List<TransactionModel>?, ClearErrorResponse?> {
  TransactionsResponse({
    final List<TransactionModel>? data,
    final ClearErrorResponse? error,
  }) : super(data: data, error: error);
}

class ShippingResponse
    extends ClearResponse<List<Shipping>?, ClearErrorResponse?> {
  ShippingResponse({
    final List<Shipping>? data,
    final ClearErrorResponse? error,
  }) : super(data: data, error: error);
}

class ShopSettingsResponse
    extends ClearResponse<ShopSettings?, ClearErrorResponse?> {
  ShopSettingsResponse({
    final ShopSettings? data,
    final ClearErrorResponse? error,
  }) : super(data: data, error: error);
}

class TransactionModel {
  TransactionModel({
    required this.userId,
    required this.prjId,
    required this.paymentIntentId,
    required this.state,
    required this.ammount,
    required this.items,
  });

  final String userId;
  final int prjId;
  final String paymentIntentId;
  final String state;
  final String ammount;
  final List<Product> items;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'user_id': userId,
        'prj_id': prjId,
        'paymentIntentId': paymentIntentId,
        'state': state,
        'amount': ammount,
      };
}
