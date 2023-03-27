import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:teta_cms/src/analytics.dart';
import 'package:teta_cms/src/data_stores/local/server_request_metadata_store.dart';
import 'package:clear_response/clear_response.dart';
import 'package:light_logger/light_logger.dart';

class Utils {
  ///Constructor
  Utils(this._serverRequestMetadata)
      : _analytics = Analytics(_serverRequestMetadata);

  ///This stores the token and project id headers.
  final ServerRequestMetadataStore _serverRequestMetadata;
  final Analytics _analytics;

  Future<ClearResponse<bool, ClearErrorResponse?>> braintreePay(
    final dynamic nounce,
    final dynamic deviceData,
    final dynamic amount,
  ) async {
    final serverMetadata = _serverRequestMetadata.getMetadata();

    final url = 'http://cms.teta.so:9183/pay/${serverMetadata.prjId}';
    final uri = Uri.parse(
      '$url?payment_method_nonce=$nounce&device_data=$deviceData&amount=$amount',
    );

    final res = await http.post(
      uri,
      headers: {'authorization': 'Bearer ${serverMetadata.token}'},
    );

    Logger.printMessage('custom query: ${res.body}');

    if (res.statusCode != 200) {
      return ClearResponse<bool, ClearErrorResponse?>(
        data: false,
        error: ClearErrorResponse(
          code: res.statusCode,
          message: res.body,
        ),
      );
    }

    final data = json.decode(res.body) as Map<String, dynamic>;
    if (data['result'] == 'success') {
      return ClearResponse<bool, ClearErrorResponse?>(
        data: true,
        error: null,
      );
    } else {
      return ClearResponse<bool, ClearErrorResponse?>(
        data: false,
        error: ClearErrorResponse(
          code: res.statusCode,
          message: res.body,
        ),
      );
    }
  }
}
