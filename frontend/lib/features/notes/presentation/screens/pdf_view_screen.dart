import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewScreen extends StatefulWidget {
  final String pathOrUrl;
  final bool isLocal;
  final String? title;

  const PdfViewScreen({
    super.key,
    required this.pathOrUrl,
    required this.isLocal,
    this.title,
  });

  @override
  State<PdfViewScreen> createState() => _PdfViewScreenState();
}

class _PdfViewScreenState extends State<PdfViewScreen> {
  final _controller = PdfViewerController();
  String? _loadError;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _safePop() async {
    await SchedulerBinding.instance.endOfFrame;
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final key = ValueKey('pdf_${widget.isLocal}_${widget.pathOrUrl}');

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
                key: key,
                controller: _controller,
                onDocumentLoadFailed: (details) {
                  if (mounted) {
                    setState(() => _loadError = details.description);
                  }
                },
              )
            : SfPdfViewer.network(
                widget.pathOrUrl,
                key: key,
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
