import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;

import '../util/category.dart';
import '../util/url_text.dart';

class PdfPage extends StatefulWidget {
  final String locataire;
  final String mois;
  final String montant;

  PdfPage({Key? key, required this.locataire, required this.mois, required this.montant}) : super(key: key);


  @override
  State<PdfPage> createState() => _PdfPageState();
}

class _PdfPageState extends State<PdfPage> {
  PrintingInfo? printingInfo;

  @override
  void initState() {
    super.initState();
    _init();
  }
  Future<void>_init() async{
    final info = await Printing.info();
    setState(() {
      printingInfo = info;
    });
  }

  @override
  Widget build(BuildContext context) {
    pw.RichText.debug = true;
    final actions = <PdfPreviewAction>[
      if (!kIsWeb)
        const PdfPreviewAction(icon: Icon(Icons.save), onPressed: saveAsFile),
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter PDF'),
      ),
      body: PdfPreview(
        maxPageWidth: 700,
        actions: actions,
        onPrinted: showPrintedToast,
        onShared: showSharedToast,
        build: (_) => generate(widget.locataire,widget.mois,widget.montant, PdfPageFormat.a4),
      )
    );
  }
}

Future<Uint8List>generate(
    final String locataire,
    final String mois,
    final String montant,
    final PdfPageFormat format
    ) async{
  final doc = pw.Document(
    title: 'Flutter PDF',
  );
  final logoImage = pw.MemoryImage(
    (await rootBundle.load('assets/vs_code.png')).buffer.asUint8List(),
  );
  final footerImage = pw.MemoryImage(
    (await rootBundle.load('assets/android_studio.png')).buffer.asUint8List(),
  );
  final font = await rootBundle.load('assets/OpenSansRegular.ttf');
  final ttf = pw.Font.ttf(font);

  const paymentTerms = '${15} days';
  final titles = <String>['Invoice Number:', 'Date:'];
  final data = <String>[
    "100",
    DateFormat('dd/MM/yyyy').format(DateTime.now()),
    // paymentTerms,
    // "266",
  ];
  final headers = ['Locataire', 'Loyé de ', 'Montant'];
  final invoices_data = [locataire, mois, montant];


  final pageTheme = await _myPageTheme(format);

  doc.addPage(
      pw.MultiPage(
        header: (context) => pw.Text("INNVOICE ID : 00000",
            style: pw.TextStyle(fontSize: 25, fontWeight: pw.FontWeight.bold)),
        build: (context) => [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.SizedBox(height: 1 * PdfPageFormat.cm),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      // (invoice.from.logo != null)
                      //     ? Image(
                      //   MemoryImage(invoice.from.logo!),
                      //   height: 80,
                      //   width: 80,
                      // )
                      //     : Text(""),
                      pw.Image(
                        alignment: pw.Alignment.topLeft,
                        logoImage,
                        fit: pw.BoxFit.contain,
                        width: 100,
                      ),
                      pw.SizedBox(height: 1 * PdfPageFormat.cm),
                      pw.Text('Flytter PDF',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.SizedBox(height: 1 * PdfPageFormat.mm),
                      // pw.Text('Adresse'),
                    ],
                  ),
                  pw.Container(
                    height: 80,
                    width: 80,
                    child: pw.BarcodeWidget(
                      barcode: pw.Barcode.qrCode(),
                      data: 'invoice.id',
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 1 * PdfPageFormat.cm),
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Adresse',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text('invoice.from.address!'),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: List.generate(titles.length, (index) {
                      final title = titles[index];
                      final value = data[index];

                      return buildText(title: title, value: value, width: 200);
                    }),
                  ),
                ],
              ),
            ],
          ),
          pw.SizedBox(height: 2 * PdfPageFormat.cm),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Invoice details',
                style: pw.TextStyle(fontSize: 18),
              ),
              pw.SizedBox(height: 0.8 * PdfPageFormat.cm),
            ],
          ),
          pw.Table(
            border: pw.TableBorder.all(),
            columnWidths: <int, pw.TableColumnWidth>{
              0: pw.FlexColumnWidth(),
              1: pw.FlexColumnWidth(),
              2: pw.FixedColumnWidth(64),
            },
            defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
            children: <pw.TableRow>[
              pw.TableRow(
                children: List.generate(headers.length, (index) {
                  return pw.Container(
                    color: PdfColors.grey300,
                    padding: pw.EdgeInsets.all(5),
                    alignment: pw.Alignment.centerLeft,
                    child: pw.Text(
                      headers[index],
                    )
                  );
                })
              ),
              pw.TableRow(
                children: List.generate(invoices_data.length, (index) {
                  return pw.Container(
                    padding: pw.EdgeInsets.all(5),
                    alignment: pw.Alignment.center,
                    child: pw.Text(
                      invoices_data[index],
                    )
                  );
                })
              ),
            ],
          ),
          pw.Divider(),
          pw.Container(
            alignment: pw.Alignment.centerRight,
            child: pw.Row(
              children: [
                pw.Spacer(flex: 6),
                pw.Expanded(
                  flex: 4,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      // buildText(
                      //   title: 'Total amount due',
                      //   titleStyle: TextStyle(
                      //     fontSize: 14,
                      //     fontWeight: FontWeight.bold,
                      //   ),
                      //   value: "\$1000",
                      //   unite: true,
                      // ),
                      // pw.SizedBox(height: 2 * PdfPageFormat.mm),
                      // pw.Container(height: 1, color: PdfColors.grey400),
                      // pw.SizedBox(height: 0.5 * PdfPageFormat.mm),
                      // pw.Container(height: 1, color: PdfColors.grey400),
                    ],
                  ),
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 3 * PdfPageFormat.mm),
          pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      "Payment Instructions",
                      style: pw.TextStyle(fontSize: 18),
                    ),
                    pw.Text(
                      'invoice.paymentInstructions',
                    ),
                  ],
                ),
                pw.Align(
                  alignment: pw.Alignment.bottomRight,
                  child: pw.Image(
                    logoImage,
                    height: 80,
                  ),
                )
              ]),
        ],
        footer: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.Divider(),
            pw.SizedBox(height: 8 * PdfPageFormat.mm),
            buildSimpleText(title: 'Addresse', value: 'Cotonou Kowegbo'),
            pw.SizedBox(height: 5 * PdfPageFormat.mm),
            buildSimpleText(
                title: '',
                value:
                "email: aaaa@mail.com / tel: +229 90431956"),
          ],
        ),
      ));
  Uint8List bytes = await doc.save();
  return bytes;
  // return doc.save();
}

