import 'package:injectable/injectable.dart';
import 'package:teta_cms/src/models/store/shop_settings.dart';

@lazySingleton
class ShopSettingsMapper {
  ShopSettings mapSettings(final Map<String, dynamic> json) => ShopSettings(
        currency: json['currency'] as String,
        livemode: json['livemode'] as bool? ?? false,
        merchantCountryCode: json['merchantCountryCode'] as String,
        merchantDisplayName: json['merchantDisplayName'] as String,
      );
}
