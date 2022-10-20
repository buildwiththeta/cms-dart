import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:teta_cms/src/constants.dart';
import 'package:teta_cms/src/data_stores/local/server_request_metadata_store.dart';
import 'package:teta_cms/teta_cms.dart';

/// Controls all the backups of the current prj
@lazySingleton
class TetaBackups {
  /// Controls all the backups of the current prj
  TetaBackups(
    this._serverRequestMetadata,
  );

  ///This stores the token and project id headers.
  final ServerRequestMetadataStore _serverRequestMetadata;

  /// Get all backups
  Future<TetaResponse<List<dynamic>?, TetaErrorResponse?>> all() async {
    final serverMetadata = _serverRequestMetadata.getMetadata();

    final uri = Uri.parse('${Constants.tetaUrl}backup/${serverMetadata.prjId}/list');

    final res = await http.get(
      uri,
      headers: {
        'authorization': 'Bearer ${serverMetadata.token}',
      },
    );

    TetaCMS.log('get backups: ${res.body}');

    if (res.statusCode != 200) {
      return TetaResponse<List<dynamic>?, TetaErrorResponse>(
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
          TetaAnalyticsType.getBackups,
          'Teta CMS: get backups',
          <String, dynamic>{
            'weight': res.bodyBytes.lengthInBytes,
          },
          isUserIdPreferableIfExists: false,
        ),
      );
    } catch (_) {}

    final map = json.decode(res.body) as List<dynamic>;
    final backups =
        (map.first as Map<String, dynamic>)['paths'] as List<dynamic>;

    return TetaResponse<List<dynamic>, TetaErrorResponse?>(
      data: backups,
      error: null,
    );
  }

  /// Downloads a backup
  Future<TetaResponse<Uint8List, TetaErrorResponse?>> download(
    final String? backupId,
  ) async {
    final serverMetadata = _serverRequestMetadata.getMetadata();

    if (backupId != null) {
      final uri =
          Uri.parse('${Constants.tetaUrl}backup/${serverMetadata.prjId}/download/$backupId');

      final res = await http.get(
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
            TetaAnalyticsType.downloadBackup,
            'Teta CMS: download backup request',
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
    return TetaResponse<Uint8List, TetaErrorResponse>(
      data: Uint8List.fromList([]),
      error: TetaErrorResponse(
        message: 'Backup Id is null',
      ),
    );
  }

  /// Restores a backup
  Future<TetaResponse<void, TetaErrorResponse?>> restore(
    final String? backupId,
  ) async {
    final serverMetadata = _serverRequestMetadata.getMetadata();

    if (backupId != null) {
      final uri =
          Uri.parse('${Constants.tetaUrl}backup/${serverMetadata.prjId}/restore/$backupId');

      final res = await http.get(
        uri,
        headers: {
          'authorization': 'Bearer ${serverMetadata.token}',
        },
      );

      if (res.statusCode != 202) {
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
            TetaAnalyticsType.restoreBackup,
            'Teta CMS: restore backup request',
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
    return TetaResponse<void, TetaErrorResponse>(
      data: null,
      error: TetaErrorResponse(
        message: 'Backup Id is null',
      ),
    );
  }
}
