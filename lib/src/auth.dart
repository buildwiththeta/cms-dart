import 'dart:async';
import 'dart:convert';

import 'package:clear_response/clear_response.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:light_logger/light_logger.dart';
import 'package:teta_cms/src/constants.dart';
import 'package:teta_cms/src/data_stores/local/server_request_metadata_store.dart';
import 'package:teta_cms/src/platform/index.dart';
import 'package:teta_cms/src/use_cases/get_server_request_headers/get_server_request_headers.dart';
import 'package:teta_cms/src/users/settings.dart';
import 'package:teta_cms/src/users/user.dart';
import 'package:teta_cms/teta_cms.dart';
import 'package:uni_links/uni_links.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:url_launcher/url_launcher.dart';

/// Teta Auth - Control all the methods about authentication

class Authentication {
  /// Teta Auth - Control all the methods about authentication
  Authentication(
    this.project,
    this.user,
    this._serverRequestMetadata,
    this._getServerRequestHeaders,
  );

  /// Project settings
  final ProjectSettings project;

  /// User utils
  final UserUtils user;

  ///This stores the token and project id headers.
  final ServerRequestMetadataStore _serverRequestMetadata;

  ///Get standard Teta heders
  final GetServerRequestHeaders _getServerRequestHeaders;

  /// Insert a new user inside the prj
  Future<bool> insertUser(final String userToken) async {
    final requestMetadata = _serverRequestMetadata.getMetadata();
    final uri = Uri.parse(
      '${Constants.oldTetaUrl}auth/users/${requestMetadata.prjId}',
    );

    final res = await http.post(
      uri,
      headers: _getServerRequestHeaders.execute(),
      body: json.encode(
        <String, dynamic>{
          'token': userToken,
        },
      ),
    );
    if (res.statusCode != 200) {
      throw Exception('insertUser resulted in ${res.statusCode} ${res.body}');
    }
    if (res.body != '{"warn":"User already registered"}') {
      try {
        return false;
      } catch (_) {}
    }
    await _persistentLogin(userToken);
    return true;
  }

  /// Retrieve all users
  Future<List<dynamic>> retrieveUsers({
    required final int prjId,
    final int limit = 10,
    final int page = 0,
  }) async {
    final requestMetadata = _serverRequestMetadata.getMetadata();

    final uri = Uri.parse(
      '${Constants.oldTetaUrl}auth/users/$prjId',
    );

    final res = await http.get(
      uri,
      headers: {
        'authorization': 'Bearer ${requestMetadata.token}',
        'page': '$page',
        'page-elems': '$limit',
      },
    );

    Logger.printWarning('retrieveUsers body: ${res.body}');

    if (res.statusCode != 200) {
      throw Exception('retrieveUsers resulted in ${res.statusCode}');
    }

    final list = json.decode(res.body) as List<dynamic>;
    Logger.printMessage('retrieveUsers list: $list');
    final users =
        (list.first as Map<String, dynamic>)['users'] as List<dynamic>;
    Logger.printMessage('retrieveUsers users: $users');

    return users;
  }

  Future<ClearResponse<void, ClearErrorResponse?>> removeUser({
    required final String email,
  }) async {
    final requestMetadata = _serverRequestMetadata.getMetadata();
    final uri = Uri.parse(
      '${Constants.oldTetaUrl}auth/users/${requestMetadata.prjId}/$email',
    );
    final res = await http.delete(
      uri,
      headers: {
        'authorization': 'Bearer ${requestMetadata.token}',
      },
    );
    if (res.statusCode != 200) {
      return ClearResponse(
        data: null,
        error: ClearErrorResponse(
          code: res.statusCode,
          message:
              'removeUser error, code: ${res.statusCode}, error: ${res.body}',
        ),
      );
    }

    return ClearResponse(data: null, error: null);
  }

  /// Returns auth url from specific provider
  Future<String> _signIn({
    required final int prjId,
    required final AuthProvider provider,
    final bool fromEditor = false,
  }) async {
    final requestMetadata = _serverRequestMetadata.getMetadata();
    final param = EnumToString.convertToString(provider);
    final device = UniversalPlatform.isWeb
        ? 'web'
        : fromEditor
            ? 'mobile_redirect_teta'
            : 'mobile';
    final res = await http.post(
      Uri.parse('https://auth.teta.so/auth/$param/$prjId/$device'),
      headers: {
        'authorization': 'Bearer ${requestMetadata.token}',
        'content-type': 'application/json',
      },
    );

    Logger.printMessage(res.body);

    if (res.statusCode != 200) {
      throw Exception('signIn resulted in ${res.statusCode}');
    }

    return res.body;
  }

  /// Performs login in mobile and web platforms
  Future signIn({
    /// Performs a function on success
    required final Function(bool) onSuccess,

    /// The external provider
    final AuthProvider provider = AuthProvider.google,
    final bool? fromEditor,
  }) async {
    final requestMetadata = _serverRequestMetadata.getMetadata();

    final url = await _signIn(
      prjId: requestMetadata.prjId,
      provider: provider,
      fromEditor: fromEditor ?? false,
    );
    await CMSPlatform.login(url, (final userToken) async {
      if (!UniversalPlatform.isWeb) {
        uriLinkStream.listen(
          (final Uri? uri) async {
            if (uri != null) {
              if (uri.queryParameters['access_token'] != null &&
                  uri.queryParameters['access_token'] is String) {
                await closeInAppWebView();
                final isFirstTime = await insertUser(
                  // ignore: cast_nullable_to_non_nullable
                  uri.queryParameters['access_token'] as String,
                );

                onSuccess(isFirstTime);
              }
            }
          },
          onError: (final Object err) {
            throw Exception(r'got err: $err');
          },
        );
      } else {
        Logger.printMessage('Callback on web');
        final isFirstTime = await insertUser(userToken);

        onSuccess(isFirstTime);
      }
    });
  }

  /// Set access_token for persistent login
  Future _persistentLogin(final String token) async {
    final box = await Hive.openBox<dynamic>('Teta Auth');
    await box.put('access_tkn', token);
  }

  /// Sign out in the current device
  Future signOut() async {
    final box = await Hive.openBox<dynamic>('Teta Auth');
    await box.delete('access_tkn');
  }

  /// Make a query with Ayaya
  Future<ClearResponse<dynamic, ClearErrorResponse?>> get(
    final String ayayaQuery,
  ) async {
    final requestMetadata = _serverRequestMetadata.getMetadata();

    final uri = Uri.parse(
      '${Constants.oldTetaUrl}auth/aya',
    );

    final res = await http.post(
      uri,
      headers: {
        'authorization': 'Bearer ${requestMetadata.token}',
        'x-identifier': '${requestMetadata.prjId}',
      },
      body: '''
      ON prj_id* ${requestMetadata.prjId};
      $ayayaQuery
      ''',
    );

    if (res.statusCode != 200) {
      return ClearResponse<List<dynamic>, ClearErrorResponse>(
        data: <dynamic>[],
        error: ClearErrorResponse(
          code: res.statusCode,
          message: res.body,
        ),
      );
    }

    Logger.printWarning(
      "${((json.decode(res.body) as List<dynamic>?)?.first as Map<String, dynamic>?)?['count']}",
    );

    final isCount = ((json.decode(res.body) as List<dynamic>?)?.first
            as Map<String, dynamic>?)?['count'] !=
        null;

    return ClearResponse<dynamic, ClearErrorResponse?>(
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
