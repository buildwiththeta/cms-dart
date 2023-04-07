import 'dart:async';
import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:teta_cms/src/data_stores/local/server_request_metadata_store.dart';
import 'package:teta_cms/teta_cms.dart';

/// User utils
@lazySingleton
class TetaUserUtils {
  /// User utils
  TetaUserUtils(
    this._serverRequestMetadata,
  );

  ///This stores the token and project id headers.
  final ServerRequestMetadataStore _serverRequestMetadata;

  /// Check if users is logged in
  Future<TetaUser> get get async {
    final serverMetadata = _serverRequestMetadata.getMetadata();

    final uri = Uri.parse(
      'https://cms.teta.so:9840/auth/info/${serverMetadata.prjId}',
    );

    final res = await http.get(
      uri,
      headers: {'authorization': 'Bearer ${serverMetadata.token}'},
    );

    TetaCMS.printWarning('insertUser body: ${res.body}');

    if (res.statusCode != 200) {
      TetaCMS.printWarning(
        'insertUser resulted in ${res.statusCode} ${res.body}',
      );
      return TetaUser(
        uid: null,
        name: null,
        email: null,
        provider: null,
        createdAt: null,
      );
    }

    unawaited(
      TetaCMS.instance.analytics.insertEvent(
        TetaAnalyticsType.tetaAuthGetCurrentUser,
        'Teta Auth: get current user request',
        <String, dynamic>{
          'weight': res.bodyBytes.lengthInBytes,
        },
        isUserIdPreferableIfExists: false,
      ),
    );

    final user = TetaUser.fromJson(
      json.decode(res.body) as Map<String, dynamic>? ?? <String, dynamic>{},
    );
    unawaited(
      TetaCMS.instance.analytics.init(userId: user.uid),
    );
    return user;
  }

  /// Check if users is logged in
  Future<bool> hasAccessToken() async {
    final box = await Hive.openBox<dynamic>('Teta Auth');
    return await box.get('access_tkn') != null;
  }

/*Future verifyToken() async {
    try {

      // Verify a token
      final jwt = JWT.verify(token, SecretKey(''));

      print('Payload: ${jwt.payload}');
    } on JWTExpiredError {
      print('jwt expired');
    } on JWTError catch (ex) {
      print(ex.message); // ex: invalid signature
    }
  }*/
}
