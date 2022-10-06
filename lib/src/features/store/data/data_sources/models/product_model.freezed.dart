// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'product_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

TetaProduct _$TetaProductFromJson(Map<String, dynamic> json) {
  return _TetaProduct.fromJson(json);
}

/// @nodoc
mixin _$TetaProduct {
  @JsonKey(name: '_id')
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  num get price => throw _privateConstructorUsedError;
  num get count => throw _privateConstructorUsedError;
  bool get isPublic => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get image => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            @JsonKey(name: '_id') String id,
            String name,
            num price,
            num count,
            bool isPublic,
            String? description,
            String? image,
            Map<String, dynamic>? metadata)
        fact,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(
            @JsonKey(name: '_id') String id,
            String name,
            num price,
            num count,
            bool isPublic,
            String? description,
            String? image,
            Map<String, dynamic>? metadata)?
        fact,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            @JsonKey(name: '_id') String id,
            String name,
            num price,
            num count,
            bool isPublic,
            String? description,
            String? image,
            Map<String, dynamic>? metadata)?
        fact,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_TetaProduct value) fact,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_TetaProduct value)? fact,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_TetaProduct value)? fact,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TetaProductCopyWith<TetaProduct> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TetaProductCopyWith<$Res> {
  factory $TetaProductCopyWith(
          TetaProduct value, $Res Function(TetaProduct) then) =
      _$TetaProductCopyWithImpl<$Res>;
  $Res call(
      {@JsonKey(name: '_id') String id,
      String name,
      num price,
      num count,
      bool isPublic,
      String? description,
      String? image,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class _$TetaProductCopyWithImpl<$Res> implements $TetaProductCopyWith<$Res> {
  _$TetaProductCopyWithImpl(this._value, this._then);

  final TetaProduct _value;
  // ignore: unused_field
  final $Res Function(TetaProduct) _then;

  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? price = freezed,
    Object? count = freezed,
    Object? isPublic = freezed,
    Object? description = freezed,
    Object? image = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      price: price == freezed
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as num,
      count: count == freezed
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as num,
      isPublic: isPublic == freezed
          ? _value.isPublic
          : isPublic // ignore: cast_nullable_to_non_nullable
              as bool,
      description: description == freezed
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      image: image == freezed
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: metadata == freezed
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
abstract class _$$_TetaProductCopyWith<$Res>
    implements $TetaProductCopyWith<$Res> {
  factory _$$_TetaProductCopyWith(
          _$_TetaProduct value, $Res Function(_$_TetaProduct) then) =
      __$$_TetaProductCopyWithImpl<$Res>;
  @override
  $Res call(
      {@JsonKey(name: '_id') String id,
      String name,
      num price,
      num count,
      bool isPublic,
      String? description,
      String? image,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class __$$_TetaProductCopyWithImpl<$Res> extends _$TetaProductCopyWithImpl<$Res>
    implements _$$_TetaProductCopyWith<$Res> {
  __$$_TetaProductCopyWithImpl(
      _$_TetaProduct _value, $Res Function(_$_TetaProduct) _then)
      : super(_value, (v) => _then(v as _$_TetaProduct));

  @override
  _$_TetaProduct get _value => super._value as _$_TetaProduct;

  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? price = freezed,
    Object? count = freezed,
    Object? isPublic = freezed,
    Object? description = freezed,
    Object? image = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_$_TetaProduct(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      price: price == freezed
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as num,
      count: count == freezed
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as num,
      isPublic: isPublic == freezed
          ? _value.isPublic
          : isPublic // ignore: cast_nullable_to_non_nullable
              as bool,
      description: description == freezed
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      image: image == freezed
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: metadata == freezed
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_TetaProduct implements _TetaProduct {
  _$_TetaProduct(
      {@JsonKey(name: '_id') required this.id,
      required this.name,
      required this.price,
      required this.count,
      required this.isPublic,
      required this.description,
      required this.image,
      required final Map<String, dynamic>? metadata})
      : _metadata = metadata;

  factory _$_TetaProduct.fromJson(Map<String, dynamic> json) =>
      _$$_TetaProductFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String id;
  @override
  final String name;
  @override
  final num price;
  @override
  final num count;
  @override
  final bool isPublic;
  @override
  final String? description;
  @override
  final String? image;
  final Map<String, dynamic>? _metadata;
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'TetaProduct.fact(id: $id, name: $name, price: $price, count: $count, isPublic: $isPublic, description: $description, image: $image, metadata: $metadata)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_TetaProduct &&
            const DeepCollectionEquality().equals(other.id, id) &&
            const DeepCollectionEquality().equals(other.name, name) &&
            const DeepCollectionEquality().equals(other.price, price) &&
            const DeepCollectionEquality().equals(other.count, count) &&
            const DeepCollectionEquality().equals(other.isPublic, isPublic) &&
            const DeepCollectionEquality()
                .equals(other.description, description) &&
            const DeepCollectionEquality().equals(other.image, image) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(id),
      const DeepCollectionEquality().hash(name),
      const DeepCollectionEquality().hash(price),
      const DeepCollectionEquality().hash(count),
      const DeepCollectionEquality().hash(isPublic),
      const DeepCollectionEquality().hash(description),
      const DeepCollectionEquality().hash(image),
      const DeepCollectionEquality().hash(_metadata));

  @JsonKey(ignore: true)
  @override
  _$$_TetaProductCopyWith<_$_TetaProduct> get copyWith =>
      __$$_TetaProductCopyWithImpl<_$_TetaProduct>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            @JsonKey(name: '_id') String id,
            String name,
            num price,
            num count,
            bool isPublic,
            String? description,
            String? image,
            Map<String, dynamic>? metadata)
        fact,
  }) {
    return fact(id, name, price, count, isPublic, description, image, metadata);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(
            @JsonKey(name: '_id') String id,
            String name,
            num price,
            num count,
            bool isPublic,
            String? description,
            String? image,
            Map<String, dynamic>? metadata)?
        fact,
  }) {
    return fact?.call(
        id, name, price, count, isPublic, description, image, metadata);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            @JsonKey(name: '_id') String id,
            String name,
            num price,
            num count,
            bool isPublic,
            String? description,
            String? image,
            Map<String, dynamic>? metadata)?
        fact,
    required TResult orElse(),
  }) {
    if (fact != null) {
      return fact(
          id, name, price, count, isPublic, description, image, metadata);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_TetaProduct value) fact,
  }) {
    return fact(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_TetaProduct value)? fact,
  }) {
    return fact?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_TetaProduct value)? fact,
    required TResult orElse(),
  }) {
    if (fact != null) {
      return fact(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$_TetaProductToJson(
      this,
    );
  }
}

abstract class _TetaProduct implements TetaProduct {
  factory _TetaProduct(
      {@JsonKey(name: '_id') required final String id,
      required final String name,
      required final num price,
      required final num count,
      required final bool isPublic,
      required final String? description,
      required final String? image,
      required final Map<String, dynamic>? metadata}) = _$_TetaProduct;

  factory _TetaProduct.fromJson(Map<String, dynamic> json) =
      _$_TetaProduct.fromJson;

  @override
  @JsonKey(name: '_id')
  String get id;
  @override
  String get name;
  @override
  num get price;
  @override
  num get count;
  @override
  bool get isPublic;
  @override
  String? get description;
  @override
  String? get image;
  @override
  Map<String, dynamic>? get metadata;
  @override
  @JsonKey(ignore: true)
  _$$_TetaProductCopyWith<_$_TetaProduct> get copyWith =>
      throw _privateConstructorUsedError;
}
