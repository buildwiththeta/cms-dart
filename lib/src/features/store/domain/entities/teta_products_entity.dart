import 'package:teta_cms/src/features/store/data/data_sources/models/product_model.dart';
import 'package:teta_cms/src/models/response.dart';

class TetaProductResponse
    extends TetaResponse<TetaProduct?, TetaErrorResponse?> {
  TetaProductResponse({
    final TetaProduct? data,
    final TetaErrorResponse? error,
  }) : super(data: data, error: error);
}

class TetaProductsResponse
    extends TetaResponse<List<TetaProduct>?, TetaErrorResponse?> {
  TetaProductsResponse({
    final List<TetaProduct>? data,
    final TetaErrorResponse? error,
  }) : super(data: data, error: error);
}
