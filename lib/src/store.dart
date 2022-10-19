import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:teta_cms/src/constants.dart';
import 'package:teta_cms/src/mappers/credentials_mapper.dart';
import 'package:teta_cms/src/mappers/shipping_mapper.dart';
import 'package:teta_cms/src/mappers/transactions_mapper.dart';
import 'package:teta_cms/src/models/store/credentials.dart';
import 'package:teta_cms/src/models/store/shipping.dart';
import 'package:teta_cms/src/store/carts_api.dart';
import 'package:teta_cms/src/store/products_api.dart';
import 'package:teta_cms/src/use_cases/get_server_request_headers/get_server_request_headers.dart';
import 'package:teta_cms/teta_cms.dart';

/// Teta Store - Control your ecommerce
class TetaStore {
  /// Teta Store - Control your ecommerce
  TetaStore(
    this.getServerRequestHeaders,
    this.products,
    this.cart,
    this.transactionsMapper,
    this.credentialsMapper,
    this.shippingMapper,
  );

  /// Headers
  final GetServerRequestHeaders getServerRequestHeaders;

  /// Products apis
  final TetaStoreProductsApi products;

  /// Cart apis
  final TetaStoreCartsApi cart;

  /// Transactions mapper
  final TransactionsMapper transactionsMapper;

  /// Credentials mapper
  final CredentialsMapper credentialsMapper;

  /// Shipping mapper
  final ShippingMapper shippingMapper;

  /// Gets products of the current cart
  Future<TetaProductsResponse> getCartProducts() async {
    try {
      final cartResponse = await cart.get();
      final cartProducts = <TetaProduct>[];
      for (final element in cartResponse.data!.content) {
        cartProducts.add((await products.get(element.prodId)).data!);
      }
      return TetaProductsResponse(
        data: cartProducts,
      );
    } catch (e) {
      return TetaProductsResponse(
        error: TetaErrorResponse(
          code: 403,
          message: e.toString(),
        ),
      );
    }
  }

  /// Gets all the store's transactions
  Future<TetaTransactionsResponse> transactions() async {
    final uri = Uri.parse(
      '${Constants.storeUrl}transactions',
    );

    final res = await http.get(
      uri,
      headers: getServerRequestHeaders.execute(),
    );

    if (res.statusCode != 200) {
      return TetaTransactionsResponse(
        error: TetaErrorResponse(
          code: res.statusCode,
          message: res.body,
        ),
      );
    }

    final responseBodyDecoded =
        jsonDecode(res.body) as List<Map<String, dynamic>>;

    return TetaTransactionsResponse(
      data: transactionsMapper.mapTransactions(responseBodyDecoded),
    );
  }

  /// Gets all the store's transactions
  Future<TetaShippingResponse> getShippingMethods() async {
    final uri = Uri.parse(
      '${Constants.storeUrl}shipping/list',
    );

    final res = await http.get(
      uri,
      headers: getServerRequestHeaders.execute(),
    );

    if (res.statusCode != 200) {
      return TetaShippingResponse(
        error: TetaErrorResponse(
          code: res.statusCode,
          message: res.body,
        ),
      );
    }

    final responseBodyDecoded =
        jsonDecode(res.body) as List<Map<String, dynamic>>;

    return TetaShippingResponse(
      data: shippingMapper.mapShippings(responseBodyDecoded),
    );
  }

  /// Add a shipping method
  Future<TetaShippingResponse> addShippingMethod(
    final Shipping shipping,
  ) async {
    final uri = Uri.parse(
      '${Constants.storeUrl}shipping',
    );

    final res = await http.post(
      uri,
      headers: getServerRequestHeaders.execute(),
      body: jsonEncode(
        shipping.toJson(),
      ),
    );

    if (res.statusCode != 200) {
      return TetaShippingResponse(
        error: TetaErrorResponse(
          code: res.statusCode,
          message: res.body,
        ),
      );
    }

    return TetaShippingResponse();
  }

  /// Update a shipping method
  Future<TetaShippingResponse> updateShippingMethod(
    final Shipping shipping,
  ) async {
    final uri = Uri.parse(
      '${Constants.storeUrl}shipping/${shipping.id}',
    );

    final res = await http.put(
      uri,
      headers: getServerRequestHeaders.execute(),
      body: jsonEncode(
        shipping.toJson(),
      ),
    );

    if (res.statusCode != 200) {
      return TetaShippingResponse(
        error: TetaErrorResponse(
          code: res.statusCode,
          message: res.body,
        ),
      );
    }

    return TetaShippingResponse();
  }

