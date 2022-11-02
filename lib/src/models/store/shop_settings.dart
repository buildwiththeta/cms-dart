class ShopSettings {
  ShopSettings({
    required this.currency,
    required this.livemode,
    required this.merchantCountryCode,
    required this.merchantDisplayName,
  });

  final String currency;
  final bool livemode;
  final String merchantCountryCode;
  final String merchantDisplayName;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'currency': currency,
      };

  static ShopSettings fromSchema(final Map<String, dynamic> json) =>
      ShopSettings(
        currency: json['currency'] as String,
        livemode: json['livemode'] as bool? ?? false,
        merchantCountryCode: json['merchantCountryCode'] as String,
        merchantDisplayName: json['merchantDisplayName'] as String,
      );
}
