import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:enum_to_string/enum_to_string.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:teta_cms/src/constants.dart';
import 'package:teta_cms/src/data_stores/local/server_request_metadata_store.dart';
import 'package:teta_cms/teta_cms.dart';

/// Control all the policies in a project
@lazySingleton
class TetaPolicies {
  /// Control all the policies in a project
  TetaPolicies(this._serverRequestMetadata);

  ///This stores the token and project id headers.
  final ServerRequestMetadataStore _serverRequestMetadata;

  /// Get all policies
  Future<TetaResponse<Map<String, dynamic>?, TetaErrorResponse?>> all(
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

    TetaCMS.log('get backups: ${res.body}');

    if (res.statusCode != 200) {
      return TetaResponse<Map<String, dynamic>?, TetaErrorResponse>(
        data: null,
        error: TetaErrorResponse(
          code: res.statusCode,
          message: res.body,
        ),
      );
    }

    try {
      unawaited(
        TetaCMS.instance.analytics.insertEvent(
          TetaAnalyticsType.getPolicies,
          'Teta CMS: get policies',
          <String, dynamic>{
            'weight': res.bodyBytes.lengthInBytes,
          },
          isUserIdPreferableIfExists: false,
        ),
      );
    } catch (_) {}

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

    return TetaResponse<Map<String, dynamic>, TetaErrorResponse?>(
      data: backups,
      error: null,
    );
  }

  /// Insert a new policy
  Future<TetaResponse<Uint8List, TetaErrorResponse?>> insert(
    final String collId,
    final String key,
    final String value,
    final TetaPolicyScope scope,
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

    TetaCMS.log('get backup: ${res.body}');

    if (res.statusCode != 200) {
      return TetaResponse<Uint8List, TetaErrorResponse>(
        data: Uint8List.fromList([]),
        error: TetaErrorResponse(
          code: res.statusCode,
          message: res.body,
        ),
      );
    }

    try {
      unawaited(
        TetaCMS.instance.analytics.insertEvent(
          TetaAnalyticsType.insertPolicy,
          'Teta CMS: insert new policy',
          <String, dynamic>{},
          isUserIdPreferableIfExists: false,
        ),
      );
    } catch (_) {}

    return TetaResponse<Uint8List, TetaErrorResponse?>(
      data: res.bodyBytes,
      error: null,
    );
  }

  /// Deletes a new policy
  Future<TetaResponse<void, TetaErrorResponse?>> delete(
    final String collId,
    final TetaPolicyScope scope,
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
      return TetaResponse<void, TetaErrorResponse>(
        data: null,
        error: TetaErrorResponse(
          code: res.statusCode,
          message: res.body,
        ),
      );
    }

    try {
      unawaited(
        TetaCMS.instance.analytics.insertEvent(
          TetaAnalyticsType.deletePolicy,
          'Teta CMS: delete policy',
          <String, dynamic>{},
          isUserIdPreferableIfExists: false,
        ),
      );
    } catch (_) {}

    return TetaResponse<void, TetaErrorResponse?>(
      data: null,
      error: null,
    );
  }
}
