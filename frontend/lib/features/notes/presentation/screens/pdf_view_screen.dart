import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:study_vault/features/notes/data/models/pdf_history_model.dart';
import 'package:study_vault/features/notes/data/pdf_history_data_source.dart';
import 'package:study_vault/features/notes/providers/current_user_id_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewScreen extends ConsumerStatefulWidget {
  final String pdfId;
  final String pathOrUrl;
  final bool isLocal;
  final String? title;

  const PdfViewScreen({
    super.key,
    required this.pdfId,
    required this.pathOrUrl,
    required this.isLocal,
    this.title,
  });

  @override
  ConsumerState<PdfViewScreen> createState() => _PdfViewScreenState();
}

class _PdfViewScreenState extends ConsumerState<PdfViewScreen> {
  final _controller = PdfViewerController();
  String? _loadError;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> saveHistory() async {
    final userId = ref.read(currentUserIdProvider);
    final pdfHistory = PdfHistoryModel(
      title: widget.title ?? 'PDF',
      userId: userId,
      pdfId: widget.pdfId,
      localPathOrUrl: widget.pathOrUrl,
      isLocal: widget.isLocal,
      lastPage: _controller.pageNumber,
      totalPages: _controller.pageCount,
      lastOpened: DateTime.now(),
    );

    await ref
        .read(pdfHistoryDataSourceProvider)
        .savePdfHistory(pdfHistory, userId);
  }

  //Since flutter was not able to pop the screen when the pdf is loading,
  //I had to create a safe pop function that waits for the end of the frame before popping the screen.
  Future<void> _safePop() async {
    await saveHistory();
    ref.invalidate(pdfHistoryDataSourceProvider);
    await SchedulerBinding.instance.endOfFrame;
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final userId = ref.watch(currentUserIdProvider);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (!didPop) await _safePop();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? 'PDF'),
          leading: BackButton(onPressed: _safePop),
        ),
        body: _loadError != null
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    'Failed to load PDF:\n$_loadError',
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            : widget.isLocal
            ? SfPdfViewer.file(
                File(widget.pathOrUrl),
                onDocumentLoaded: (details) async {
                  final history = ref
                      .read(pdfHistoryDataSourceProvider)
                      .getPdfHistory(widget.pdfId, userId);
                  log(
                    "Loaded PDF: ${widget.pdfId}, last page: ${history?.lastPage}",
                  );
                  if (history != null) {
                    _controller.jumpToPage(
                      history.lastPage > 1 ? history.lastPage : 1,
                    );
                  }
                },
                controller: _controller,
                onDocumentLoadFailed: (details) {
                  if (mounted) {
                    setState(() => _loadError = details.description);
                  }
                },
              )
            : SfPdfViewer.network(
                widget.pathOrUrl,
                onDocumentLoaded: (details) async {
                  final history = ref
                      .read(pdfHistoryDataSourceProvider)
                      .getPdfHistory(widget.pdfId, userId);
                  log(
                    "Loaded PDF: ${widget.pdfId}, last page: ${history?.lastPage}",
                  );
                  if (history != null) {
                    _controller.jumpToPage(history.lastPage);
                  }
                },
                controller: _controller,
                onDocumentLoadFailed: (details) {
                  if (mounted) {
                    setState(() => _loadError = details.description);
                  }
                },
              ),
      ),
    );
  }
}
