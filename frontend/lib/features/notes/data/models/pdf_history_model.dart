class PdfHistoryModel {
  final String title;
  final String pdfId;
  final String localPathOrUrl;
  final bool isLocal;
  final int lastPage;
  final int totalPages;
  final DateTime lastOpened;

  PdfHistoryModel({
    required this.title,
    required this.isLocal,
    required this.localPathOrUrl,
    required this.pdfId,
    required this.lastPage,
    required this.totalPages,
    required this.lastOpened,
  });

  PdfHistoryModel copyWith({
    String? pdfId,
    int? lastPage,
    int? totalPages,
    bool? isLocal,
    String? localPathOrUrl,
    DateTime? lastOpened,
    String? title,
  }) {
    return PdfHistoryModel(
      title: title ?? this.title,
      lastOpened: lastOpened ?? this.lastOpened,
      lastPage: lastPage ?? this.lastPage,
      isLocal: isLocal ?? this.isLocal,
      localPathOrUrl: localPathOrUrl ?? this.localPathOrUrl,
      pdfId: pdfId ?? this.pdfId,
      totalPages: totalPages ?? this.totalPages,
    );
  }
}
