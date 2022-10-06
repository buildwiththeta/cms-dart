import 'package:teta_cms/src/core/exceptions/exceptions.dart';

class ProdcutsException extends TetaException {
  ProdcutsException({
    required String cause,
    required String stackTrace,
  }) : super(
          cause: cause,
          stackTrace: stackTrace,
        );
}

class ProductsRequestException extends TetaCmsServerRequestException {
  ProductsRequestException({
    required int httpCode,
    required dynamic serverErrorResponse,
    required String cause,
    required String stackTrace,
  }) : super(
          httpCode: httpCode,
          serverErrorResponse: serverErrorResponse,
          cause: cause,
          stackTrace: stackTrace,
        );
}