buildSimpleText({
  required String title,
  required String value,
}) {
  final style = pw.TextStyle(fontWeight: pw.FontWeight.bold);

  return pw.Row(
    mainAxisSize: pw.MainAxisSize.min,
    crossAxisAlignment: pw.CrossAxisAlignment.end,
    children: [
      pw.Text(title, style: style),
      pw.SizedBox(width: 2 * PdfPageFormat.mm),
      pw.Text(value),
    ],
  );
}

buildText({
  required String title,
  required String value,
  double width = double.infinity,
  TextStyle? titleStyle,
  bool unite = false,
}) {
  final style = titleStyle ?? TextStyle(fontWeight: FontWeight.bold);

  return pw.Container(
    width: width,
    child: pw.Row(
      children: [
        pw.Expanded(child: pw.Text(title)),
        pw.Text(value),
      ],
    ),
  );
}

const imageSignature = 'Signature';

// String bodyText =
//     'Bonjour ${widget.name}, merci d\'avoir choisi Flutter PDF pour générer votre PDF. Nous espérons que cette application vous sera utile pour vos besoins de génération de PDF.';


Future<pw.PageTheme> _myPageTheme(PdfPageFormat format) async {
  final logoImage = pw.MemoryImage(
    (await rootBundle.load('assets/vs_code.png')).buffer.asUint8List(),
  );
  return pw.PageTheme(
      margin: const pw.EdgeInsets.symmetric(
        horizontal: 1*PdfPageFormat.cm,
        vertical: 0.5*PdfPageFormat.cm,
      ),
      textDirection: pw.TextDirection.ltr,
      orientation: pw.PageOrientation.portrait,
      buildBackground: (final context) => pw.FullPage(
          ignoreMargins: true,
          child: pw.Watermark(
              angle: 20,
              child: pw.Opacity(
                  opacity: 0.5,
                  child: pw.Image(
                    alignment: pw.Alignment.center,
                    logoImage,
                    fit: pw.BoxFit.cover,
                  )
              )
          )
      )
  );
}

Future<void> saveAsFile(
    final BuildContext context,
    final LayoutCallback build,
    final PdfPageFormat pageFormat,
    ) async {
  final bytes = await build(pageFormat);
  final appDocDir = await getApplicationDocumentsDirectory();
  final appDocPath = appDocDir.path;
  final file = File('$appDocPath/test.pdf');
  print('Save as file ${file.path}...');
  await file.writeAsBytes(bytes);
  await OpenFile.open(file.path);
}

void showPrintedToast(final BuildContext context){
  ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Printed'),
      )
  );
}

void showSharedToast(final BuildContext context){
  ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Shared'),
      )
  );
}
