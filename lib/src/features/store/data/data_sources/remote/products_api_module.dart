import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:teta_cms/src/core/di/modules/base_url.dart';

import 'products_api.dart';

@module
abstract class ProductsApiModule {
  ProductsApi get(Dio dio, BaseUrl baseUrl) =>
      ProductsApi(dio, baseUrl: baseUrl.url);
}
