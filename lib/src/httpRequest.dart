// ignore_for_file: prefer_final_parameters

import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:teta_cms/src/models/response.dart';

class TetaHttpRequest {
  /// Post Request
  Future<TetaResponse<List<dynamic>?, List<dynamic>?>> post(
    final String url,
    final String expectedStatusCode,
    final Map<String, dynamic> parameters,
    final Map<String, dynamic> body,
    final Map<String, dynamic> headers,
  ) async {
    var urlString = url;
    parameters.forEach((key, dynamic value) {
      urlString = urlString + "/${key.toString()}/${value.toString()}";
    });

    final Uri uri = Uri.parse(urlString);

    Map<String, String> headersNew = {
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Credentials': 'true',
      'Access-Control-Allow-Headers':
          'Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale',
      'Access-Control-Allow-Methods': 'POST, OPTIONS'
    };
    headers.forEach((key, dynamic value) {
      headersNew[key.toString()] = value.toString();
    });

    final res = await http.post(
      uri,
      headers: headersNew,
      body: body,
    );

    final statusCode = <String, dynamic>{'statusCode': res.statusCode};
    //Error Part
    if (res.statusCode != int.parse(expectedStatusCode)) {
      final json = res.body;
      final dynamic docs = jsonDecode(json);

      if (docs is List) {
        final List<dynamic> listdocs = (docs as List<dynamic>)
            .map((final dynamic e) => <String, dynamic>{...e, ...statusCode})
            .toList();

        return TetaResponse<List<dynamic>?, List<dynamic>>(
            data: null, error: listdocs);
      } else {
        final List<dynamic> listdocs = <dynamic>[
          <String, dynamic>{...docs, ...statusCode}
        ];

        return TetaResponse<List<dynamic>?, List<dynamic>>(
            data: null, error: listdocs);
      }
    }
    //Response Part
    final json = res.body;
    dynamic docs = jsonDecode(json);

    if (docs is List) {
      final List<dynamic> listdocs = (docs as List<dynamic>)
          .map((final dynamic e) => <String, dynamic>{...e, ...statusCode})
          .toList();
      return TetaResponse<List<dynamic>, List<dynamic>?>(
        data: listdocs,
        error: null,
      );
    } else {
      final List<dynamic> listdocs = <dynamic>[
        <String, dynamic>{...docs, ...statusCode}
      ];
      return TetaResponse<List<dynamic>, List<dynamic>?>(
        data: listdocs,
        error: null,
      );
    }
  }

  /// Delete Request
  Future<TetaResponse<List<dynamic>?, List<dynamic>?>> delete(
    final String url,
    final String expectedStatusCode,
    final Map<String, dynamic> parameters,
    final Map<String, dynamic> headers,
  ) async {
    var urlString = url;

    parameters.forEach((key, dynamic value) {
      urlString = urlString + "/${key.toString()}/${value.toString()}";
    });

    Map<String, String> headersNew = {
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Credentials': 'true',
      'Access-Control-Allow-Headers':
          'Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale',
      'Access-Control-Allow-Methods': 'POST, OPTIONS'
    };
    headers.forEach((key, dynamic value) {
      headersNew[key.toString()] = value.toString();
    });
    final Uri uri = Uri.parse(urlString);

    final res = await http.delete(uri, headers: headersNew);
    final statusCode = <String, dynamic>{'statusCode': res.statusCode};

    if (res.statusCode != int.parse(expectedStatusCode)) {
      final json = res.body;
      final dynamic docs = jsonDecode(json);

      if (docs is List) {
        final List<dynamic> listdocs = (docs as List<dynamic>)
            .map((final dynamic e) => <String, dynamic>{...e, ...statusCode})
            .toList();

        return TetaResponse<List<dynamic>?, List<dynamic>>(
          data: null,
          error: listdocs,
        );
      } else {
        final List<dynamic> listdocs = <dynamic>[
          <String, dynamic>{...docs, ...statusCode}
        ];

        return TetaResponse<List<dynamic>?, List<dynamic>>(
          data: null,
          error: listdocs,
        );
      }
    }

    return TetaResponse<List<dynamic>?, List<dynamic>?>(
      data: <dynamic>[
        <String, dynamic>{...statusCode}
      ],
      error: null,
    );
  }

  /// Update Request
  Future<TetaResponse<List<dynamic>?, List<dynamic>?>> update(
    final String url,
    final String expectedStatusCode,
    final Map<String, dynamic> parameters,
    final Map<String, dynamic> body,
    final Map<String, dynamic> headers,
  ) async {
    var urlString = url;
    parameters.forEach((key, dynamic value) {
      urlString = urlString + "/${key.toString()}/${value.toString()}";
    });
    final Uri uri = Uri.parse(urlString);

    Map<String, String> headersNew = {
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Credentials': 'true',
      'Access-Control-Allow-Headers':
          'Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale',
      'Access-Control-Allow-Methods': 'POST, OPTIONS'
    };
    headers.forEach((key, dynamic value) {
      headersNew[key.toString()] = value.toString();
    });

    final res = await http.put(
      uri,
      headers: headersNew,
      body: body,
    );
    final statusCode = <String, dynamic>{'statusCode': res.statusCode};

    //Error Part
    if (res.statusCode != int.parse(expectedStatusCode)) {
      final json = res.body;
      dynamic docs = jsonDecode(json);
      if (docs is List) {
        final List<dynamic> listdocs = (docs as List<dynamic>)
            .map((final dynamic e) => <String, dynamic>{...e, ...statusCode})
            .toList();
        return TetaResponse<List<dynamic>?, List<dynamic>>(
            data: null, error: listdocs);
      } else {
        final List<dynamic> listdocs = <dynamic>[
          <String, dynamic>{...docs, ...statusCode}
        ];
        return TetaResponse<List<dynamic>?, List<dynamic>>(
            data: null, error: listdocs);
      }
    }

    final json = res.body;
    dynamic docs = jsonDecode(json);
    if (docs is List) {
      final List<dynamic> listdocs = (docs as List<dynamic>)
          .map((final dynamic e) => <String, dynamic>{...e, ...statusCode})
          .toList();
      return TetaResponse<List<dynamic>, List<dynamic>?>(
        data: listdocs,
        error: null,
      );
    } else {
      final List<dynamic> listdocs = <dynamic>[
        <String, dynamic>{...docs, ...statusCode}
      ];
      return TetaResponse<List<dynamic>, List<dynamic>?>(
        data: listdocs,
        error: null,
      );
    }
  }
}
