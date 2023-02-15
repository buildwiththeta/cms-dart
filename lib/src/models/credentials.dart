// ignore_for_file: non_constant_identifier_names

/// Model to save a project oauth providers credentials
class TetaAuthCredentials {
  /// Model to save a project oauth providers credentials
  TetaAuthCredentials({
    this.g_client_id,
    this.g_client_secret,
    this.gh_client_id,
    this.gh_client_secret,
    this.t_client_id,
    this.t_client_secret,
    this.a_client_id,
    this.a_client_secret,
    this.f_client_id,
    this.f_client_secret,
    this.tw_client_id,
    this.tw_client_secret,
    this.l_client_id,
    this.l_client_secret,
    this.d_client_id,
    this.d_client_secret,
    this.gl_client_id,
    this.gl_client_secret,
    this.bb_client_id,
    this.bb_client_secret,
  });

  /// Generate a TetaAuthCredentials from a json
  TetaAuthCredentials.fromJson(final Map<String, dynamic> json)
      : g_client_id = json['g_client_id'] as String?,
        g_client_secret = json['g_client_secret'] as String?,
        gh_client_id = json['gh_client_id'] as String?,
        gh_client_secret = json['gh_client_secret'] as String?,
        t_client_id = json['t_client_id'] as String?,
        t_client_secret = json['t_client_secret'] as String?,
        a_client_id = json['a_client_id'] as String?,
        a_client_secret = json['a_client_secret'] as String?,
        f_client_id = json['f_client_id'] as String?,
        f_client_secret = json['f_client_secret'] as String?,
        tw_client_id = json['tw_client_id'] as String?,
        tw_client_secret = json['tw_client_secret'] as String?,
        l_client_id = json['l_client_id'] as String?,
        l_client_secret = json['l_client_secret'] as String?,
        d_client_id = json['d_client_id'] as String?,
        d_client_secret = json['d_client_secret'] as String?,
        gl_client_id = json['gl_client_id'] as String?,
        gl_client_secret = json['gl_client_secret'] as String?,
        bb_client_id = json['bb_client_id'] as String?,
        bb_client_secret = json['bb_client_secret'] as String?;

  /// Google id
  final String? g_client_id;

  /// Google secret
  final String? g_client_secret;

  /// GitHub id
  final String? gh_client_id;

  /// GitHub secret
  final String? gh_client_secret;

  /// Twitter id
  final String? t_client_id;

  /// Twitter secret
  final String? t_client_secret;

  /// Appl id
  final String? a_client_id;

  /// Apple secret
  final String? a_client_secret;

  /// Facebook id
  final String? f_client_id;

  /// Facebook secret
  final String? f_client_secret;

  /// Twitch id
  final String? tw_client_id;

  /// Twitch secret
  final String? tw_client_secret;

  /// Linkedin id
  final String? l_client_id;

  /// Linkedin secret
  final String? l_client_secret;

  /// Discord id
  final String? d_client_id;

  /// Discord secret
  final String? d_client_secret;

  /// Gitlab id
  final String? gl_client_id;

  /// Gitlab secret
  final String? gl_client_secret;

  /// BitBucket id
  final String? bb_client_id;

  /// BitBucket secret
  final String? bb_client_secret;

  /// Generates a json from current instance
  Map<String, dynamic> toJson() => <String, dynamic>{
        'g_client_id': g_client_id,
        'g_client_secret': g_client_secret,
        'gh_client_id': gh_client_id,
        'gh_client_secret': gh_client_secret,
        't_client_id': t_client_id,
        't_client_secret': t_client_secret,
        'a_client_id': a_client_id,
        'a_client_secret': a_client_secret,
        'f_client_id': f_client_id,
        'f_client_secret': f_client_secret,
        'tw_client_id': tw_client_id,
        'tw_client_secret': tw_client_secret,
        'l_client_id': l_client_id,
        'l_client_secret': l_client_secret,
        'd_client_id': d_client_id,
        'd_client_secret': d_client_secret,
        'gl_client_id': gl_client_id,
        'gl_client_secret': gl_client_secret,
        'bb_client_id': bb_client_id,
        'bb_client_secret': bb_client_secret,
      };
  @override
  String toString() =>
      'TetaAuthCredentials { g_client_id: $g_client_id, g_client_secret: $g_client_secret }';
}
