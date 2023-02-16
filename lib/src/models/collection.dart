import 'package:enum_to_string/enum_to_string.dart';
import 'package:equatable/equatable.dart';
import 'package:teta_cms/src/constants.dart';

/// Schema of the collection, can be public or private
enum CollectionSchema {
  /// Users will see this in Teta dashboard
  public,

  /// Users won't see this in Teta dashboard
  private,
}

/// Collection role, useful to identify a certain scope
enum CollectionRole {
  /// Generic role
  nil,

  /// Used for custom queries
  query,

  /// Used for Api calls
  request
}

class CollectionObject extends Equatable {
  const CollectionObject({
    required this.name,
    required this.prjId,
    this.id = '0',
    this.schema = CollectionSchema.public,
    this.role = CollectionRole.nil,
    this.keys = const <String>[],
  });

  CollectionObject.fromJson({
    required final Map<String, dynamic> json,
  })  : id = json[Constants.docId] as String,
        name = json['name'] as String,
        prjId = json[Constants.prjIdKey] as int,
        schema = EnumToString.fromString(
              CollectionSchema.values,
              json['schema'] as String? ?? 'public',
            ) ??
            CollectionSchema.public,
        role = EnumToString.fromString(
              CollectionRole.values,
              json['role'] as String? ?? 'nil',
            ) ??
            CollectionRole.nil,
        keys = json['keys'] != null
            ? List<String>.from(json['keys'] as List<dynamic>)
            : const <String>[];

  final String id;
  final String name;
  final int prjId;
  final CollectionSchema schema;
  final CollectionRole? role;
  final List<String>? keys;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        Constants.prjIdKey: prjId,
        'security': 'prj_id',
        'schema': EnumToString.convertToString(schema),
        'role': EnumToString.convertToString(role),
        'keys': keys,
      };

  CollectionObject copyWith({
    final String? id,
    final String? name,
    final int? prjId,
    final CollectionSchema? schema,
    final CollectionRole? role,
    final List<String>? keys,
  }) =>
      CollectionObject(
        id: id ?? this.id,
        name: name ?? this.name,
        prjId: prjId ?? this.prjId,
        schema: schema ?? this.schema,
        role: role ?? this.role,
        keys: keys ?? this.keys,
      );

  @override
  List<Object?> get props => [
        id,
        name,
        prjId,
        schema,
        role,
        keys,
      ];

  @override
  String toString() =>
      'Collection { id: $id, name: $name, prjId: $prjId, keys: $keys }';
}
