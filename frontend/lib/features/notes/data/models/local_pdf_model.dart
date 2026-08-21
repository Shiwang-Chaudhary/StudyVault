class LocalPdfModel {
  final String id;
  final String title;
  final String localPath;
  final String fileSize;
  final DateTime downloadedAt;

  LocalPdfModel({
    required this.id,
    required this.title,
    required this.localPath,
    required this.fileSize,
    required this.downloadedAt,
  });
}
