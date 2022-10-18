import 'package:teta_cms/src/models/store/credentials.dart';

class CredentialsMapper {
  ShopCredentials mapCredentials(Map<String, dynamic> json) {
    return ShopCredentials(
      accessToken: json['access_token'] as String,
      livemode: json['livemode'] as String,
      refreshToken: json['refresh_token'] as String,
      tokenType: json['token_type'] as String,
      stripePublishableKey: json['stripe_publishable_key'] as String,
      stripeUserId: json['stripe_user_id'] as String,
      scope: json['scope'] as String,
    );
  }
}
