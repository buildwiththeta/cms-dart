import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:teta_cms/src/constants.dart';
import 'package:teta_cms/src/data_stores/local/server_request_metadata_store.dart';
import 'package:teta_cms/teta_cms.dart';

/// Project settings
@lazySingleton
class TetaProjectSettings {
  /// Project settings
  TetaProjectSettings(
    this._serverRequestMetadata,
  );

  ///This stores the token and project id headers.
  final ServerRequestMetadataStore _serverRequestMetadata;

  Future<TetaResponse<List<dynamic>, TetaErrorResponse?>> invoices() async {
    final serverMetadata = _serverRequestMetadata.getMetadata();

    final uri = Uri.parse(
      '${Constants.tetaUrl}auth/invoices/${serverMetadata.prjId}',
    );

    final res = await http.get(
      uri,
      headers: {
        'authorization': 'Bearer ${serverMetadata.token}',
      },
    );

    if (res.statusCode != 200) {
      return TetaResponse(
        data: <dynamic>[],
        error: TetaErrorResponse(
          code: res.statusCode,
          message: res.body,
        ),
      );
    }

    final invoices = (json.decode(res.body) as Map<String, dynamic>?)?['data']
            as List<dynamic>? ??
        <dynamic>[];

    return TetaResponse(
      data: invoices,
      error: null,
    );
  }

  Future<TetaResponse<double, TetaErrorResponse?>> retrieveSpaceUsed() async {
    final serverMetadata = _serverRequestMetadata.getMetadata();

    final uri = Uri.parse(
      '${Constants.tetaUrl}cms/space/${serverMetadata.prjId}',
    );

    final res = await http.get(
      uri,
      headers: {
        'authorization': 'Bearer ${serverMetadata.token}',
      },
    );

    if (res.statusCode != 200) {
      return TetaResponse(
        data: 0,
        error: TetaErrorResponse(
          code: res.statusCode,
          message: res.body,
        ),
      );
    }

    final spaceUsed =
        (json.decode(res.body) as Map<String, dynamic>)['spaceUsed'] as double;
    final mb = spaceUsed / 1000 / 1000;

    return TetaResponse(
      data: mb,
      error: null,
    );
  }

  Future<TetaResponse<TetaPlanResponse?, TetaErrorResponse?>>
      retrievePlanInfo() async {
    final serverMetadata = _serverRequestMetadata.getMetadata();

    final uri = Uri.parse(
      '${Constants.tetaUrl}auth/premium/${serverMetadata.prjId}',
    );

    final res = await http.get(
      uri,
      headers: {
        'authorization': 'Bearer ${serverMetadata.token}',
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
    final serverMetadata = _serverRequestMetadata.getMetadata();

    final uri = Uri.parse(
      '${Constants.tetaUrl}auth/credentials/${serverMetadata.prjId}',
    );

    final res = await http.post(
      uri,
      headers: {
        'authorization': 'Bearer ${serverMetadata.token}',
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
    final serverMetadata = _serverRequestMetadata.getMetadata();

    final uri = Uri.parse(
      '${Constants.oldTetaUrl}auth/credentials/services/${serverMetadata.prjId}',
    );

    final res = await http.get(
      uri,
      headers: {
        'authorization': 'Bearer ${serverMetadata.token}',
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
