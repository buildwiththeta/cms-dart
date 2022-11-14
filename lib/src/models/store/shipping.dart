class Shipping {
  Shipping({
    required this.id,
    required this.name,
    required this.cost,
    required this.description,
  });

  final String id;
  final String name;
  final num cost;
  final String description;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'cost': cost,
      'description': description,
    };
  }
}
