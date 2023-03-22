class TetaStorageFile {
  const TetaStorageFile({
    required this.id,
    required this.name,
    required this.prjId,
    required this.ext,
    required this.size,
    required this.createdAt,
    required this.zipped,
    required this.sha,
    this.slug,
  });

  final String id;
  final String name;
  final int prjId;
  final String ext;
  final String size;
  final String createdAt;
  final bool zipped;
  final String sha;
  final String? slug;

  factory TetaStorageFile.fromJson(Map<String, dynamic> json) {
    return TetaStorageFile(
      id: json['id'],
      name: json['name'],
      prjId: json['prjId'],
      ext: json['ext'],
      size: json['size'],
      createdAt: json['createdAt'],
      zipped: json['zipped'],
      sha: json['sha'],
      slug: json['slug'],
    );
  }
}
