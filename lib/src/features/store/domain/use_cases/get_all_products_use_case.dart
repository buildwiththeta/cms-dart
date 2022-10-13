import 'package:injectable/injectable.dart';
import 'package:teta_cms/src/core/di/injector.dart';
import 'package:teta_cms/src/core/exceptions/exceptions.dart';
import 'package:teta_cms/src/features/store/data/exceptions/products_exception.dart';
import 'package:teta_cms/src/features/store/data/repositories/products_repo.dart';
import 'package:teta_cms/src/features/store/domain/entities/teta_products_entity.dart';
import 'package:teta_cms/src/models/response.dart';

///This is exposed to the user
class GetAllProductsUseCase {
  GetAllProductsUseCase({final ProductsRepo? productsRepo})
      : this._productsRepo = productsRepo ?? getIt.get<ProductsRepo>();
  final ProductsRepo _productsRepo;

  Future<TetaProductsResponse> execute() async {
    try {
      final products = await _productsRepo.getAllProducts();

      return TetaProductsResponse(
        data: products,
      );
    } on TetaException catch (e) {
      if (e is ProductsRequestException) {
        return TetaProductsResponse(
          error: TetaErrorResponse(
            message: e.cause,
            code: e.httpCode,
          ),
        );
      } else {
        return TetaProductsResponse(
          error: TetaErrorResponse(
            message: e.cause,
            code: 400,
          ),
        );
      }
    }
  }
}
