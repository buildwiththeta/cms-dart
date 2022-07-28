class TetaEmailTemplate {
  TetaEmailTemplate({
    required this.id,
    required this.name,
    required this.subject,
    required this.html,
    required this.text,
  });

  TetaEmailTemplate.fromJson(final Map<String, dynamic> json)
      : id = json['_id'] as String?,
        name = json['name'] as String?,
        subject = json['subject'] as String?,
        html = json['html'] as String?,
        text = json['text'] as String?;

  String? id;
  String? name;
  String? subject;
  String? html;
  String? text;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        'subject': subject,
        'html': html,
        'text': text,
      };
}
