import 'package:freezed_annotation/freezed_annotation.dart';

/// Product model
part 'product_model.g.dart';

part 'product_model.freezed.dart';

@freezed
class TetaProduct with _$TetaProduct {
  factory TetaProduct.fact({
    @JsonKey(name: '_id')
    required final String id,
    required final String name,
    required final num price,
    required final num count,
    required final bool isPublic,
    required final String? description,
    required final String? image,
    required final Map<String, dynamic>? metadata,
  }) = _TetaProduct;

  factory TetaProduct.fromJson(Map<String, dynamic> json) =>
      _$TetaProductFromJson(json);
}
