import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path_provider_android/path_provider_android.dart';
import 'package:path_provider_ios/path_provider_ios.dart';
import 'package:teta_cms/src/analytics.dart';
import 'package:teta_cms/src/auth.dart';
import 'package:teta_cms/src/data_stores/local/server_request_metadata_store.dart';
import 'package:teta_cms/src/database.dart';
import 'package:teta_cms/src/di/injector.dart';
import 'package:teta_cms/src/httpRequest.dart';
import 'package:teta_cms/src/shop.dart';
import 'package:teta_cms/src/utils.dart';
import 'package:universal_platform/universal_platform.dart';

/// TetaCMS instance.
///
/// It must be initialized before used, otherwise an error is thrown.
///
/// ```dart
/// await TetaCMS.initialize(...)
/// ```
///
/// Use it:
///
/// ```dart
/// final instance = TetaCMS.I;
/// ```
///
class TetaCMS {
  TetaCMS._();

  /// Gets the current TetaCMS instance.
  ///
  /// An [AssertionError] is thrown if supabase isn't initialized yet.
  /// Call [TetaCMS.initialize] to initialize it.
  static TetaCMS get instance {
    assert(
      _instance._initialized,
      'You must initialize the Teta CMS instance before calling TetaCMS.instance',
    );
    return _instance;
  }

  /// Shortcut to get the current TetaCMS instance.
  static TetaCMS get I {
    assert(
      _instance._initialized,
      'You must initialize the Teta CMS instance before calling TetaCMS.instance',
    );
    return _instance;
  }

  /// Returns if the instance is initialized or not
  static bool get isInitialized => _instance._initialized;

  /// Initialize the current TetaCMS instance
  ///
  /// This must be called only once. If called more than once, an
  /// [AssertionError] is thrown
  static Future<TetaCMS> initialize({
    required final int prjId,
    required final String token,
    final bool? debug,
  }) async {
    /*assert(
      !_instance._initialized,
      'This instance is already initialized',
    );*/
    await _instance._init(
      token,
      prjId,
    );
    TetaCMS.log('***** TetaCMS init completed $_instance');
    return _instance;
  }

  static final TetaCMS _instance = TetaCMS._();

  bool _initialized = false;

  /// The TetaCMS client for this instance
  ///
  /// Throws an error if [TetaCMS.initialize] was not called.
  late TetaDatabase db;

  /// The TetaAuth instance
  late TetaAuth auth;

  /// The TetaStore instance
  late TetaShop store;

  /// The TetaStore instance
  late TetaAnalytics analytics;

  /// Utils
  late TetaCMSUtils utils;

  /// Http Request
  late TetaHttpRequest httpRequest;

  /// Dispose the instance to free up resources.
  void dispose() {
    _initialized = false;
  }

  Future<void> _init(
    final String token,
    final int prjId,
  ) async {
    try {
      WidgetsFlutterBinding.ensureInitialized();
      DartPluginRegistrant.ensureInitialized();
    } catch (e) {
      //This can throw unimplemented error on some platforms.
      TetaCMS.log('Info: $e');
    }
    if (UniversalPlatform.isAndroid) {
      PathProviderAndroid.registerWith();
    }

    if (UniversalPlatform.isIOS) {
      PathProviderIOS.registerWith();
    }

    if (!diInitialized) {
      await configureDependencies(const Environment(Environment.prod));
      diInitialized = true;
    }

    getIt
        .get<ServerRequestMetadataStore>()
        .updateMetadata(token: token, prjId: prjId);
    auth = getIt.get<TetaAuth>();
    db = getIt.get<TetaDatabase>();
    store = getIt.get<TetaShop>();
    utils = getIt.get<TetaCMSUtils>();
    httpRequest = getIt.get<TetaHttpRequest>();

    if (!UniversalPlatform.isWeb && !Hive.isBoxOpen('Teta Auth')) {
      Hive.init((await getApplicationDocumentsDirectory()).path);
    }
    _initialized = true;
    analytics = getIt.get<TetaAnalytics>();
  }

  /// Print only in debug mode
  static void log(final String msg) {
    if (kDebugMode) {
      debugPrint(msg);
    }
  }

  /// Print a warning message only in debug mode
  static void printWarning(final String text) => log('\x1B[33m$text\x1B[0m');

  /// Print an error message only in debug mode
  static void printError(final String text) => log('\x1B[31m$text\x1B[0m');
}
