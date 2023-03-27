class EmailSettings {
  EmailSettings({
    required this.username,
    required this.password,
    required this.host,
    required this.port,
    required this.secure,
  });

  EmailSettings.fromJson(final Map<String, dynamic> json)
      : username = json['username'] as String?,
        password = json['password'] as String?,
        host = json['host'] as String?,
        port = json['port'] as int?,
        secure = json['secure'] as bool? ?? false;

  String? username;
  String? password;
  String? host;
  int? port;
  bool secure;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'username': username,
        'password': password,
        'host': host,
        'port': port,
        'secure': secure,
      };
}
