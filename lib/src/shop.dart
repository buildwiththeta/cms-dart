import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:teta_cms/src/constants.dart';
import 'package:teta_cms/src/data_stores/local/server_request_metadata_store.dart';
import 'package:teta_cms/src/mappers/credentials_mapper.dart';
import 'package:teta_cms/src/mappers/shipping_mapper.dart';
import 'package:teta_cms/src/mappers/shop_settings_mapper.dart';
import 'package:teta_cms/src/mappers/transactions_mapper.dart';
import 'package:teta_cms/src/models/store/credentials.dart';
import 'package:teta_cms/src/models/store/shipping.dart';
import 'package:teta_cms/src/models/store/shop_settings.dart';
import 'package:teta_cms/src/store/carts_api.dart';
import 'package:teta_cms/src/store/products_api.dart';
import 'package:teta_cms/src/use_cases/get_server_request_headers/get_server_request_headers.dart';
import 'package:teta_cms/teta_cms.dart';

/// Teta Store - Control your ecommerce
@lazySingleton
class TetaShop {
  /// Teta Store - Control your ecommerce
  TetaShop(
    this._getServerRequestHeaders,
    this.products,
    this.cart,
    this._transactionsMapper,
    this._credentialsMapper,
    this._shippingMapper,
    this._shopSettingsMapper,
    this._metadataStore,
  );

  /// Headers
  final GetServerRequestHeaders _getServerRequestHeaders;

  /// Products apis
  final TetaStoreProductsApi products;

  /// Cart apis
  final TetaStoreCartsApi cart;

  /// Transactions mapper
  final TransactionsMapper _transactionsMapper;

  /// Credentials mapper
  final CredentialsMapper _credentialsMapper;

  /// Shipping mapper
  final ShippingMapper _shippingMapper;

  final ShopSettingsMapper _shopSettingsMapper;

  final ServerRequestMetadataStore _metadataStore;

  /// Gets all the transactions for shop linked to this project id
  Future<TetaTransactionsResponse> transactions() async {
    try {
      final uri = Uri.parse(
        '${Constants.shopBaseUrl}/shop/transactions',
      );

      final res = await http.get(
        uri,
        headers: _getServerRequestHeaders.execute(),
      );

      if (res.statusCode != 200) {
        return TetaTransactionsResponse(
          error: TetaErrorResponse(
            code: res.statusCode,
            message: res.body,
          ),
        );
      }

      final decodedList = (jsonDecode(res.body) as List<dynamic>)
          .map((final dynamic e) => e as Map<String, dynamic>)
          .toList(growable: false);

      final transactions =
      _transactionsMapper.mapTransactions(decodedList);

      final prjId = _metadataStore
          .getMetadata()
          .prjId;

      final filteredTransactions = transactions
          .where((final transaction) => transaction.prjId == prjId)
          .toList(
        growable: true,
      );

      return TetaTransactionsResponse(
        data: transactions,
      );
    } catch (e, st) {
      return TetaTransactionsResponse(
        error: TetaErrorResponse(
          code: 400,
          message: 'Transaction error: ${e.toString()} \nStack trace: ${st.toString()}',
        ),
      );
    }
  }

