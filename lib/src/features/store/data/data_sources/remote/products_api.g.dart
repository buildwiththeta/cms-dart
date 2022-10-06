// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'products_api.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers

class _ProductsApi implements ProductsApi {
  _ProductsApi(this._dio, {this.baseUrl});

  final Dio _dio;

  String? baseUrl;

  @override
  Future<HttpResponse<List<TetaProduct>>> fetchProducts(
      authorization, projectId, contentType) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{
      r'authorization': authorization,
      r'x-teta-prj-id': projectId,
      r'content-type': contentType
    };
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<List<dynamic>>(
        _setStreamType<HttpResponse<List<TetaProduct>>>(Options(
                method: 'GET',
                headers: _headers,
                extra: _extra,
                contentType: contentType)
            .compose(_dio.options, '/shop/product/list',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    var value = _result.data!
        .map((dynamic i) => TetaProduct.fromJson(i as Map<String, dynamic>))
        .toList();
    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<TetaProduct>> fetchProduct(
      authorization, projectId, contentType, id) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{
      r'authorization': authorization,
      r'x-teta-prj-id': projectId,
      r'content-type': contentType
    };
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<HttpResponse<TetaProduct>>(Options(
                method: 'GET',
                headers: _headers,
                extra: _extra,
                contentType: contentType)
            .compose(_dio.options, '/shop/product/${id}',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = TetaProduct.fromJson(_result.data!);
    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<TetaProduct>> insertProduct(
      authorization, projectId, contentType, product) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{
      r'authorization': authorization,
      r'x-teta-prj-id': projectId,
      r'content-type': contentType
    };
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(product.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<HttpResponse<TetaProduct>>(Options(
                method: 'POST',
                headers: _headers,
                extra: _extra,
                contentType: contentType)
            .compose(_dio.options, '/shop/product/',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = TetaProduct.fromJson(_result.data!);
    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<TetaProduct>> updateProduct(
      authorization, projectId, contentType, id, product) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{
      r'authorization': authorization,
      r'x-teta-prj-id': projectId,
      r'content-type': contentType
    };
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(product.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<HttpResponse<TetaProduct>>(Options(
                method: 'POST',
                headers: _headers,
                extra: _extra,
                contentType: contentType)
            .compose(_dio.options, '/shop/product/${id}',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = TetaProduct.fromJson(_result.data!);
    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<TetaProduct>> deleteProduct(
      authorization, projectId, contentType, id) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{
      r'authorization': authorization,
      r'x-teta-prj-id': projectId,
      r'content-type': contentType
    };
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<HttpResponse<TetaProduct>>(Options(
                method: 'POST',
                headers: _headers,
                extra: _extra,
                contentType: contentType)
            .compose(_dio.options, '/shop/product/${id}',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = TetaProduct.fromJson(_result.data!);
    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }
}