  /// Delete a shipping method
  Future<TetaShippingResponse> deleteShippingMethod(
    final String shippingId,
  ) async {
    final uri = Uri.parse(
      '${Constants.storeUrl}shipping/$shippingId',
    );

    final res = await http.delete(
      uri,
      headers: getServerRequestHeaders.execute(),
    );

    if (res.statusCode != 200) {
      return TetaShippingResponse(
        error: TetaErrorResponse(
          code: res.statusCode,
          message: res.body,
        ),
      );
    }

    return TetaShippingResponse();
  }

  /// Get shop credentials
  Future<TetaCredentialsResponse> getShopCredentials() async {
    final uri = Uri.parse(
      '${Constants.storeUrl}shop/credentials',
    );

    final res = await http.get(
      uri,
      headers: getServerRequestHeaders.execute(),
    );

    if (res.statusCode != 200) {
      return TetaCredentialsResponse(
        error: TetaErrorResponse(
          code: res.statusCode,
          message: res.body,
        ),
      );
    }

    final responseBodyDecoded = jsonDecode(res.body) as Map<String, dynamic>;

    return TetaCredentialsResponse(
      data: credentialsMapper.mapCredentials(responseBodyDecoded),
    );
  }

  /// Get shop credentials
  Future<TetaCredentialsResponse> updateShopCredentials(
    final ShopCredentials shopCredentials,
  ) async {
    final uri = Uri.parse(
      '${Constants.storeUrl}shop/credentials',
    );

    final res = await http.put(
      uri,
      headers: getServerRequestHeaders.execute(),
      body: jsonEncode(shopCredentials.toJson()),
    );

    if (res.statusCode != 200) {
      return TetaCredentialsResponse(
        error: TetaErrorResponse(
          code: res.statusCode,
          message: res.body,
        ),
      );
    }

    final responseBodyDecoded = jsonDecode(res.body) as Map<String, dynamic>;

    return TetaCredentialsResponse(
      data: credentialsMapper.mapCredentials(responseBodyDecoded),
    );
  }

  /// Gets all the store's transactions for a user
  Future<TetaTransactionsResponse> transactionsForUser() async {
    final uri = Uri.parse(
      '${Constants.storeUrl}user/transactions',
    );

    final res = await http.get(
      uri,
      headers: getServerRequestHeaders.execute(),
    );

    if (res.statusCode != 200) {
      return TetaTransactionsResponse(
        error: TetaErrorResponse(
          code: res.statusCode,
          message: res.body,
        ),
      );
    }

    final responseBodyDecoded =
        jsonDecode(res.body) as List<Map<String, dynamic>>;

    return TetaTransactionsResponse(
      data: transactionsMapper.mapTransactions(responseBodyDecoded),
    );
  }

  /// Gets all the store's transactions for a user
  Future<TetaReceiptResponse> getReceiptLink(
      final String paymentIntentId) async {
    final token = (await getShopCredentials()).data!.accessToken;

    final uri = Uri.parse(
      'https://api.stripe.com/v1/payment_intents/$paymentIntentId',
    );

    final res = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (res.statusCode != 200) {
      return TetaReceiptResponse(
        error: TetaErrorResponse(
          code: res.statusCode,
          message: res.body,
        ),
      );
    }

    final responseBodyDecoded = jsonDecode(res.body) as Map<String, dynamic>;

    final receiptUrl = (responseBodyDecoded['charges']['data']
            as List<Map<String, dynamic>>)[0]['receipt_url'] as String? ??
        '';
    return TetaReceiptResponse(
      data: receiptUrl,
    );
  }

  /// Delete a store
  Future<TetaResponse> delete() async {
    final uri = Uri.parse(
      Constants.storeUrl,
    );

    final res = await http.delete(
      uri,
      headers: getServerRequestHeaders.execute(),
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

  /// Sets a new currency
  Future<TetaResponse> setCurrency(final String currency) async {
    final uri = Uri.parse(
      '${Constants.storeUrl}currency/$currency',
    );

    final res = await http.put(
      uri,
      headers: getServerRequestHeaders.execute(),
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

  /// Sets a new status for the transaction
  Future<TetaResponse> setTransactionStatus(final String status) async {
    final uri = Uri.parse(
      '${Constants.storeUrl}currency/$status',
    );

    final res = await http.put(
      uri,
      headers: getServerRequestHeaders.execute(),
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
}
