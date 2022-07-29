import 'package:teta_cms/teta_cms.dart';

/// Custom response object
class TetaEmailResponse {
  /// Custom response object
  TetaEmailResponse({
    required this.settings,
    required this.templates,
  });

  /// Get a TetaEmailResponse from json
  TetaEmailResponse.fromJson(final Map<String, dynamic> json)
      : settings = json['settings'] != null
            ? TetaEmailSettings.fromJson(
                json['settings'] as Map<String, dynamic>,
              )
            : null,
        templates = json['templates'] != null
            ? (json['templates'] as List<dynamic>)
                .map(
                  (final dynamic e) =>
                      TetaEmailTemplate.fromJson(e as Map<String, dynamic>),
                )
                .toList()
            : [];

  /// Settings
  final TetaEmailSettings? settings;

  /// Templates
  final List<TetaEmailTemplate> templates;
}
