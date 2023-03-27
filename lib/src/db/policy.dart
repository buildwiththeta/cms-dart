import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:clear_response/clear_response.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:http/http.dart' as http;
import 'package:light_logger/light_logger.dart';
import 'package:teta_cms/src/constants.dart';
import 'package:teta_cms/src/data_stores/local/server_request_metadata_store.dart';
import 'package:teta_cms/teta_cms.dart';

/// Control all the policies in a project
class Policies {
  /// Control all the policies in a project
  Policies(this._serverRequestMetadata);

  ///This stores the token and project id headers.
  final ServerRequestMetadataStore _serverRequestMetadata;

  /// Get all policies
  Future<ClearResponse<Map<String, dynamic>?, ClearErrorResponse?>> all(
    final String collId,
  ) async {
    final serverMetadata = _serverRequestMetadata.getMetadata();

    final uri = Uri.parse(
      '${Constants.oldTetaUrl}cms/policy/${serverMetadata.prjId}/$collId',
    );

    final res = await http.get(
      uri,
      headers: {
        'authorization': 'Bearer ${serverMetadata.token}',
      },
    );

    Logger.printMessage('get backups: ${res.body}');

    if (res.statusCode != 200) {
      return ClearResponse<Map<String, dynamic>?, ClearErrorResponse>(
        data: null,
        error: ClearErrorResponse(
          code: res.statusCode,
          message: res.body,
        ),
      );
    }

    final map = json.decode(res.body) as Map<String, dynamic>;
    final backups = <String, dynamic>{};

    if (map['policy']?['read'] != null) {
      backups['read'] = (map['policy'] as Map<String, dynamic>?)?['read'];
    }
    if (map['policy']?['update'] != null) {
      backups['update'] = (map['policy'] as Map<String, dynamic>?)?['update'];
    }
    if (map['policy']?['delete'] != null) {
      backups['delete'] = (map['policy'] as Map<String, dynamic>?)?['delete'];
    }

    return ClearResponse<Map<String, dynamic>, ClearErrorResponse?>(
      data: backups,
      error: null,
    );
  }

  /// Insert a new policy
  Future<ClearResponse<Uint8List, ClearErrorResponse?>> insert(
    final String collId,
    final String key,
    final String value,
    final PolicyScope scope,
  ) async {
    final serverMetadata = _serverRequestMetadata.getMetadata();

    final scopeStr = EnumToString.convertToString(scope);
    final uri = Uri.parse(
      '${Constants.oldTetaUrl}cms/policy/$scopeStr/${serverMetadata.prjId}/$collId/$key/$value',
    );

    final res = await http.post(
      uri,
      headers: {
        'authorization': 'Bearer ${serverMetadata.token}',
      },
    );

    Logger.printMessage('get backup: ${res.body}');

    if (res.statusCode != 200) {
      return ClearResponse<Uint8List, ClearErrorResponse>(
        data: Uint8List.fromList([]),
        error: ClearErrorResponse(
          code: res.statusCode,
          message: res.body,
        ),
      );
    }

    return ClearResponse<Uint8List, ClearErrorResponse?>(
      data: res.bodyBytes,
      error: null,
    );
  }

  /// Deletes a new policy
  Future<ClearResponse<void, ClearErrorResponse?>> delete(
    final String collId,
    final PolicyScope scope,
  ) async {
    final serverMetadata = _serverRequestMetadata.getMetadata();

    final scopeStr = EnumToString.convertToString(scope);
    final uri = Uri.parse(
      '${Constants.oldTetaUrl}cms/policy/${serverMetadata.prjId}/$collId/$scopeStr',
    );

    final res = await http.delete(
      uri,
      headers: {
        'authorization': 'Bearer ${serverMetadata.token}',
      },
    );

    if (res.statusCode != 200) {
      return ClearResponse<void, ClearErrorResponse>(
        data: null,
        error: ClearErrorResponse(
          code: res.statusCode,
          message: res.body,
        ),
      );
    }

    return ClearResponse<void, ClearErrorResponse?>(
      data: null,
      error: null,
    );
  }
}
