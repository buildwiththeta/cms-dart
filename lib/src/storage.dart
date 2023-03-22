import 'dart:async';
import 'dart:convert';

import 'package:cross_file/cross_file.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:teta_cms/src/constants.dart';
import 'package:teta_cms/src/data_stores/local/server_request_metadata_store.dart';
import 'package:teta_cms/src/models/file.dart';
import 'package:teta_cms/teta_cms.dart';

/// The CMS client to interact with the db
@lazySingleton
class TetaStorage {
  /// Client to interact with the Teta CMS's db
  TetaStorage(
    this._serverRequestMetadata,
  );

  ///This stores the token and project id headers.
  final ServerRequestMetadataStore _serverRequestMetadata;

  ///Get token
  String get token => _serverRequestMetadata.getMetadata().token;

  /// Get current project id
  int get prjId => _serverRequestMetadata.getMetadata().prjId;

  Map<String, String> get _getJsonHeader => <String, String>{
        'content-type': 'application/json',
      };

  /// Get auth token, content-type and prj id headers
  Map<String, String> get _getDefaultHeaders {
    return <String, String>{
      'authorization': 'Bearer $token',
      ..._getJsonHeader,
    };
  }

  void _registerEvent({
    required final TetaAnalyticsType event,
    required final String description,
    final Map<String, dynamic> props = const <String, dynamic>{},
    final bool useUserId = false,
  }) {
    try {
      unawaited(
        TetaCMS.instance.analytics.insertEvent(
          event,
          description,
          props,
          isUserIdPreferableIfExists: useUserId,
        ),
      );
    } catch (e) {
      TetaCMS.printError(
        'Error inserting a new event in Teta Analytics, error: $e',
      );
    }
  }

  Future<TetaResponse<List<TetaStorageFile>?, TetaErrorResponse?>> upload(
      List<XFile> files) async {
    assert(files.length <= 5, 'Files length must be less or equal to 5');
    final url = '/$prjId';
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.headers.addAll(_getDefaultHeaders);
    for (final file in files) {
      request.files
          .add(await http.MultipartFile.fromPath('ImagePaths', file.path));
    }
    http.StreamedResponse response = await request.send();
    final resBody = await response.stream.bytesToString();
    var body = jsonDecode(resBody);
    if (response.statusCode == 200) {
      final list = (body as List<dynamic>)
          .map((e) => TetaStorageFile.fromJson(
                e as Map<String, dynamic>,
              ))
          .toList();
      return TetaResponse(data: list, error: null);
    } else {
      return TetaResponse(
        data: null,
        error: TetaErrorResponse(
            code: response.statusCode,
            message: 'Error uploading files, error: $body'),
      );
    }
  }

  Future<TetaResponse<List<TetaStorageFile>?, TetaErrorResponse?>> getFiles(
      List<int> fileIds) async {
    final uri = Uri.parse('${Constants.tetaUrl}/$prjId/list');
    final res = await http.get(
      uri,
      headers: _getDefaultHeaders,
    );
    if (res.statusCode == 200) {
      final list = (res.body as List<dynamic>)
          .map((e) => TetaStorageFile.fromJson(
                e as Map<String, dynamic>,
              ))
          .toList();
      return TetaResponse(data: list, error: null);
    } else {
      return TetaResponse(
        data: null,
        error: TetaErrorResponse(
          code: res.statusCode,
          message: 'Error reading files info, error: ${res.body}',
        ),
      );
    }
  }

  Future<TetaResponse<List<TetaStorageFile>?, TetaErrorResponse?>> getFilesInfo(
      List<int> fileIds) async {
    final uri = Uri.parse('${Constants.tetaUrl}/$prjId/files/info');
    final res = await http.post(
      uri,
      headers: _getDefaultHeaders,
      body: json.encode(
        fileIds,
      ),
    );
    if (res.statusCode == 200) {
      final list = (res.body as List<dynamic>)
          .map((e) => TetaStorageFile.fromJson(
                e as Map<String, dynamic>,
              ))
          .toList();
      return TetaResponse(data: list, error: null);
    } else {
      return TetaResponse(
        data: null,
        error: TetaErrorResponse(
          code: res.statusCode,
          message: 'Error reading files info, error: ${res.body}',
        ),
      );
    }
  }

  Future<TetaResponse<List<TetaStorageFile>?, TetaErrorResponse?>> setSlug(
    int fileId,
    String slug,
  ) async {
    final uri = Uri.parse('${Constants.tetaUrl}/slug/$prjId/$fileId/$slug');
    final res = await http.post(
      uri,
      headers: _getDefaultHeaders,
    );
    if (res.statusCode == 200) {
      final list = (res.body as List<dynamic>)
          .map((e) => TetaStorageFile.fromJson(
                e as Map<String, dynamic>,
              ))
          .toList();
      return TetaResponse(data: list, error: null);
    } else {
      return TetaResponse(
        data: null,
        error: TetaErrorResponse(
          code: res.statusCode,
          message: 'Error reading files info, error: ${res.body}',
        ),
      );
    }
  }

  Future<TetaResponse<bool, TetaErrorResponse?>> setPassword(
    int fileId,
    String password,
  ) async {
    final uri = Uri.parse('${Constants.tetaUrl}/$prjId/$fileId/$password');
    final res = await http.post(
      uri,
      headers: _getDefaultHeaders,
    );
    if (res.statusCode == 200) {
      final value = res.body as bool? ?? false;
      return TetaResponse(data: value, error: null);
    } else {
      return TetaResponse(
        data: false,
        error: TetaErrorResponse(
          code: res.statusCode,
          message: 'Error reading files info, error: ${res.body}',
        ),
      );
    }
  }

  Future<TetaResponse<TetaStorageFile?, TetaErrorResponse?>> getFileById(
    int fileId,
  ) async {
    final uri = Uri.parse('${Constants.tetaUrl}/$prjId/file/$fileId/');
    final res = await http.get(
      uri,
      headers: _getDefaultHeaders,
    );
    if (res.statusCode == 200) {
      return TetaResponse(
        data: TetaStorageFile.fromJson(res.body as Map<String, dynamic>),
        error: null,
      );
    } else {
      return TetaResponse(
        data: null,
        error: TetaErrorResponse(
          code: res.statusCode,
          message: 'Error reading files info, error: ${res.body}',
        ),
      );
    }
  }

  Future<TetaResponse<TetaStorageFile?, TetaErrorResponse?>> getFileBySlug(
    int fileSlug,
  ) async {
    final uri = Uri.parse('${Constants.tetaUrl}/$fileSlug');
    final res = await http.get(
      uri,
    );
    if (res.statusCode == 200) {
      return TetaResponse(
        data: TetaStorageFile.fromJson(res.body as Map<String, dynamic>),
        error: null,
      );
    } else {
      return TetaResponse(
        data: null,
        error: TetaErrorResponse(
          code: res.statusCode,
          message: 'Error reading files info, error: ${res.body}',
        ),
      );
    }
  }

  Future<TetaResponse<void, TetaErrorResponse?>> deleteFilesById(
    List<int> fileIds,
  ) async {
    final uri = Uri.parse('${Constants.tetaUrl}/$prjId');
    final res = await http.delete(
      uri,
      headers: _getDefaultHeaders,
      body: jsonEncode(fileIds),
    );
    if (res.statusCode == 200) {
      return TetaResponse(
        data: null,
        error: null,
      );
    } else {
      return TetaResponse(
        data: null,
        error: TetaErrorResponse(
          code: res.statusCode,
          message: 'Error reading files info, error: ${res.body}',
        ),
      );
    }
  }
}
