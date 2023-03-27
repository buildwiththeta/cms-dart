
// ignore_for_file: prefer_final_parameters

import 'dart:async';
import 'dart:convert';

import 'package:clear_response/clear_response.dart';
import 'package:http/http.dart' as http;

class ThetaHttpRequest {
  //Get Request
  Future<ClearResponse<List<dynamic>?, List<dynamic>?>> get(
    final String url,
    final String expectedStatusCode,
    final Map<String, dynamic> parameters,
    final Map<String, dynamic> body,
    final Map<String, dynamic> headers, {
    final bool test = false,
  }) async {
    var urlString = url;
    var firstLoop = true;
    parameters.forEach((key, dynamic value) {
      if (firstLoop) {
        urlString = '$urlString?$key=${value.toString()}';
        firstLoop = false;
      } else {
        urlString = '$urlString&$key=${value.toString()}';
      }
    });

    final uri = Uri.parse(urlString);

    final headersNew = <String, String>{};

    headers.forEach((key, dynamic value) {
      headersNew[key] = value.toString();
    });

    final res = await http.get(
      uri,
      headers: headersNew,
    );
    final statusCode = <String, dynamic>{'statusCode': res.statusCode};
    //Error Part
    if (test == false) {
      if (res.statusCode != int.parse(expectedStatusCode)) {
        final json = res.body;
        final dynamic docs = jsonDecode(json);
        if (docs is List) {
          final listDocs = (docs)
              .map((final dynamic e) => <String, dynamic>{...e, ...statusCode})
              .toList();

          return ClearResponse<List<dynamic>?, List<dynamic>>(
            data: null,
            error: listDocs,
          );
        } else {
          final listDocs = <dynamic>[
            <String, dynamic>{...docs, ...statusCode}
          ];

          return ClearResponse<List<dynamic>?, List<dynamic>>(
            data: null,
            error: listDocs,
          );
        }
      }
    }
    //Response Part
    final json = res.body;
    final dynamic docs = jsonDecode(json);
    if (docs is List) {
      final listDocs = (docs)
          .map((final dynamic e) => <String, dynamic>{...e, ...statusCode})
          .toList();
      return ClearResponse<List<dynamic>, List<dynamic>?>(
        data: listDocs,
        error: null,
      );
    } else {
      final listDocs = <dynamic>[
        <String, dynamic>{...docs, ...statusCode}
      ];
      return ClearResponse<List<dynamic>, List<dynamic>?>(
        data: listDocs,
        error: null,
      );
    }
  }

  /// Post Request
  Future<ClearResponse<List<dynamic>?, List<dynamic>?>> post(
    final String url,
    final String expectedStatusCode,
    final Map<String, dynamic> parameters,
    final Map<String, dynamic> body,
    final Map<String, dynamic> headers, {
    final bool test = false,
  }) async {
    var urlString = url;
    var firstLoop = true;
    parameters.forEach((key, dynamic value) {
      if (firstLoop) {
        urlString = '$urlString?$key=${value.toString()}';
        firstLoop = false;
      } else {
        urlString = '$urlString&$key=${value.toString()}';
      }
    });

    final uri = Uri.parse(urlString);

    final headersNew = <String, String>{};

    headers.forEach((key, dynamic value) {
      headersNew[key] = value.toString();
    });

    final res = await http.post(
      uri,
      headers: headersNew,
      body: body,
    );

    final statusCode = <String, dynamic>{'statusCode': res.statusCode};
    //Error Part
    if (test == false) {
      if (res.statusCode != int.parse(expectedStatusCode)) {
        final json = res.body;
        final dynamic docs = jsonDecode(json);

        if (docs is List) {
          final List<dynamic> listDocs = (docs)
              .map((final dynamic e) => <String, dynamic>{...e, ...statusCode})
              .toList();

          return ClearResponse<List<dynamic>?, List<dynamic>>(
            data: null,
            error: listDocs,
          );
        } else {
          final listDocs = <dynamic>[
            <String, dynamic>{...docs, ...statusCode}
          ];

          return ClearResponse<List<dynamic>?, List<dynamic>>(
            data: null,
            error: listDocs,
          );
        }
      }
    }
    //Response Part
    final json = res.body;
    final dynamic docs = jsonDecode(json);

    if (docs is List) {
      final List<dynamic> listDocs = (docs)
          .map((final dynamic e) => <String, dynamic>{...e, ...statusCode})
          .toList();
      return ClearResponse<List<dynamic>, List<dynamic>?>(
        data: listDocs,
        error: null,
      );
    } else {
      final listDocs = <dynamic>[
        <String, dynamic>{...docs, ...statusCode}
      ];
      return ClearResponse<List<dynamic>, List<dynamic>?>(
        data: listDocs,
        error: null,
      );
    }
  }

