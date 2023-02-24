import 'package:equatable/equatable.dart';

class UserAddress extends Equatable {
  const UserAddress({
    required this.email,
    required this.phone,
    required this.city,
    required this.state,
    required this.line,
    required this.postalCode,
    required this.country,
  });

  final String email;
  final String phone;
  final String city;
  final String state;
  final String line;
  final String postalCode;
  final String country;

  static UserAddress fromSchema(final Map<String, dynamic> json) => UserAddress(
        email: json['email'] as String? ?? '',
        phone: json['phone'] as String? ?? '',
        city: json['city'] as String? ?? '',
        state: json['state'] as String? ?? '',
        line: json['line'] as String? ?? '',
        postalCode: json['postalCode'] as String? ?? '',
        country: json['country'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'email': email,
        'phone': phone,
        'city': city,
        'state': state,
        'line': line,
        'postalCode': postalCode,
        'country': country,
      };

  @override
  List<Object?> get props => [
        email,
        phone,
        city,
        state,
        line,
        postalCode,
        country,
      ];
}
