// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i5;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:teta_cms/src/analytics.dart' as _i10;
import 'package:teta_cms/src/auth.dart' as _i20;
import 'package:teta_cms/src/client.dart' as _i21;
import 'package:teta_cms/src/core/di/modules/base_url.dart' as _i3;
import 'package:teta_cms/src/core/di/modules/dio_module.dart' as _i25;
import 'package:teta_cms/src/data_stores/local/server_request_metadata_store.dart'
    as _i8;
import 'package:teta_cms/src/db/backups.dart' as _i11;
import 'package:teta_cms/src/db/policy.dart' as _i14;
import 'package:teta_cms/src/features/store/data/data_sources/remote/products_api.dart'
    as _i7;
import 'package:teta_cms/src/features/store/data/data_sources/remote/products_api_module.dart'
    as _i26;
import 'package:teta_cms/src/features/store/data/repositories/products_repo.dart'
    as _i19;
import 'package:teta_cms/src/index.dart' as _i16;
import 'package:teta_cms/src/mappers/cart_mapper.dart' as _i4;
import 'package:teta_cms/src/mappers/product_mapper.dart' as _i6;
import 'package:teta_cms/src/mappers/shop_mapper.dart' as _i9;
import 'package:teta_cms/src/store.dart' as _i24;
import 'package:teta_cms/src/store/carts_api.dart' as _i22;
import 'package:teta_cms/src/store/products_api.dart' as _i23;
import 'package:teta_cms/src/use_cases/get_server_request_headers/get_server_request_headers.dart'
    as _i18;
import 'package:teta_cms/src/users/email.dart' as _i13;
import 'package:teta_cms/src/users/settings.dart' as _i15;
import 'package:teta_cms/src/users/user.dart' as _i17;
import 'package:teta_cms/src/utils.dart' as _i12;

const String _prod = 'prod';
// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(
  _i1.GetIt get, {
  String? environment,
  _i2.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i2.GetItHelper(
    get,
    environment,
    environmentFilter,
  );
  final dioModule = _$DioModule();
  final productsApiModule = _$ProductsApiModule();
  gh.factory<_i3.BaseUrl>(
    () => _i3.ProdBaseUrl(),
    registerFor: {_prod},
  );
  gh.lazySingleton<_i4.CartMapper>(() => _i4.CartMapper());
  gh.factory<_i5.Dio>(() => dioModule.dio);
  gh.lazySingleton<_i6.ProductMapper>(() => _i6.ProductMapper());
  gh.factory<_i7.ProductsApi>(() => productsApiModule.get(
        get<_i5.Dio>(),
        get<_i3.BaseUrl>(),
      ));
  gh.lazySingleton<_i8.ServerRequestMetadataStore>(
      () => _i8.ServerRequestMetadataStore());
  gh.lazySingleton<_i9.ShopMapper>(() => _i9.ShopMapper(
        get<_i6.ProductMapper>(),
        get<_i4.CartMapper>(),
      ));
  gh.lazySingleton<_i10.TetaAnalytics>(
      () => _i10.TetaAnalytics(get<_i8.ServerRequestMetadataStore>()));
  gh.lazySingleton<_i11.TetaBackups>(
      () => _i11.TetaBackups(get<_i8.ServerRequestMetadataStore>()));
  gh.lazySingleton<_i12.TetaCMSUtils>(
      () => _i12.TetaCMSUtils(get<_i8.ServerRequestMetadataStore>()));
  gh.lazySingleton<_i13.TetaEmail>(
      () => _i13.TetaEmail(get<_i8.ServerRequestMetadataStore>()));
  gh.lazySingleton<_i14.TetaPolicies>(
      () => _i14.TetaPolicies(get<_i8.ServerRequestMetadataStore>()));
  gh.lazySingleton<_i15.TetaProjectSettings>(
      () => _i15.TetaProjectSettings(get<_i8.ServerRequestMetadataStore>()));
  gh.lazySingleton<_i16.TetaRealtime>(
      () => _i16.TetaRealtime(get<_i8.ServerRequestMetadataStore>()));
  gh.lazySingleton<_i17.TetaUserUtils>(
      () => _i17.TetaUserUtils(get<_i8.ServerRequestMetadataStore>()));
  gh.lazySingleton<_i18.GetServerRequestHeaders>(() =>
      _i18.GetServerRequestHeaders(get<_i8.ServerRequestMetadataStore>()));
  gh.lazySingleton<_i19.ProductsRepo>(() => _i19.ProductsRepo(
        get<_i7.ProductsApi>(),
        get<_i8.ServerRequestMetadataStore>(),
      ));
  gh.lazySingleton<_i20.TetaAuth>(() => _i20.TetaAuth(
        get<_i15.TetaProjectSettings>(),
        get<_i17.TetaUserUtils>(),
        get<_i13.TetaEmail>(),
        get<_i8.ServerRequestMetadataStore>(),
        get<_i18.GetServerRequestHeaders>(),
      ));
  gh.lazySingleton<_i21.TetaClient>(() => _i21.TetaClient(
        get<_i11.TetaBackups>(),
        get<_i14.TetaPolicies>(),
        get<_i8.ServerRequestMetadataStore>(),
      ));
  gh.lazySingleton<_i22.TetaStoreCartsApi>(() => _i22.TetaStoreCartsApi(
        get<_i4.CartMapper>(),
        get<_i18.GetServerRequestHeaders>(),
        get<_i5.Dio>(),
      ));
  gh.lazySingleton<_i23.TetaStoreProductsApi>(() => _i23.TetaStoreProductsApi(
        get<_i6.ProductMapper>(),
        get<_i18.GetServerRequestHeaders>(),
        get<_i5.Dio>(),
      ));
  gh.lazySingleton<_i24.TetaStore>(() => _i24.TetaStore(
        get<_i18.GetServerRequestHeaders>(),
        get<_i23.TetaStoreProductsApi>(),
        get<_i22.TetaStoreCartsApi>(),
      ));
  return get;
}

class _$DioModule extends _i25.DioModule {}

class _$ProductsApiModule extends _i26.ProductsApiModule {}
