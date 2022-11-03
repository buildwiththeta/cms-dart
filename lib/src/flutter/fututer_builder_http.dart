import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:universal_html/html.dart';

class TetaFutureBuilderHttp<T> extends StatefulWidget {
  TetaFutureBuilderHttp({
    required this.url,
    required this.builder,
    required this.params,
    required this.headers,
    final Key? key,
  }) : super(key: key);

  /// The url
  final String url;

  /// The params
  Map<String, String> params;

  ///  The headers
  Map<String, String> headers;

  /// The builder
  final Widget Function(BuildContext, AsyncSnapshot<dynamic>) builder;

  @override
  State<TetaFutureBuilderHttp<T>> createState() =>
      _TetaFutureBuilderHttpState<T>();
}

class _TetaFutureBuilderHttpState<T> extends State<TetaFutureBuilderHttp<T>> {
  @override
  Widget build(final BuildContext context) {
    return FutureBuilder<dynamic>(
      future: httpGetRequest(
        widget.url,
        widget.headers,
        widget.params,
      ),
      builder: widget.builder,
    );
  }

  Future httpGetRequest(final String url, final Map<String, String> headers,
      final Map<String, String> params) async {
    var newURL = url;
    var headersGlobal = <String, String>{
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Credentials': 'true',
      'Access-Control-Allow-Headers':
          'Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale',
      'Access-Control-Allow-Methods': 'POST, OPTIONS'
    };
    headersGlobal.addAll(headers);

    params.forEach((key, value) {
      if (params.keys.first == key) {
        newURL = url + "?${key}=${value}";
      } else {
        newURL = newURL + "&${key}=${value}";
      }
    });

    await http.get(
      Uri.parse(newURL),
      headers: headersGlobal,
    );
  }
}
