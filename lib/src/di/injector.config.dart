// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i4;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:teta_cms/src/analytics.dart' as _i9;
import 'package:teta_cms/src/auth.dart' as _i19;
import 'package:teta_cms/src/database.dart' as _i20;
import 'package:teta_cms/src/data_stores/local/server_request_metadata_store.dart'
    as _i6;
import 'package:teta_cms/src/db/backups.dart' as _i10;
import 'package:teta_cms/src/db/policy.dart' as _i13;
import 'package:teta_cms/src/di/modules/dio_module.dart' as _i24;
import 'package:teta_cms/src/index.dart' as _i15;
import 'package:teta_cms/src/mappers/credentials_mapper.dart' as _i3;
import 'package:teta_cms/src/mappers/product_mapper.dart' as _i5;
import 'package:teta_cms/src/mappers/shipping_mapper.dart' as _i7;
import 'package:teta_cms/src/mappers/shop_settings_mapper.dart' as _i8;
import 'package:teta_cms/src/mappers/transactions_mapper.dart' as _i17;
import 'package:teta_cms/src/shop.dart' as _i23;
import 'package:teta_cms/src/store/carts_api.dart' as _i21;
import 'package:teta_cms/src/store/products_api.dart' as _i22;
import 'package:teta_cms/src/use_cases/get_server_request_headers/get_server_request_headers.dart'
    as _i18;
import 'package:teta_cms/src/users/email.dart' as _i12;
import 'package:teta_cms/src/users/settings.dart' as _i14;
import 'package:teta_cms/src/users/user.dart' as _i16;
import 'package:teta_cms/src/utils.dart' as _i11;
import 'package:teta_cms/src/httpRequest.dart' as _i25;
import 'package:teta_cms/src/storage.dart' as _i26;

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
  if (!_i1.GetIt.instance.isRegistered(instance: _i3.CredentialsMapper)) {
    gh.lazySingleton<_i3.CredentialsMapper>(() => _i3.CredentialsMapper());
  }
  gh.factory<_i4.Dio>(() => dioModule.dio);
  gh.lazySingleton<_i5.ProductMapper>(() => _i5.ProductMapper());
  gh.lazySingleton<_i6.ServerRequestMetadataStore>(
      () => _i6.ServerRequestMetadataStore());
  gh.lazySingleton<_i7.ShippingMapper>(() => _i7.ShippingMapper());
  gh.lazySingleton<_i8.ShopSettingsMapper>(() => _i8.ShopSettingsMapper());
  gh.lazySingleton<_i9.TetaAnalytics>(
      () => _i9.TetaAnalytics(get<_i6.ServerRequestMetadataStore>()));
  gh.lazySingleton<_i10.TetaBackups>(
      () => _i10.TetaBackups(get<_i6.ServerRequestMetadataStore>()));
  gh.lazySingleton<_i11.TetaCMSUtils>(
      () => _i11.TetaCMSUtils(get<_i6.ServerRequestMetadataStore>()));
  gh.lazySingleton<_i26.TetaStorage>(
      () => _i26.TetaStorage(get<_i6.ServerRequestMetadataStore>()));
  gh.lazySingleton<_i12.TetaEmail>(
      () => _i12.TetaEmail(get<_i6.ServerRequestMetadataStore>()));
  gh.lazySingleton<_i13.TetaPolicies>(
      () => _i13.TetaPolicies(get<_i6.ServerRequestMetadataStore>()));
  gh.lazySingleton<_i14.TetaProjectSettings>(
      () => _i14.TetaProjectSettings(get<_i6.ServerRequestMetadataStore>()));
  gh.lazySingleton<_i15.TetaRealtime>(
      () => _i15.TetaRealtime(get<_i6.ServerRequestMetadataStore>()));
  gh.lazySingleton<_i16.TetaUserUtils>(
      () => _i16.TetaUserUtils(get<_i6.ServerRequestMetadataStore>()));
  gh.lazySingleton<_i17.TransactionsMapper>(
      () => _i17.TransactionsMapper(get<_i5.ProductMapper>()));
  gh.lazySingleton<_i18.GetServerRequestHeaders>(() =>
      _i18.GetServerRequestHeaders(get<_i6.ServerRequestMetadataStore>()));
  gh.lazySingleton<_i19.TetaAuth>(() => _i19.TetaAuth(
        get<_i14.TetaProjectSettings>(),
        get<_i16.TetaUserUtils>(),
        get<_i12.TetaEmail>(),
        get<_i6.ServerRequestMetadataStore>(),
        get<_i18.GetServerRequestHeaders>(),
      ));
  gh.lazySingleton<_i20.TetaDatabase>(() => _i20.TetaDatabase(
        get<_i10.TetaBackups>(),
        get<_i13.TetaPolicies>(),
        get<_i6.ServerRequestMetadataStore>(),
      ));
  gh.lazySingleton<_i21.TetaStoreCartsApi>(() => _i21.TetaStoreCartsApi(
        get<_i18.GetServerRequestHeaders>(),
        get<_i4.Dio>(),
        get<_i5.ProductMapper>(),
      ));
  gh.lazySingleton<_i22.TetaStoreProductsApi>(() => _i22.TetaStoreProductsApi(
        get<_i5.ProductMapper>(),
        get<_i18.GetServerRequestHeaders>(),
        get<_i4.Dio>(),
      ));
  gh.lazySingleton<_i23.TetaShop>(() => _i23.TetaShop(
        get<_i18.GetServerRequestHeaders>(),
        get<_i22.TetaStoreProductsApi>(),
        get<_i21.TetaStoreCartsApi>(),
        get<_i17.TransactionsMapper>(),
        get<_i3.CredentialsMapper>(),
        get<_i7.ShippingMapper>(),
        get<_i8.ShopSettingsMapper>(),
        get<_i6.ServerRequestMetadataStore>(),
      ));
  gh.lazySingleton<_i25.TetaHttpRequest>(() => _i25.TetaHttpRequest());
  return get;
}

class _$DioModule extends _i24.DioModule {}
