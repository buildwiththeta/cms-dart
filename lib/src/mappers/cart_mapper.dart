import 'package:injectable/injectable.dart';
import 'package:teta_cms/src/models/store/cart.dart';

///Transforms Api Data to knows object.
@lazySingleton
class CartMapper {
  ///Transforms Api Data to knows object.
  TetaCart mapCart(final Map<String, dynamic> json) => TetaCart(
        id: json['_id'] as String,
        userId: json['user_id'] as String,
        content: json['content'] == null
            ? <TetaCartContent>[]
            : mapCartContentList(
                (json['content'] as List)
                    .map((final dynamic e) => e as Map<String, dynamic>)
                    .toList(growable: true),
              ),
      );
  ///Transforms Api Data to knows object.
  List<TetaCart> mapCarts(final List<Map<String, dynamic>> json) =>
      json.map(mapCart).toList(growable: true);
  ///Transforms Api Data to knows object.
  TetaCartContent mapCartContent(final Map<String, dynamic> json) =>
      TetaCartContent(
        id: json['_id'] as String,
        prodId: json['product_id'] as String,
        addedAt: DateTime.tryParse(json['added_at'] as String),
      );
  ///Transforms Api Data to knows object.
  List<TetaCartContent> mapCartContentList(
    final List<Map<String, dynamic>> json,
  ) =>
      json.map(mapCartContent).toList(growable: true);
}
