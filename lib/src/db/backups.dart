import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:clear_response/clear_response.dart';
import 'package:http/http.dart' as http;
import 'package:light_logger/light_logger.dart';
import 'package:teta_cms/src/constants.dart';
import 'package:teta_cms/src/data_stores/local/server_request_metadata_store.dart';

/// Controls all the backups of the current prj
class Backups {
  /// Controls all the backups of the current prj
  Backups(
    this._serverRequestMetadata,
  );

  ///This stores the token and project id headers.
  final ServerRequestMetadataStore _serverRequestMetadata;

  /// Get all backups
  Future<ClearResponse<List<dynamic>?, ClearErrorResponse?>> all() async {
    final serverMetadata = _serverRequestMetadata.getMetadata();

    final uri =
        Uri.parse('${Constants.tetaUrl}backup/${serverMetadata.prjId}/list');

    final res = await http.get(
      uri,
      headers: {
        'authorization': 'Bearer ${serverMetadata.token}',
      },
    );

    Logger.printMessage('get backups: ${res.body}');

    if (res.statusCode != 200) {
      return ClearResponse<List<dynamic>?, ClearErrorResponse>(
        data: null,
        error: ClearErrorResponse(
          code: res.statusCode,
          message: res.body,
        ),
      );
    }

    final map = json.decode(res.body) as List<dynamic>;
    final backups =
        (map.first as Map<String, dynamic>)['paths'] as List<dynamic>;

    return ClearResponse<List<dynamic>, ClearErrorResponse?>(
      data: backups,
      error: null,
    );
  }

  /// Downloads a backup
  Future<ClearResponse<Uint8List, ClearErrorResponse?>> download(
    final String? backupId,
  ) async {
    final serverMetadata = _serverRequestMetadata.getMetadata();

    if (backupId != null) {
      final uri = Uri.parse(
          '${Constants.tetaUrl}backup/${serverMetadata.prjId}/download/$backupId');

      final res = await http.get(
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
    return ClearResponse<Uint8List, ClearErrorResponse>(
      data: Uint8List.fromList([]),
      error: ClearErrorResponse(
        message: 'Backup Id is null',
      ),
    );
  }

  /// Restores a backup
  Future<ClearResponse<void, ClearErrorResponse?>> restore(
    final String? backupId,
  ) async {
    final serverMetadata = _serverRequestMetadata.getMetadata();

    if (backupId != null) {
      final uri = Uri.parse(
          '${Constants.tetaUrl}backup/${serverMetadata.prjId}/restore/$backupId');

      final res = await http.get(
        uri,
        headers: {
          'authorization': 'Bearer ${serverMetadata.token}',
        },
      );

      if (res.statusCode != 202) {
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
    return ClearResponse<void, ClearErrorResponse>(
      data: null,
      error: ClearErrorResponse(
        message: 'Backup Id is null',
      ),
    );
  }
}
