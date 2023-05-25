import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:generateur_de_recu/models/invoice.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ReaderPage extends StatefulWidget {
  final String pdfName;
  final Uint8List pdf;
  const ReaderPage({Key? key, required this.pdf, required this.pdfName}) : super(key: key);

  @override
  State<ReaderPage> createState() => _ReaderPageState();
}

class _ReaderPageState extends State<ReaderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.pdfName
        ),
      ),
      body: SfPdfViewer.memory(widget.pdf),
    );
  }
}
