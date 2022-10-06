import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:teta_cms/teta_cms.dart';

part 'products_api.g.dart';

@RestApi(baseUrl: '')
abstract class ProductsApi {
  factory ProductsApi(final Dio dio, {required final String baseUrl}) =
      _ProductsApi;

  @GET('/shop/product/list')
  Future<HttpResponse<List<TetaProduct>>> fetchProducts(
    @Header('authorization') final String authorization,
    @Header('x-teta-prj-id') final String projectId,
    @Header('content-type') final String contentType,
  );

  @GET('/shop/product/{id}')
  Future<HttpResponse<TetaProduct>> fetchProduct(
    @Header('authorization') final String authorization,
    @Header('x-teta-prj-id') final String projectId,
    @Header('content-type') final String contentType,
    @Path('id') final String id,
  );

  @POST('/shop/product/')
  Future<HttpResponse<TetaProduct>> insertProduct(
    @Header('authorization') final String authorization,
    @Header('x-teta-prj-id') final String projectId,
    @Header('content-type') final String contentType,
    @Body() final TetaProduct product,
  );

  @POST('/shop/product/{id}')
  Future<HttpResponse<TetaProduct>> updateProduct(
    @Header('authorization') final String authorization,
    @Header('x-teta-prj-id') final String projectId,
    @Header('content-type') final String contentType,
    @Path('id') final String id,
    @Body() final TetaProduct product,
  );

  @POST('/shop/product/{id}')
  Future<HttpResponse<TetaProduct>> deleteProduct(
    @Header('authorization') final String authorization,
    @Header('x-teta-prj-id') final String projectId,
    @Header('content-type') final String contentType,
    @Path('id') final String id,
  );
}
