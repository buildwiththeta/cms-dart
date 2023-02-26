import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:teta_cms/src/constants.dart';
import 'package:teta_cms/src/mappers/product_mapper.dart';
import 'package:teta_cms/src/use_cases/get_server_request_headers/get_server_request_headers.dart';
import 'package:teta_cms/teta_cms.dart';

/// Carts api
@lazySingleton
class TetaStoreCartsApi {
  /// Carts api
  TetaStoreCartsApi(
    this._getServerRequestHeaders,
    this._dio,
    this._productMapper,
  );

  final GetServerRequestHeaders _getServerRequestHeaders;
  final Dio _dio;
  final ProductMapper _productMapper;

  /// Gets a cart by userId
  Future<TetaProductsResponse> get() async {
    final cmsUserId = (await TetaCMS.instance.auth.user.get).uid;

    final uri = Uri.parse(
      '${Constants.shopBaseUrl}/cart/$cmsUserId',
    );

    final res = await http.get(
      uri,
      headers: _getServerRequestHeaders.execute(),
    );

    if (res.statusCode != 200) {
      return TetaProductsResponse(
        error: TetaErrorResponse(
          code: res.statusCode,
          message: res.body,
        ),
      );
    }

    final decodedList = (jsonDecode(res.body) as List<dynamic>)
        .map((final dynamic e) => e as Map<String, dynamic>)
        .toList(growable: false);

    return TetaProductsResponse(
      data: _productMapper.mapProducts(
        decodedList,
      ),
    );
  }

  /// Adds the product to the cart of the given userId
  Future<TetaResponse> insert(
    final String productId,
  ) async {
    final userId = (await TetaCMS.instance.auth.user.get).uid;

    final uri = Uri.parse(
      '${Constants.shopBaseUrl}/cart/$userId/$productId',
    );

    final res = await http.post(
      uri,
      headers: _getServerRequestHeaders.execute(),
    );

    TetaCMS.printWarning('insert product body: ${res.body}');

    if (res.statusCode != 200) {
      return TetaResponse<dynamic, TetaErrorResponse>(
        error: TetaErrorResponse(
          code: res.statusCode,
          message: res.body,
        ),
        data: null,
      );
    }

    return TetaResponse<String, dynamic>(
      data: json.encode(res.body),
      error: null,
    );
  }

  /// Deletes a product by id
  Future<TetaResponse> delete(final String prodId) async {
    final userId = (await TetaCMS.instance.auth.user.get).uid;

    final uri = Uri.parse(
      '${Constants.shopBaseUrl}/cart/$userId/$prodId',
    );

    final res = await http.delete(
      uri,
      headers: _getServerRequestHeaders.execute(),
    );

    if (res.statusCode != 200) {
      return TetaResponse<dynamic, TetaErrorResponse>(
        error: TetaErrorResponse(
          code: res.statusCode,
          message: res.body,
        ),
        data: null,
      );
    }

    return TetaResponse<String, dynamic>(
      data: json.encode(res.body),
      error: null,
    );
  }

  /// Get required data to buy the items from the cart
  Future<TetaPaymentIntentResponse> getPaymentIntent(
    final String shippingId,
    final UserAddress userAddress,
  ) async {
    final userId = (await TetaCMS.instance.auth.user.get).uid;

    try {
      final res = await _dio.post<String>(
        '${Constants.shopBaseUrl}/cart/$userId/buy',
        options: Options(
          headers: _getServerRequestHeaders.execute(),
        ),
        data: jsonEncode(
          <String, dynamic>{
            'shipping_id': shippingId,
          }..addAll(userAddress.toJson()),
        ),
      );

      if (200 != res.statusCode) {
        return TetaPaymentIntentResponse(
          error: TetaErrorResponse(
            code: res.statusCode,
            message: res.data,
          ),
        );
      }
      final jsonDecoded = jsonDecode(res.data!) as Map<String, dynamic>;
      final paymentIntentData = PaymentIntentData(
        paymentIntent: jsonDecoded['paymentIntentId'] as String,
        paymentIntentClientSecret:
            jsonDecoded['paymentIntentClientSecret'] as String,
        stripePublishableKey: jsonDecoded['stripe_publishable_key'] as String,
        merchantIdentifier: jsonDecoded['stripe_user_id'] as String,
      );
      return TetaPaymentIntentResponse(
        data: paymentIntentData,
      );
    } catch (e) {
      return TetaPaymentIntentResponse(
        error: TetaErrorResponse(message: e.toString(), code: 403),
      );
    }
  }
}
