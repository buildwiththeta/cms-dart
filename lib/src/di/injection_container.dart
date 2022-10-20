import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:teta_cms/src/data_stores/local/server_request_metadata_store.dart';
import 'package:teta_cms/src/mappers/credentials_mapper.dart';
import 'package:teta_cms/src/mappers/product_mapper.dart';
import 'package:teta_cms/src/mappers/shipping_mapper.dart';
import 'package:teta_cms/src/mappers/shop_settings_mapper.dart';
import 'package:teta_cms/src/mappers/transactions_mapper.dart';
import 'package:teta_cms/src/shop.dart';
import 'package:teta_cms/src/store/carts_api.dart';
import 'package:teta_cms/src/store/products_api.dart';
import 'package:teta_cms/src/use_cases/get_server_request_headers/get_server_request_headers.dart';

/// Instance
final sl = GetIt.instance;

/// Flag is initialized
bool diInitialized = false;

/// Initialize GetIt
void initGetIt() {
  // 3-rd party libraries
  sl
    ..registerLazySingleton(Dio.new)

    //Data Stores
    ..registerLazySingleton(ServerRequestMetadataStore.new)

    //Server Response Mappers
    ..registerLazySingleton(ProductMapper.new)
    ..registerLazySingleton(CredentialsMapper.new)
    ..registerLazySingleton(() => TransactionsMapper(sl()))
    ..registerLazySingleton(ShippingMapper.new)
    ..registerLazySingleton(ShopSettingsMapper.new)

    //Use Cases
    ..registerLazySingleton(() => GetServerRequestHeaders(sl()))

    // API
    ..registerLazySingleton(() => TetaStoreCartsApi(sl(), sl(), sl()))
    ..registerLazySingleton(() => TetaStoreProductsApi(sl(), sl(), sl()))
    ..registerLazySingleton(
      () => TetaShop(
        sl(),
        sl(),
        sl(),
        sl(),
        sl(),
        sl(),
        sl(),
        sl(),
      ),
    );
}
