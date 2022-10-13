import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:retrofit/dio.dart';
import 'package:teta_cms/src/core/exceptions/exceptions.dart';
import 'package:teta_cms/src/data_stores/local/server_request_metadata_store.dart';
import 'package:teta_cms/src/features/store/data/data_sources/remote/products_api.dart';
import 'package:teta_cms/src/features/store/data/exceptions/products_exception.dart';
import 'package:teta_cms/src/features/store/data/repositories/products_repo.dart';
import 'package:teta_cms/src/models/server_request_metadata.dart';
import 'package:teta_cms/teta_cms.dart';

import 'products_repo_test.mocks.dart';

@GenerateMocks([
  ProductsApi,
  ServerRequestMetadataStore,
])
void main() {
  group('Products repo tests', () {
    late ProductsRepo repository;
    late MockProductsApi api;
    late MockServerRequestMetadataStore metadataStore;

    setUp(() async {
      WidgetsFlutterBinding.ensureInitialized();
      api = MockProductsApi();
      metadataStore = MockServerRequestMetadataStore();
      repository = ProductsRepo(api, metadataStore);
    });

    test('Get all products success', () async {
      final serverReqMetadata = ServerRequestMetadata(
        token: 'token',
        prjId: 1,
      );
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
      final requestAnswer = HttpResponse<List<TetaProduct>>(
        products,
        Response<List<TetaProduct>>(
          requestOptions: RequestOptions(path: ''),
        ),
      );
      when(api.fetchProducts(any, any, any))
          .thenAnswer((_) => Future.value(requestAnswer));
      when(metadataStore.getMetadata()).thenReturn(
        serverReqMetadata,
      );
      // when
      final repoResponse = await repository.getAllProducts();
      // then
      verify(api.fetchProducts(any, any, any)).called(1);
      verify(metadataStore.getMetadata()).called(1);
      expect(repoResponse, products);
    });
  });
}