  /// Delete Request
  Future<ClearResponse<List<dynamic>?, List<dynamic>?>> delete(
    final String url,
    final String expectedStatusCode,
    final Map<String, dynamic> parameters,
    final Map<String, dynamic> headers, {
    final bool test = false,
  }) async {
    var urlString = url;

    var firstLoop = true;
    parameters.forEach((key, dynamic value) {
      if (firstLoop) {
        urlString = '$urlString?$key=${value.toString()}';
        firstLoop = false;
      } else {
        urlString = '$urlString&$key=${value.toString()}';
      }
    });

    final headersNew = <String, String>{};

    headers.forEach((key, dynamic value) {
      headersNew[key] = value.toString();
    });
    final uri = Uri.parse(urlString);

    final res = await http.delete(uri, headers: headersNew);
    final statusCode = <String, dynamic>{'statusCode': res.statusCode};
    if (test == false) {
      if (res.statusCode != int.parse(expectedStatusCode)) {
        final json = res.body;
        final dynamic docs = jsonDecode(json);

        if (docs is List) {
          final List<dynamic> listDocs = (docs)
              .map((final dynamic e) => <String, dynamic>{...e, ...statusCode})
              .toList();

          return ClearResponse<List<dynamic>?, List<dynamic>>(
            data: null,
            error: listDocs,
          );
        } else {
          final listDocs = <dynamic>[
            <String, dynamic>{...docs, ...statusCode}
          ];

          return ClearResponse<List<dynamic>?, List<dynamic>>(
            data: null,
            error: listDocs,
          );
        }
      }
    }

    return ClearResponse<List<dynamic>?, List<dynamic>?>(
      data: <dynamic>[
        <String, dynamic>{...statusCode}
      ],
      error: null,
    );
  }

  /// Update Request
  Future<ClearResponse<List<dynamic>?, List<dynamic>?>> update(
    final String url,
    final String expectedStatusCode,
    final Map<String, dynamic> parameters,
    final Map<String, dynamic> body,
    final Map<String, dynamic> headers, {
    final bool test = false,
  }) async {
    var urlString = url;
    var firstLoop = true;
    parameters.forEach((key, dynamic value) {
      if (firstLoop) {
        urlString = "$urlString?${key.toString()}=${value.toString()}";
        firstLoop = false;
      } else {
        urlString = "$urlString&${key.toString()}=${value.toString()}";
      }
    });
    final uri = Uri.parse(urlString);

    final headersNew = <String, String>{};

    headers.forEach((key, dynamic value) {
      headersNew[key] = value.toString();
    });

    final res = await http.put(
      uri,
      headers: headersNew,
      body: body,
    );
    final statusCode = <String, dynamic>{'statusCode': res.statusCode};

    //Error Part
    if (test == false) {
      if (res.statusCode != int.parse(expectedStatusCode)) {
        final json = res.body;
        final dynamic docs = jsonDecode(json);
        if (docs is List) {
          final List<dynamic> listDocs = (docs)
              .map((final dynamic e) => <String, dynamic>{...e, ...statusCode})
              .toList();
          return ClearResponse<List<dynamic>?, List<dynamic>>(
            data: null,
            error: listDocs,
          );
        } else {
          final listDocs = <dynamic>[
            <String, dynamic>{...docs, ...statusCode}
          ];
          return ClearResponse<List<dynamic>?, List<dynamic>>(
            data: null,
            error: listDocs,
          );
        }
      }
    }

    final json = res.body;
    final dynamic docs = jsonDecode(json);
    if (docs is List) {
      final List<dynamic> listDocs = (docs)
          .map((final dynamic e) => <String, dynamic>{...e, ...statusCode})
          .toList();
      return ClearResponse<List<dynamic>, List<dynamic>?>(
        data: listDocs,
        error: null,
      );
    } else {
      final listDocs = <dynamic>[
        <String, dynamic>{...docs, ...statusCode}
      ];
      return ClearResponse<List<dynamic>, List<dynamic>?>(
        data: listDocs,
        error: null,
      );
    }
  }
}
