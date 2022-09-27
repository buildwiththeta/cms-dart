// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i4;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:teta_cms/src/analytics.dart' as _i8;
import 'package:teta_cms/src/auth.dart' as _i17;
import 'package:teta_cms/src/client.dart' as _i18;
import 'package:teta_cms/src/data_stores/local/server_request_metadata_store.dart'
    as _i6;
import 'package:teta_cms/src/db/backups.dart' as _i9;
import 'package:teta_cms/src/db/policy.dart' as _i12;
import 'package:teta_cms/src/di/modules/dio_module.dart' as _i22;
import 'package:teta_cms/src/index.dart' as _i14;
import 'package:teta_cms/src/mappers/cart_mapper.dart' as _i3;
import 'package:teta_cms/src/mappers/product_mapper.dart' as _i5;
import 'package:teta_cms/src/mappers/shop_mapper.dart' as _i7;
import 'package:teta_cms/src/store.dart' as _i21;
import 'package:teta_cms/src/store/carts_api.dart' as _i19;
import 'package:teta_cms/src/store/products_api.dart' as _i20;
import 'package:teta_cms/src/use_cases/get_server_request_headers/get_server_request_headers.dart'
    as _i16;
import 'package:teta_cms/src/users/email.dart' as _i11;
import 'package:teta_cms/src/users/settings.dart' as _i13;
import 'package:teta_cms/src/users/user.dart' as _i15;
import 'package:teta_cms/src/utils.dart'
    as _i10; // ignore_for_file: unnecessary_lambdas

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
  gh.lazySingleton<_i3.CartMapper>(() => _i3.CartMapper());
  gh.factory<_i4.Dio>(() => dioModule.dio);
  gh.lazySingleton<_i5.ProductMapper>(() => _i5.ProductMapper());
  gh.lazySingleton<_i6.ServerRequestMetadataStore>(
      () => _i6.ServerRequestMetadataStore());
  gh.lazySingleton<_i7.ShopMapper>(() => _i7.ShopMapper(
        get<_i5.ProductMapper>(),
        get<_i3.CartMapper>(),
      ));
  gh.lazySingleton<_i8.TetaAnalytics>(
      () => _i8.TetaAnalytics(get<_i6.ServerRequestMetadataStore>()));
  gh.lazySingleton<_i9.TetaBackups>(
      () => _i9.TetaBackups(get<_i6.ServerRequestMetadataStore>()));
  gh.lazySingleton<_i10.TetaCMSUtils>(
      () => _i10.TetaCMSUtils(get<_i6.ServerRequestMetadataStore>()));
  gh.lazySingleton<_i11.TetaEmail>(
      () => _i11.TetaEmail(get<_i6.ServerRequestMetadataStore>()));
  gh.lazySingleton<_i12.TetaPolicies>(
      () => _i12.TetaPolicies(get<_i6.ServerRequestMetadataStore>()));
  gh.lazySingleton<_i13.TetaProjectSettings>(
      () => _i13.TetaProjectSettings(get<_i6.ServerRequestMetadataStore>()));
  gh.lazySingleton<_i14.TetaRealtime>(
      () => _i14.TetaRealtime(get<_i6.ServerRequestMetadataStore>()));
  gh.lazySingleton<_i15.TetaUserUtils>(
      () => _i15.TetaUserUtils(get<_i6.ServerRequestMetadataStore>()));
  gh.lazySingleton<_i16.GetServerRequestHeaders>(() =>
      _i16.GetServerRequestHeaders(get<_i6.ServerRequestMetadataStore>()));
  gh.lazySingleton<_i17.TetaAuth>(() => _i17.TetaAuth(
        get<_i13.TetaProjectSettings>(),
        get<_i15.TetaUserUtils>(),
        get<_i11.TetaEmail>(),
        get<_i6.ServerRequestMetadataStore>(),
        get<_i16.GetServerRequestHeaders>(),
      ));
  gh.lazySingleton<_i18.TetaClient>(() => _i18.TetaClient(
        get<_i9.TetaBackups>(),
        get<_i12.TetaPolicies>(),
        get<_i6.ServerRequestMetadataStore>(),
      ));
  gh.lazySingleton<_i19.TetaStoreCartsApi>(() => _i19.TetaStoreCartsApi(
        get<_i3.CartMapper>(),
        get<_i16.GetServerRequestHeaders>(),
        get<_i4.Dio>(),
      ));
  gh.lazySingleton<_i20.TetaStoreProductsApi>(() => _i20.TetaStoreProductsApi(
        get<_i5.ProductMapper>(),
        get<_i16.GetServerRequestHeaders>(),
        get<_i4.Dio>(),
      ));
  gh.lazySingleton<_i21.TetaStore>(() => _i21.TetaStore(
        get<_i16.GetServerRequestHeaders>(),
        get<_i20.TetaStoreProductsApi>(),
        get<_i19.TetaStoreCartsApi>(),
      ));
  return get;
}

class _$DioModule extends _i22.DioModule {}
