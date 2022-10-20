import 'package:teta_cms/src/models/store/shop_settings.dart';

class ShopSettingsMapper {
  ShopSettings mapSettings(final Map<String, dynamic> json) => ShopSettings(
        currency: json['currency'] as String? ?? '',
      );
}