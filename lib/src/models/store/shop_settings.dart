class ShopSettings {
  ShopSettings({
    required this.currency,
  });

  final String currency;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'currency': currency,
      };
}
