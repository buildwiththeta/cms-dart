/// Global constant for all the package
class Constants {
  /// Key to detect docs id
  static const String docId = '_id';

  /// Key to detect prj id
  static const String prjIdKey = 'prj_id';

  static const String _host = 'cms.teta.so';
  static const String _port = '9010';

  /// Standard Teta url
  static const String tetaUrl = 'https://$_host:$_port/';

  /// Standard email url
  static const String emailUrl = 'https://$_host:5001/';

  /// Default Http headers
  static const Map<String, String> defaultHeaders = <String, String>{
    'Content-Type': 'application/json',
  };

  /// Store url for shop
  static const String shopBaseUrl = 'https://cms.teta.so:9000';

  /// Analytics url
  static const String analyticsUrl = 'https://backdata.teta.so:8002/';

  /// Reverse proxy url
  static const String reverseProxyUrl = 'https://cms.teta.so:9720/proxy';
}
