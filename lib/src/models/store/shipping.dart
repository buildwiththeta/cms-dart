import 'package:equatable/equatable.dart';

class Shipping extends Equatable {
  const Shipping({
    required this.id,
    required this.name,
    required this.cost,
    required this.description,
  });

  final String id;
  final String name;
  final num cost;
  final String description;

  static Shipping fromSchema(final Map<String, dynamic> json) => Shipping(
        id: json['_id'] as String? ?? '',
        name: json['name'] as String? ?? '',
        cost: json['cost'] as num? ?? 0,
        description: json['description'] as String? ?? '',
      );

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      '_id': id,
      'name': name,
      'cost': cost,
      'description': description,
    };
  }

  @override
  List<Object?> get props => [
        id,
        name,
        cost,
        description,
      ];
}
