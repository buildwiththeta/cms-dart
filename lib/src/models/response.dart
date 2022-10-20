import 'package:teta_cms/src/models/store/credentials.dart';
import 'package:teta_cms/src/models/store/product.dart';
import 'package:teta_cms/src/models/store/shipping.dart';
import 'package:teta_cms/src/models/store/shop_settings.dart';

class TetaResponse<DATA, ERROR> {
  TetaResponse({
    required this.data,
    required this.error,
  });

  final DATA data;
  final ERROR error;
}

class TetaErrorResponse {
  TetaErrorResponse({
    this.message,
    this.code,
  });

  final String? message;
  final int? code;
}

class TetaProductResponse
    extends TetaResponse<TetaProduct?, TetaErrorResponse?> {
  TetaProductResponse({
    final TetaProduct? data,
    final TetaErrorResponse? error,
  }) : super(data: data, error: error);
}

class TetaProductsResponse
    extends TetaResponse<List<TetaProduct>?, TetaErrorResponse?> {
  TetaProductsResponse({
    final List<TetaProduct>? data,
    final TetaErrorResponse? error,
  }) : super(data: data, error: error);
}

class TetaPaymentIntentResponse
    extends TetaResponse<PaymentIntentData?, TetaErrorResponse?> {
  TetaPaymentIntentResponse({
    final PaymentIntentData? data,
    final TetaErrorResponse? error,
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

class TetaCredentialsResponse
    extends TetaResponse<ShopCredentials?, TetaErrorResponse?> {
  TetaCredentialsResponse({
    final ShopCredentials? data,
    final TetaErrorResponse? error,
  }) : super(data: data, error: error);
}

class TetaReceiptResponse extends TetaResponse<String?, TetaErrorResponse?> {
  TetaReceiptResponse({
    final String? data,
    final TetaErrorResponse? error,
  }) : super(data: data, error: error);
}

class TetaTransactionsResponse
    extends TetaResponse<List<TransactionModel>?, TetaErrorResponse?> {
  TetaTransactionsResponse({
    final List<TransactionModel>? data,
    final TetaErrorResponse? error,
  }) : super(data: data, error: error);
}

class TetaShippingResponse
    extends TetaResponse<List<Shipping>?, TetaErrorResponse?> {
  TetaShippingResponse({
    final List<Shipping>? data,
    final TetaErrorResponse? error,
  }) : super(data: data, error: error);
}

class TetaShopSettingsResponse
    extends TetaResponse<ShopSettings?, TetaErrorResponse?> {
  TetaShopSettingsResponse({
    final ShopSettings? data,
    final TetaErrorResponse? error,
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
  final List<TetaProduct> items;
}
