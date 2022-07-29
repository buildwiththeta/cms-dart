import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:teta_cms/src/constants.dart';
import 'package:teta_cms/teta_cms.dart';

/// Project settings
class TetaProjectSettings {
  /// Project settings
  TetaProjectSettings(
    this.token,
    this.prjId,
  );

  /// Token of the current prj
  final String token;

  /// Id of the current prj
  final int prjId;

  Future<TetaResponse<TetaPlanResponse?, TetaErrorResponse?>>
      retrievePlanInfo() async {
    final uri = Uri.parse(
      '${Constants.tetaUrl}auth/premium/$prjId',
    );

    final res = await http.get(
      uri,
      headers: {
        'authorization': 'Bearer $token',
      },
    );

    if (res.statusCode != 200) {
      return TetaResponse(
        data: null,
        error: TetaErrorResponse(
          code: res.statusCode,
          message: res.body,
        ),
      );
    }

    final data = TetaPlanResponse.fromJson(
      json.decode(res.body) as Map<String, dynamic>,
    );

    return TetaResponse(
      data: data,
      error: null,
    );
  }

  /// Save OAuth providers credentials
  Future<void> saveCredentials({
    required final TetaAuthCredentials credentials,
  }) async {
    final uri = Uri.parse(
      '${Constants.tetaUrl}auth/credentials/$prjId',
    );

    final res = await http.post(
      uri,
      headers: {
        'authorization': 'Bearer $token',
        'content-type': 'application/json',
      },
      body: json.encode(
        credentials.toJson(),
      ),
    );

    TetaCMS.log('saveCredentials body: ${res.body}');

    if (res.statusCode != 200) {
      throw Exception('saveCredentials resulted in ${res.statusCode}');
    }

    unawaited(
      TetaCMS.instance.analytics.insertEvent(
        TetaAnalyticsType.tetaAuthSaveCredentials,
        'Teta Auth: save credentials request',
        <String, dynamic>{
          'weight': res.bodyBytes.lengthInBytes,
        },
        isUserIdPreferableIfExists: false,
      ),
    );
  }

  /// Retrieve project credentials
  Future<TetaAuthCredentials> retrieveCredentials() async {
    final uri = Uri.parse(
      '${Constants.tetaUrl}auth/credentials/services/$prjId',
    );

    final res = await http.get(
      uri,
      headers: {
        'authorization': 'Bearer $token',
      },
    );

    TetaCMS.printWarning('retrieveCredentials body: ${res.body}');

    if (res.statusCode != 200) {
      throw Exception('retrieveCredentials resulted in ${res.statusCode}');
    }

    unawaited(
      TetaCMS.instance.analytics.insertEvent(
        TetaAnalyticsType.tetaAuthRetrieveCredentials,
        'Teta Auth: retrieve credentials request',
        <String, dynamic>{
          'weight': res.bodyBytes.lengthInBytes,
        },
        isUserIdPreferableIfExists: false,
      ),
    );

    final map = json.decode(res.body) as Map<String, dynamic>;
    return TetaAuthCredentials.fromJson(map);
  }
}
