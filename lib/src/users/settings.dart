import 'dart:async';
import 'dart:convert';

import 'package:clear_response/clear_response.dart';
import 'package:http/http.dart' as http;
import 'package:light_logger/light_logger.dart';
import 'package:teta_cms/src/constants.dart';
import 'package:teta_cms/src/data_stores/local/server_request_metadata_store.dart';
import 'package:teta_cms/teta_cms.dart';

/// Project settings
class ProjectSettings {
  /// Project settings
  ProjectSettings(
    this._serverRequestMetadata,
  );

  ///This stores the token and project id headers.
  final ServerRequestMetadataStore _serverRequestMetadata;

  Future<ClearResponse<List<dynamic>, ClearErrorResponse?>> invoices() async {
    final serverMetadata = _serverRequestMetadata.getMetadata();

    final uri = Uri.parse(
      '${Constants.oldTetaUrl}auth/invoices/${serverMetadata.prjId}',
    );

    final res = await http.get(
      uri,
      headers: {
        'authorization': 'Bearer ${serverMetadata.token}',
      },
    );

    if (res.statusCode != 200) {
      return ClearResponse(
        data: <dynamic>[],
        error: ClearErrorResponse(
          code: res.statusCode,
          message: res.body,
        ),
      );
    }

    final invoices = (json.decode(res.body) as Map<String, dynamic>?)?['data']
            as List<dynamic>? ??
        <dynamic>[];

    return ClearResponse(
      data: invoices,
      error: null,
    );
  }

  Future<ClearResponse<double, ClearErrorResponse?>> retrieveSpaceUsed() async {
    final serverMetadata = _serverRequestMetadata.getMetadata();

    final uri = Uri.parse(
      '${Constants.oldTetaUrl}cms/space/${serverMetadata.prjId}',
    );

    final res = await http.get(
      uri,
      headers: {
        'authorization': 'Bearer ${serverMetadata.token}',
      },
    );

    if (res.statusCode != 200) {
      return ClearResponse(
        data: 0,
        error: ClearErrorResponse(
          code: res.statusCode,
          message: res.body,
        ),
      );
    }

    final spaceUsed =
        (json.decode(res.body) as Map<String, dynamic>)['spaceUsed'] as double;
    final mb = spaceUsed / 1000 / 1000;

    return ClearResponse(
      data: mb,
      error: null,
    );
  }

  Future<ClearResponse<PlanResponse?, ClearErrorResponse?>>
      retrievePlanInfo() async {
    final serverMetadata = _serverRequestMetadata.getMetadata();

    final uri = Uri.parse(
      '${Constants.oldTetaUrl}auth/premium/${serverMetadata.prjId}',
    );

    final res = await http.get(
      uri,
      headers: {
        'authorization': 'Bearer ${serverMetadata.token}',
      },
    );

    if (res.statusCode != 200) {
      return ClearResponse(
        data: null,
        error: ClearErrorResponse(
          code: res.statusCode,
          message: res.body,
        ),
      );
    }

    print(res.body);

    final data = PlanResponse.fromJson(
      json.decode(res.body) as Map<String, dynamic>,
    );

    return ClearResponse(
      data: data,
      error: null,
    );
  }

  /// Save OAuth providers credentials
  Future<void> saveCredentials({
    required final AuthCredentials credentials,
  }) async {
    final serverMetadata = _serverRequestMetadata.getMetadata();

    final uri = Uri.parse(
      '${Constants.oldTetaUrl}auth/credentials/${serverMetadata.prjId}',
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

    Logger.printMessage('saveCredentials body: ${res.body}');

    if (res.statusCode != 200) {
      throw Exception('saveCredentials resulted in ${res.statusCode}');
    }
  }

  /// Retrieve project credentials
  Future<AuthCredentials> retrieveCredentials() async {
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

    Logger.printWarning('retrieveCredentials body: ${res.body}');

    if (res.statusCode != 200) {
      throw Exception('retrieveCredentials resulted in ${res.statusCode}');
    }

    final map = json.decode(res.body) as Map<String, dynamic>;
    return AuthCredentials.fromJson(map);
  }
}
