class ShopCredentials {
  ShopCredentials({
    required this.accessToken,
    required this.livemode,
    required this.refreshToken,
    required this.tokenType,
    required this.stripePublishableKey,
    required this.stripeUserId,
    required this.scope,
  });

  final String accessToken;
  final bool livemode;
  final String refreshToken;
  final String tokenType;
  final String stripePublishableKey;
  final String stripeUserId;
  final String scope;

  /// Generate a json from the model
  Map<String, dynamic> toJson() =>
      <String, dynamic>{
        'access_token': accessToken,
        'livemode': livemode,
        'refresh_token': refreshToken,
        'token_type': tokenType,
        'stripe_publishable_key': stripePublishableKey,
        'stripe_user_id': stripeUserId,
        'scope': scope,
      };

  static ShopCredentials fromSchema(Map<String, dynamic> json) =>
      ShopCredentials(
        accessToken: json['access_token'] as String? ?? '',
        livemode: json['livemode'] as bool? ?? false,
        refreshToken: json['refresh_token'] as String? ?? '',
        tokenType: json['token_type'] as String? ?? '',
        stripePublishableKey: json['stripe_publishable_key'] as String? ?? '',
        stripeUserId: json['stripe_user_id'] as String? ?? '',
        scope: json['scope'] as String? ?? '',
      );
}
