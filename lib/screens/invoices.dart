import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:typed_data';

import '../models/invoice.dart';

class InvoicesPage extends StatefulWidget {
  @override
  State<InvoicesPage> createState() => _InvoicesPageState();
}

class _InvoicesPageState extends State<InvoicesPage> {
  List<Map<String, dynamic>> _items = [];

  final _invoiceBox = Hive.box('invoice_box');

  @override
  void initState() {
    super.initState();
    _refreshItems();
  }

  void _refreshItems() {
    final data = _invoiceBox.keys.map((key) {
      final item = _invoiceBox.get(key);

      final invoice = Invoice(name: item['name'] ?? '', pdf: item['pdf']);

      return {
        "key": key,
        "invoice": invoice,
      };
    }).toList();
    setState(() {
      _items = data.reversed.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des invoices'),
      ),
      body: ListView.builder(
        itemCount: _items.length,
        itemBuilder: (_, index) {
          final item = _items[index];
          final invoice = item['invoice'] as Invoice;
          return Card(
            color: Colors.grey,
            margin: const EdgeInsets.all(10),
            elevation: 3,
            child: ListTile(
              title: Text(invoice.name),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () => _openInvoice(invoice),
                    icon: const Icon(Icons.remove_red_eye),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _deleteInvoice(Invoice invoice) {
    Hive.box<Invoice>('invoice_box').delete(invoice.key);
  }

  void _openInvoice(Invoice invoice) async {
    final pdfData = invoice.pdf;

    final pdfBytes = pdfData.buffer.asUint8List();

    final pdfDocument = pw.Document();
    pdfDocument.addPage(
      pw.Page(
        build: (context) {
          return pw.Image(pw.MemoryImage(pdfBytes));
        },
      ),
    );

    // Obtenez le répertoire de cache de l'application
    final appDir = await getTemporaryDirectory();
    final tempPath = '${appDir.path}/test.pdf';

    final File file = File(tempPath);
    // await file.writeAsBytes(pdfDocument.save());

    await Printing.sharePdf(bytes: await file.readAsBytes());
  }
}
