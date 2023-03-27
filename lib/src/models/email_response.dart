import 'package:teta_cms/teta_cms.dart';

/// Custom response object
class EmailResponse {
  /// Custom response object
  EmailResponse({
    required this.settings,
    required this.templates,
  });

  /// Get a TetaEmailResponse from json
  EmailResponse.fromJson(final Map<String, dynamic> json)
      : settings = json['settings'] != null
            ? EmailSettings.fromJson(
                json['settings'] as Map<String, dynamic>,
              )
            : null,
        templates = json['templates'] != null
            ? (json['templates'] as List<dynamic>)
                .map(
                  (final dynamic e) =>
                      EmailTemplate.fromJson(e as Map<String, dynamic>),
                )
                .toList()
            : [];

  /// Settings
  final EmailSettings? settings;

  /// Templates
  final List<EmailTemplate> templates;
}
