import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:teta_cms/src/data_stores/local/server_request_metadata_store.dart';
import 'package:teta_cms/src/features/store/data/data_sources/models/product_model.dart';
import 'package:teta_cms/src/features/store/data/data_sources/remote/products_api.dart';
import 'package:teta_cms/src/features/store/data/exceptions/products_exception.dart';
import 'package:teta_cms/src/use_cases/get_server_request_headers/get_server_request_headers.dart';

@lazySingleton
class ProductsRepo {
  ProductsRepo(
    this.api,
    this.serverRequestMetadataStore,
  );

  final ProductsApi api;
  final ServerRequestMetadataStore serverRequestMetadataStore;

  /// Gets all the products.
  Future<List<TetaProduct>> getAllProducts() async {
    try {
      final requestMetadata = serverRequestMetadataStore.getMetadata();
      final response = await api.fetchProducts(
        'Bearer ${requestMetadata.token}',
        requestMetadata.prjId.toString(),
        'application/json',
      );

      return response.data;
    } on DioError catch (e, st) {
      throw ProductsRequestException(
        httpCode: e.response?.statusCode ?? 400,
        serverErrorResponse: e.response?.data ?? 'No error response',
        cause: e.toString(),
        stackTrace: st.toString(),
      );
    } catch (e, st) {
      throw ProdcutsException(
        cause: e.toString(),
        stackTrace: st.toString(),
      );
    }
  }
}
