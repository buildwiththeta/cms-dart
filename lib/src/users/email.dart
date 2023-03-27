import 'dart:async';
import 'dart:convert';

import 'package:clear_response/clear_response.dart';
import 'package:http/http.dart' as http;
import 'package:light_logger/light_logger.dart';
import 'package:teta_cms/src/constants.dart';
import 'package:teta_cms/src/data_stores/local/server_request_metadata_store.dart';
import 'package:teta_cms/teta_cms.dart';

/// Project settings
class TetaEmail {
  /// Project settings
  TetaEmail(
    this._serverRequestMetadata,
  );

  ///This stores the token and project id headers.
  final ServerRequestMetadataStore _serverRequestMetadata;

  /// Get email info
  Future<ClearResponse<EmailResponse?, ClearErrorResponse?>> info() async {
    final requestMetadata = _serverRequestMetadata.getMetadata();

    final uri = Uri.parse(
      '${Constants.emailUrl}info/${requestMetadata.prjId}',
    );

    final res = await http.get(
      uri,
      headers: {
        'authorization': 'Bearer ${requestMetadata.token}',
      },
    );

    Logger.printMessage('get email info body: ${res.body}');

    if (res.statusCode != 200) {
      return ClearResponse(
        data: null,
        error: ClearErrorResponse(
          code: res.statusCode,
          message: res.body,
        ),
      );
    }

    final data = json.decode(res.body) as Map<String, dynamic>?;
    if (data != null) {
      final result = EmailResponse.fromJson(data);

      return ClearResponse(
        data: result,
        error: null,
      );
    } else {
      return ClearResponse(
        data: null,
        error: ClearErrorResponse(
          code: res.statusCode,
          message: 'Impossible to fetch res.body',
        ),
      );
    }
  }

  /// Retrieve project credentials
  Future<ClearResponse<bool, ClearErrorResponse?>> send({
    required final String templateId,
    required final String fromName,
    required final String fromAddress,
    required final String to,
  }) async {
    final requestMetadata = _serverRequestMetadata.getMetadata();

    final uri = Uri.parse(
      '${Constants.emailUrl}send/${requestMetadata.prjId}/$templateId',
    );

    final res = await http.post(
      uri,
      headers: {
        'authorization': 'Bearer ${requestMetadata.token}',
        'content-type': 'application/json',
      },
      body: json.encode(<String, dynamic>{
        'to': to,
        'from': '$fromName<$fromAddress>',
      }),
    );

    if (res.statusCode != 200) {
      return ClearResponse(
        data: false,
        error: ClearErrorResponse(
          code: res.statusCode,
          message: res.body,
        ),
      );
    }

    return ClearResponse(
      data: true,
      error: null,
    );
  }

  /// Insert new template
  Future<ClearResponse<bool, ClearErrorResponse?>> insertTemplate(
    final EmailTemplate template,
  ) async {
    final requestMetadata = _serverRequestMetadata.getMetadata();

    final uri = Uri.parse(
      '${Constants.emailUrl}email/template/${requestMetadata.prjId}',
    );

    final res = await http.post(
      uri,
      headers: {
        'authorization': 'Bearer ${requestMetadata.token}',
        'content-type': 'application/json',
      },
      body: json.encode(template.toJson()),
    );

    if (res.statusCode != 200) {
      return ClearResponse(
        data: false,
        error: ClearErrorResponse(
          code: res.statusCode,
          message: res.body,
        ),
      );
    }

    return ClearResponse(
      data: true,
      error: null,
    );
  }

  /// Delete a template
  Future<ClearResponse<bool, ClearErrorResponse?>> deleteTemplate(
    final String templateId,
  ) async {
    final requestMetadata = _serverRequestMetadata.getMetadata();

    final uri = Uri.parse(
      '${Constants.emailUrl}email/template/${requestMetadata.prjId}/$templateId',
    );

    final res = await http.delete(
      uri,
      headers: {
        'authorization': 'Bearer ${requestMetadata.token}',
      },
    );

    if (res.statusCode != 200) {
      return ClearResponse(
        data: false,
        error: ClearErrorResponse(
          code: res.statusCode,
          message: res.body,
        ),
      );
    }

    return ClearResponse(
      data: true,
      error: null,
    );
  }

  /// Update a template
  Future<ClearResponse<bool, ClearErrorResponse?>> updateTemplate(
    final EmailTemplate template,
  ) async {
    final requestMetadata = _serverRequestMetadata.getMetadata();

    final uri = Uri.parse(
      '${Constants.emailUrl}email/template/${requestMetadata.prjId}',
    );

    final res = await http.post(
      uri,
      headers: {
        'authorization': 'Bearer ${requestMetadata.token}',
        'content-type': 'application/json',
      },
      body: json.encode(template.toJson()),
    );

    if (res.statusCode != 200) {
      return ClearResponse(
        data: false,
        error: ClearErrorResponse(
          code: res.statusCode,
          message: res.body,
        ),
      );
    }

    return ClearResponse(
      data: true,
      error: null,
    );
  }
}
