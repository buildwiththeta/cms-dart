import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:teta_cms/src/core/exceptions/exceptions.dart';
import 'package:teta_cms/src/features/store/data/exceptions/products_exception.dart';
import 'package:teta_cms/src/features/store/data/repositories/products_repo.dart';
import 'package:teta_cms/teta_cms.dart';

import 'get_all_products_use_case_test.mocks.dart';

@GenerateMocks([
  ProductsRepo,
])
void main() {
  group('Get all products tests', () {
    late ProductsRepo repository;
    late GetAllProductsUseCase useCase;

    setUp(() async {
      WidgetsFlutterBinding.ensureInitialized();
      repository = MockProductsRepo();
      useCase = GetAllProductsUseCase(productsRepo: repository);
    });

    test('Get all products with success use case', () async {
      final products = <TetaProduct>[
        TetaProduct.fact(
          id: '1',
          name: 'Product one',
          price: 2.5,
          count: 2,
          isPublic: true,
          description: 'Product one description',
          image: 'imageLink',
          metadata: null,
        )
      ];

      when(repository.getAllProducts())
          .thenAnswer((_) => Future.value(products));
      // when
      final useCaseResponse = await useCase.execute();
      // then
      verify(repository.getAllProducts()).called(1);
      expect(useCaseResponse.data, products);
    });

    test('Get all products with TetaErrorResponse ', () async {
      const errorHttpCode = 404;
      const errorCause = 'cause';
      final tetaErrorResponse = ProductsRequestException(
        httpCode: errorHttpCode,
        serverErrorResponse: null,
        cause: errorCause,
        stackTrace: '',
      );

      when(repository.getAllProducts()).thenThrow(tetaErrorResponse);
      // when
      final useCaseResponse = await useCase.execute();
      // then
      verify(repository.getAllProducts()).called(1);
      expect(useCaseResponse.error?.code, errorHttpCode);
      expect(useCaseResponse.error?.message, errorCause);
    });

    test('Get all products with TetaException ', () async {
      const errorCause = 'cause';
      final tetaErrorResponse = TetaException(
        cause: errorCause,
        stackTrace: '',
      );

      when(repository.getAllProducts()).thenThrow(tetaErrorResponse);
      // when
      final useCaseResponse = await useCase.execute();
      // then
      verify(repository.getAllProducts()).called(1);
      expect(useCaseResponse.error?.code, 400);
      expect(useCaseResponse.error?.message, errorCause);
    });
  });
}
