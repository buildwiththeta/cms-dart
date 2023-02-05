import 'dart:convert';

import 'package:enum_to_string/enum_to_string.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:teta_cms/src/constants.dart';
import 'package:teta_cms/src/data_stores/local/server_request_metadata_store.dart';
import 'package:teta_cms/teta_cms.dart';

/// Teta Analytics is our service to track events in an OLAP DB
@lazySingleton
class TetaAnalytics {
  ///
  TetaAnalytics(this._serverRequestMetadata) {
    init();
  }

  ///This stores the token and project id headers.
  final ServerRequestMetadataStore _serverRequestMetadata;

  ///Get token
  String get token => _serverRequestMetadata.getMetadata().token;

  /// Get current project id
  int get prjId => _serverRequestMetadata.getMetadata().prjId;

  Map<String, String> get _getPrjHeader => <String, String>{
        'x-identifier': prjId.toString(),
      };

  Map<String, String> get _getJsonHeader => <String, String>{
        'content-type': 'application/json',
      };

  /// Get auth token, content-type and prj id headers
  Map<String, String> get _getDefaultHeaders {
    return <String, String>{
      'authorization': 'Bearer $token}',
      ..._getJsonHeader,
      ..._getPrjHeader,
    };
  }

  /// Detected id of the logged user
  String? _currentUserId;

  /// Initialize the logged user id
  Future init({final String? userId}) async {
    _currentUserId = userId ?? (await TetaCMS.instance.auth.user.get).uid;
  }

  /// Creates a new event
  Future<TetaResponse<dynamic, TetaErrorResponse?>> insertEvent(
    final TetaAnalyticsType type,
    final String description,
    final Map<String, dynamic> properties, {
    required final bool isUserIdPreferableIfExists,
  }) async {
    final uri = Uri.parse(
      '${Constants.analyticsUrl}events/add/${EnumToString.convertToString(type)}',
    );
    final serverMetadata = _serverRequestMetadata.getMetadata();

    final res = await http.post(
      uri,
      headers: _getDefaultHeaders,
      body: json.encode(<String, dynamic>{
        'description': description,
        'prj_id': {serverMetadata.prjId},
        if (isUserIdPreferableIfExists && _currentUserId != null)
          'user_id': _currentUserId,
        ...properties,
      }),
    );
    if (res.statusCode != 200) {
      return TetaResponse<dynamic, TetaErrorResponse>(
        data: null,
        error: TetaErrorResponse(
          code: res.statusCode,
          message: res.body,
        ),
      );
    }
    return TetaResponse<dynamic, TetaErrorResponse?>(
      data: res.body,
      error: null,
    );
  }

  /// Creates a new event
  Future<TetaResponse<dynamic, TetaErrorResponse?>> get(
    final String ayayaQuery,
  ) async {
    final uri = Uri.parse(
      '${Constants.analyticsUrl}events/aya',
    );
    final serverMetadata = _serverRequestMetadata.getMetadata();
    final res = await http.post(
      uri,
      headers: {
        'authorization': 'Bearer ${serverMetadata.token}',
        ..._getPrjHeader,
      },
      body: ayayaQuery,
    );
    if (res.statusCode != 200) {
      return TetaResponse<dynamic, TetaErrorResponse>(
        data: null,
        error: TetaErrorResponse(
          code: res.statusCode,
          message: res.body,
        ),
      );
    }
    final isCount = ((json.decode(res.body) as List<dynamic>?)?.first
            as Map<String, dynamic>?)?['count'] !=
        null;
    return TetaResponse<dynamic, TetaErrorResponse?>(
      data: !isCount
          ? (((json.decode(res.body) as List<dynamic>?)?.first
                  as Map<String, dynamic>?)?['data'] as List<dynamic>? ??
              <dynamic>[])
          : (((json.decode(res.body) as List<dynamic>?)?.first
                  as Map<String, dynamic>?)?['count'] as int? ??
              0),
      error: null,
    );
  }
}
