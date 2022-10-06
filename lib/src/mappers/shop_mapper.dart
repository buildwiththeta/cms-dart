import 'package:injectable/injectable.dart';
import 'package:teta_cms/src/mappers/cart_mapper.dart';
import 'package:teta_cms/src/mappers/product_mapper.dart';
import 'package:teta_cms/src/models/store/cart.dart';
import 'package:teta_cms/src/features/store/data/data_sources/models/product_model.dart';
import 'package:teta_cms/src/models/store/shop.dart';
///Transforms Api Data to knows object.
@lazySingleton
class ShopMapper {
  ///Transforms Api Data to knows object.
  ShopMapper(this.productMapper, this.cartMapper);

  ///Transforms Api Data to knows object.
  final ProductMapper productMapper;
  ///Transforms Api Data to knows object.
  final CartMapper cartMapper;
  ///Transforms Api Data to knows object.
  TetaShop mapShop(final Map<String, dynamic> json) => TetaShop(
        id: json['id'] as String,
        currency: json['currency'] as String,
        products: json['products'] == null
            ? <TetaProduct>[]
            : productMapper.mapProducts(
                json['products'] as List<Map<String, dynamic>>,
              ),
        carts: json['carts'] == null
            ? <TetaCart>[]
            : cartMapper.mapCarts(
                json['carts'] as List<Map<String, dynamic>>,
              ),
      );
  ///Transforms Api Data to knows object.
  List<TetaShop> mapShops(final List<Map<String, dynamic>> json) =>
      json.map(mapShop).toList(
            growable: true,
          );
}