  /// Gets all the transactions for user linked to this project id
  Future<TetaTransactionsResponse> transactionsForUser() async {
    final userId = (await TetaCMS.instance.auth.user.get).uid;

    final uri = Uri.parse(
      '${Constants.shopBaseUrl}/user/$userId/transactions',
    );

    final res = await http.get(
      uri,
      headers: _getServerRequestHeaders.execute(),
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

    final transactions =
        _transactionsMapper.mapTransactions(responseBodyDecoded);
    final prjId = _metadataStore.getMetadata().prjId;
    return TetaTransactionsResponse(
      data: transactions
          .where((final transaction) => transaction.prjId == prjId)
          .toList(
            growable: true,
          ),
    );
  }

  /// Check if a payment was successfully
  Future<TetaResponse> checkPayment(final String paymentIntentId) async {
    final userId = (await TetaCMS.instance.auth.user.get).uid;

    final uri = Uri.parse(
      '${Constants.shopBaseUrl}/shop/transactions/$paymentIntentId/check',
    );

    final res = await http.get(
      uri,
      headers: _getServerRequestHeaders.execute(),
    );

    if (res.statusCode != 200) {
      return TetaResponse<dynamic, dynamic>(
        error: TetaErrorResponse(
          code: res.statusCode,
          message: res.body,
        ),
        data: null,
      );
    }

    return TetaResponse<dynamic, dynamic>(
      data: null,
      error: null,
    );
  }

  /// Gets all the store's transactions
  Future<TetaShippingResponse> getShippingMethods() async {
    final uri = Uri.parse(
      '${Constants.shopBaseUrl}/shipping/list',
    );

    final res = await http.get(
      uri,
      headers: _getServerRequestHeaders.execute(),
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
      data: _shippingMapper.mapShippings(responseBodyDecoded),
    );
  }

  /// Add a shipping method
  Future<TetaShippingResponse> addShippingMethod(
    final Shipping shipping,
  ) async {
    final uri = Uri.parse(
      '${Constants.shopBaseUrl}/shipping',
    );

    final res = await http.post(
      uri,
      headers: _getServerRequestHeaders.execute(),
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
      '${Constants.shopBaseUrl}/shipping/${shipping.id}',
    );

    final res = await http.put(
      uri,
      headers: _getServerRequestHeaders.execute(),
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
      '${Constants.shopBaseUrl}/shipping/$shippingId',
    );

    final res = await http.delete(
      uri,
      headers: _getServerRequestHeaders.execute(),
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
      '${Constants.shopBaseUrl}/shop/credentials',
    );

    final res = await http.get(
      uri,
      headers: _getServerRequestHeaders.execute(),
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
    final mappedCredentials = _credentialsMapper.mapCredentials(responseBodyDecoded);
    return TetaCredentialsResponse(
      data: mappedCredentials,
    );
  }

  /// Init shop
  Future<TetaResponse> createShop() async {
    final uri = Uri.parse(
      '${Constants.shopBaseUrl}/shop',
    );

    final res = await http.post(
      uri,
      headers: _getServerRequestHeaders.execute(),
    );

    if (res.statusCode != 200) {
      return TetaResponse<dynamic, dynamic>(
        error: TetaErrorResponse(
          code: res.statusCode,
          message: res.body,
        ),
        data: null,
      );
    }

    return TetaResponse<dynamic, dynamic>(
      data: null,
      error: null,
    );
  }

  /// Get shop credentials
  Future<TetaCredentialsResponse> updateShopCredentials(
    final ShopCredentials shopCredentials,
  ) async {
    final uri = Uri.parse(
      '${Constants.shopBaseUrl}/shop/credentials',
    );

    final res = await http.put(
      uri,
      headers: _getServerRequestHeaders.execute(),
      body: jsonEncode(shopCredentials),
    );

    if (res.statusCode != 200) {
      return TetaCredentialsResponse(
        error: TetaErrorResponse(
          code: res.statusCode,
          message: res.body,
        ),
      );
    }

    return TetaCredentialsResponse(
      data: shopCredentials,
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

  /// Sets shop settings
  Future<TetaShopSettingsResponse> setSettings(
      final ShopSettings shopSettings) async {
    final uri = Uri.parse(
      '${Constants.shopBaseUrl}/shop/settings',
    );

    final res = await http.put(
      uri,
      headers: _getServerRequestHeaders.execute(),
      body: jsonEncode(shopSettings)
    );

    if (res.statusCode != 200) {
      return TetaShopSettingsResponse(
        error: TetaErrorResponse(
          code: res.statusCode,
          message: res.body,
        ),
      );
    }

    return TetaShopSettingsResponse(
      data: shopSettings,
    );
  }

  /// Get shop settings
  Future<TetaShopSettingsResponse> getSettings() async {
    final uri = Uri.parse(
      '${Constants.shopBaseUrl}/shop/settings',
    );

    final res = await http.get(
      uri,
      headers: _getServerRequestHeaders.execute(),
    );

    if (res.statusCode != 200) {
      return TetaShopSettingsResponse(
        error: TetaErrorResponse(
          code: res.statusCode,
          message: res.body,
        ),
      );
    }
    final resBodyMap = jsonDecode(res.body) as Map<String, dynamic>;

    return TetaShopSettingsResponse(
      data: _shopSettingsMapper.mapSettings(resBodyMap),
    );
  }

  /// Sets a new status for the transaction
  Future<TetaResponse> setTransactionStatus(final String status) async {
    final uri = Uri.parse(
      '${Constants.shopBaseUrl}/currency/$status',
    );

    final res = await http.put(
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
}
