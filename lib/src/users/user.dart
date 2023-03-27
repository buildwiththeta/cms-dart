import 'dart:async';
import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:light_logger/light_logger.dart';
import 'package:teta_cms/src/data_stores/local/server_request_metadata_store.dart';
import 'package:teta_cms/teta_cms.dart';

/// User utils
class UserUtils {
  /// User utils
  UserUtils(
    this._serverRequestMetadata,
  );

  ///This stores the token and project id headers.
  final ServerRequestMetadataStore _serverRequestMetadata;

  /// Check if users is logged in
  Future<User> get get async {
    final serverMetadata = _serverRequestMetadata.getMetadata();

    final box = await Hive.openBox<dynamic>('Teta Auth');
    final accessToken = await box.get('access_tkn') as String?;
    if (accessToken != null) {
      final uri = Uri.parse(
        'https://cms.teta.so:9840/auth/info/${serverMetadata.prjId}',
      );

      final res = await http.get(
        uri,
        headers: {
          'authorization': 'Bearer $accessToken',
        },
      );

      Logger.printWarning('insertUser body: ${res.body}');

      if (res.statusCode != 200) {
        Logger.printWarning(
          'insertUser resulted in ${res.statusCode} ${res.body}',
        );
        return User(
          uid: null,
          name: null,
          email: null,
          provider: null,
          createdAt: null,
        );
      }

      final user = User.fromJson(
        json.decode(res.body) as Map<String, dynamic>? ?? <String, dynamic>{},
      );
      return user;
    }
    return User(
      uid: null,
      name: null,
      email: null,
      provider: null,
      createdAt: null,
    );
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
