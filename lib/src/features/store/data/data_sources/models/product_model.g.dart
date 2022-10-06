// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_TetaProduct _$$_TetaProductFromJson(Map<String, dynamic> json) =>
    _$_TetaProduct(
      id: json['_id'] as String,
      name: json['name'] as String,
      price: json['price'] as num,
      count: json['count'] as num,
      isPublic: json['isPublic'] as bool,
      description: json['description'] as String?,
      image: json['image'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$_TetaProductToJson(_$_TetaProduct instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'price': instance.price,
      'count': instance.count,
      'isPublic': instance.isPublic,
      'description': instance.description,
      'image': instance.image,
      'metadata': instance.metadata,
    };
