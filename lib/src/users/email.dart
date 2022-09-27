import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:teta_cms/src/constants.dart';
import 'package:teta_cms/src/data_stores/local/server_request_metadata_store.dart';
import 'package:teta_cms/teta_cms.dart';

/// Project settings
@lazySingleton
class TetaEmail {
  /// Project settings
  TetaEmail(
    this.serverRequestMetadata,
  );

  ///This stores the token and project id headers.
  final ServerRequestMetadataStore serverRequestMetadata;

  /// Get email info
  Future<TetaResponse<TetaEmailResponse?, TetaErrorResponse?>> info() async {
    final requestMetadata = serverRequestMetadata.getMetadata();

    final uri = Uri.parse(
      '${Constants.emailUrl}info/${requestMetadata.prjId}',
    );

    final res = await http.get(
      uri,
      headers: {
        'authorization': 'Bearer ${requestMetadata.token}',
      },
    );

    TetaCMS.log('get email info body: ${res.body}');

    if (res.statusCode != 200) {
      return TetaResponse(
        data: null,
        error: TetaErrorResponse(
          code: res.statusCode,
          message: res.body,
        ),
      );
    }

    unawaited(
      TetaCMS.instance.analytics.insertEvent(
        TetaAnalyticsType.emailInfo,
        'Teta Auth: get email info',
        <String, dynamic>{
          'weight': res.bodyBytes.lengthInBytes,
        },
        isUserIdPreferableIfExists: false,
      ),
    );

    final data = json.decode(res.body) as Map<String, dynamic>?;
    if (data != null) {
      final result = TetaEmailResponse.fromJson(data);

      return TetaResponse(
        data: result,
        error: null,
      );
    } else {
      return TetaResponse(
        data: null,
        error: TetaErrorResponse(
          code: res.statusCode,
          message: 'Impossible to fetch res.body',
        ),
      );
    }
  }

  /// Retrieve project credentials
  Future<TetaResponse<bool, TetaErrorResponse?>> send({
    required final String templateId,
    required final String fromName,
    required final String fromAddress,
    required final String to,
  }) async {
    final requestMetadata = serverRequestMetadata.getMetadata();

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
      return TetaResponse(
        data: false,
        error: TetaErrorResponse(
          code: res.statusCode,
          message: res.body,
        ),
      );
    }

    unawaited(
      TetaCMS.instance.analytics.insertEvent(
        TetaAnalyticsType.emailSend,
        'Teta Auth: send email',
        <String, dynamic>{},
        isUserIdPreferableIfExists: false,
      ),
    );

    return TetaResponse(
      data: true,
      error: null,
    );
  }

  /// Insert new template
  Future<TetaResponse<bool, TetaErrorResponse?>> insertTemplate(
    final TetaEmailTemplate template,
  ) async {
    final requestMetadata = serverRequestMetadata.getMetadata();

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
      return TetaResponse(
        data: false,
        error: TetaErrorResponse(
          code: res.statusCode,
          message: res.body,
        ),
      );
    }

    unawaited(
      TetaCMS.instance.analytics.insertEvent(
        TetaAnalyticsType.emailInsertTemplate,
        'Teta Auth: insert new template',
        <String, dynamic>{},
        isUserIdPreferableIfExists: false,
      ),
    );

    return TetaResponse(
      data: true,
      error: null,
    );
  }

  /// Delete a template
  Future<TetaResponse<bool, TetaErrorResponse?>> deleteTemplate(
    final String templateId,
  ) async {
    final requestMetadata = serverRequestMetadata.getMetadata();

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
      return TetaResponse(
        data: false,
        error: TetaErrorResponse(
          code: res.statusCode,
          message: res.body,
        ),
      );
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

    return TetaResponse(
      data: true,
      error: null,
    );
  }

  /// Update a template
  Future<TetaResponse<bool, TetaErrorResponse?>> updateTemplate(
    final TetaEmailTemplate template,
  ) async {
    final requestMetadata = serverRequestMetadata.getMetadata();

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
      return TetaResponse(
        data: false,
        error: TetaErrorResponse(
          code: res.statusCode,
          message: res.body,
        ),
      );
    }

    unawaited(
      TetaCMS.instance.analytics.insertEvent(
        TetaAnalyticsType.emailInsertTemplate,
        'Teta Auth: insert new template',
        <String, dynamic>{},
        isUserIdPreferableIfExists: false,
      ),
    );

    return TetaResponse(
      data: true,
      error: null,
    );
  }
}
