import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:teta_cms/src/data_stores/local/server_request_metadata_store.dart';
import 'package:teta_cms/teta_cms.dart';

@lazySingleton
class TetaCMSUtils {
  ///Constructor
  TetaCMSUtils(this.serverRequestMetadata);

  ///This stores the token and project id headers.
  final ServerRequestMetadataStore serverRequestMetadata;

  Future<TetaResponse<bool, TetaErrorResponse?>> braintreePay(
    final dynamic nounce,
    final dynamic deviceData,
    final dynamic amount,
  ) async {
    final serverMetadata = serverRequestMetadata.getMetadata();

    final url = 'http://cms.teta.so:9183/pay/${serverMetadata.prjId}';
    final uri = Uri.parse(
      '$url?payment_method_nonce=$nounce&device_data=$deviceData&amount=$amount',
    );

    final res = await http.post(
      uri,
      headers: {'authorization': 'Bearer ${serverMetadata.token}'},
    );

    TetaCMS.log('custom query: ${res.body}');

    if (res.statusCode != 200) {
      return TetaResponse<bool, TetaErrorResponse?>(
        data: false,
        error: TetaErrorResponse(
          code: res.statusCode,
          message: res.body,
        ),
      );
    }

    try {
      unawaited(
        TetaCMS.instance.analytics.insertEvent(
          TetaAnalyticsType.customQuery,
          'Braintree: purchase',
          <String, dynamic>{},
          isUserIdPreferableIfExists: false,
        ),
      );
    } catch (_) {}

    final data = json.decode(res.body) as Map<String, dynamic>;
    if (data['result'] == 'success') {
      return TetaResponse<bool, TetaErrorResponse?>(
        data: true,
        error: null,
      );
    } else {
      return TetaResponse<bool, TetaErrorResponse?>(
        data: false,
        error: TetaErrorResponse(
          code: res.statusCode,
          message: res.body,
        ),
      );
    }
  }
}
