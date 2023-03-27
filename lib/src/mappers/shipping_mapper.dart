import 'package:teta_cms/src/models/store/shipping.dart';

class ShippingMapper {
  Shipping mapShipping(final Map<String, dynamic> json) => Shipping(
        id: json['_id'] as String? ?? '',
        name: json['name'] as String? ?? '',
        cost: json['cost'] as num,
        description: json['description'] as String? ?? '',
      );

  List<Shipping> mapShippings(final List<Map<String, dynamic>> json) =>
      json.map(mapShipping).toList(
            growable: true,
          );
}
