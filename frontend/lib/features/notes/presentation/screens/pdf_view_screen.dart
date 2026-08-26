// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:study_vault/core/widgets/custom_text.dart';
// import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

// class PdfViewScreen extends StatelessWidget {
//   final bool isLocal;
//   final String pathOrUrl;
//   final String? name;

//   const PdfViewScreen({
//     super.key,
//     required this.isLocal,
//     required this.pathOrUrl,
//     this.title,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: CustomText(text: title ?? 'PDF Document')),
//       body: isLocal
//           ? SizedBox.expand(child: _buildLocalPdfViewer(context))
//           : SizedBox.expand(child: _buildNetworkPdfViewer(context)),
//     );
//   }

//   Widget _buildLocalPdfViewer(BuildContext context) {
//     final file = File(pathOrUrl);

//     return SfPdfViewer.file(
//       file,
//       onDocumentLoadFailed: (details) {
//         _showError(context, 'Failed to load PDF: ${details.description}');
//       },
//     );
//   }

//   Widget _buildNetworkPdfViewer(BuildContext context) {
//     return SfPdfViewer.network(
//       pathOrUrl,
//       onDocumentLoadFailed: (details) {
//         _showError(context, 'Failed to load PDF: ${details.description}');
//       },
//     );
//   }

//   void _showError(BuildContext context, String message) {
//     ScaffoldMessenger.of(
//       context,
//     ).showSnackBar(SnackBar(content: CustomText(text: message)));
//   }
// }

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
  late final PdfViewerController _controller;
  bool _isLoaded = false;
  bool _isPopping = false;
  String? _loadError;

  @override
  void initState() {
    super.initState();
    _controller = PdfViewerController();
  }

  @override
  void dispose() {
    // Dispose the controller only after this frame to avoid tearing it
    // down while Syncfusion's internal callbacks are still mid-flight.
    _controller.dispose();
    super.dispose();
  }

  Future<void> _safePop() async {
    if (_isPopping) return;
    _isPopping = true;

    // Let any pending Syncfusion post-frame callbacks
    // (viewport rect calc, scroll updates) flush before we tear
    // down the render tree.
    await SchedulerBinding.instance.endOfFrame;

    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        await _safePop();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? 'PDF'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _safePop,
          ),
        ),
        body: _buildViewer(),
      ),
    );
  }

  Widget _buildViewer() {
    if (_loadError != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            'Failed to load PDF:\n$_loadError',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    // Unique key per document prevents Flutter from trying to diff
    // a .network viewer against a .file viewer (or two different
    // documents) in the same RenderObject slot.
    final key = ValueKey('pdf_${widget.isLocal}_${widget.pathOrUrl}');

    final viewer = widget.isLocal
        ? SfPdfViewer.file(
            File(widget.pathOrUrl),
            key: key,
            controller: _controller,
            onDocumentLoaded: (details) {
              if (mounted) setState(() => _isLoaded = true);
            },
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
            onDocumentLoaded: (details) {
              if (mounted) setState(() => _isLoaded = true);
            },
            onDocumentLoadFailed: (details) {
              if (mounted) {
                setState(() => _loadError = details.description);
              }
            },
          );

    return viewer;
  }
}
