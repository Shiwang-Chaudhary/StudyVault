import 'package:flutter/material.dart';
import 'package:study_vault/core/widgets/custom_text.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewScreen extends StatelessWidget {
  final String name;
  final String url;
  const PdfViewScreen({super.key, required this.name, required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: CustomText(text: name)),
      body: SfPdfViewer.network(
        url,
        onDocumentLoadFailed: (details) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Center(
                child: CustomText(
                  text: "Failed to load PDF: ${details.description}",
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
