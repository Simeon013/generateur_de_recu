import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:generateur_de_recu/models/locataire.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;

import '../models/invoice.dart';

class PdfPage extends StatefulWidget {
  final Locataire locataire;
  final String mois;

  PdfPage({Key? key, required this.locataire, required this.mois}) : super(key: key);


  @override
  State<PdfPage> createState() => _PdfPageState();
}

class _PdfPageState extends State<PdfPage> {
  PrintingInfo? printingInfo;

  final _signatureBox = Hive.box('signature_box');
  final _invoiceBox = Hive.box('invoice_box');


  @override
  void initState() {
    setState(() {
      id = DateFormat('ddMMyyyyHHmms').format(DateTime.now());
    });
    super.initState();
    _init();
  }
  Future<void>_init() async{
    final info = await Printing.info();
    setState(() {
      printingInfo = info;
    });
  }

  Future<void> createItem(Invoice newItem) async {
    await _invoiceBox.add({
      "name": newItem.name,
      "pdf": newItem.pdf,
    });
  }



  @override
  Widget build(BuildContext context) {
    pw.RichText.debug = true;

    final actions = <PdfPreviewAction>[
      if (!kIsWeb)
        const PdfPreviewAction(icon: Icon(Icons.save), onPressed: saveAsFile),
    ];
    var sign = _signatureBox.get('signature');
    return Scaffold(
      appBar: AppBar(
        title: Text('$name-${widget.mois}'),
      ),
      body: PdfPreview(
        loadingWidget: const Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.picture_as_pdf , size: 100,),
              Text('Génération du fichier'),
              SizedBox(height: 20,),
              CircularProgressIndicator(),
            ],
          ),
        ),
        pdfFileName: 'Reçu-$name-${widget.mois}.pdf',
        maxPageWidth: 700,
        canChangeOrientation: false,
        canChangePageFormat: false,
        canDebug: false,
        actions: actions,
        onPrinted: showPrintedToast,
        onShared: showSharedToast,
        build: (_) => generate(widget.locataire,widget.mois,sign, PdfPageFormat.a4, id),
      )
    );
  }
}

String id = DateFormat('ddMMyyyyHHmms').format(DateTime.now());
String name = '';


Future<Uint8List>generate(
    final Locataire locataire,
    final String mois,
    final Uint8List signature,
    final PdfPageFormat format,
    final String id
    ) async{
  final doc = pw.Document(
    title: 'Recu de location',
  );
  final logoImage = pw.MemoryImage(
    (await rootBundle.load('assets/vs_code.png')).buffer.asUint8List(),
  );
  final footerImage = pw.MemoryImage(
    (await rootBundle.load('assets/android_studio.png')).buffer.asUint8List(),
  );
  final image = pw.MemoryImage(signature.buffer.asUint8List());
  final font = await rootBundle.load('assets/OpenSansRegular.ttf');
  final ttf = pw.Font.ttf(font);

  name = locataire.name;

  const paymentTerms = '${15} days';
  final titles = <String>['Recu id:', 'Date:'];
  final data = <String>[
    id,
    DateFormat('dd/MM/yyyy').format(DateTime.now()),
    // paymentTerms,
    // "266",
  ];
  final headers = ['Nom & Prénom', 'Mofif', 'Montant'];
  final invoices_data = [locataire.name, 'Loyé du mois de $mois', '${locataire.somme} CFA'];


  final pageTheme = await _myPageTheme(format);
  final invoiceBox = Hive.box('invoice_box');

  doc.addPage(
      pw.MultiPage(
        header: (context) => pw.Text("Reçu No: $id",
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
                      pw.Text('Reçu de location',
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
                      data: id,
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
                      pw.Text('Cotonou Kowegbo'),
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
                'Détails',
                style: const pw.TextStyle(fontSize: 18),
              ),
              pw.SizedBox(height: 0.8 * PdfPageFormat.cm),
            ],
          ),
          pw.Table(
            border: pw.TableBorder.all(),
            columnWidths: <int, pw.TableColumnWidth>{
              0: const pw.FlexColumnWidth(),
              1: const pw.FlexColumnWidth(),
              2: const pw.FixedColumnWidth(100),
            },
            defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
            children: <pw.TableRow>[
              pw.TableRow(
                children: List.generate(headers.length, (index) {
                  return pw.Container(
                    color: PdfColors.grey300,
                    padding: const pw.EdgeInsets.all(5),
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
                    padding: const pw.EdgeInsets.all(5),
                    alignment: pw.Alignment.center,
                    child: pw.Text(
                      invoices_data[index],
                    )
                  );
                })
              ),
            ],
          ),
          // pw.Divider(),
          pw.SizedBox(height: 16),
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
                      " ",
                      style: const pw.TextStyle(fontSize: 18),
                    ),
                    pw.Text(
                      ' ',
                    ),
                  ],
                ),
                pw.Align(
                  alignment: pw.Alignment.bottomRight,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text(
                        "Signature",
                      ),
                      pw.Image(
                        image,
                        height: 80,
                      ),
                      pw.Text(
                        "Siméon DAOUDA",
                      ),
                    ]
                  )
                )
              ]),
        ],
        footer: (context) => pw.Align(
          alignment: pw.Alignment.center,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              // pw.Divider(),
              pw.SizedBox(height: 8 * PdfPageFormat.mm),
              buildSimpleText(title: 'Adresse', value: 'Cotonou Kowegbo'),
              pw.SizedBox(height: 5 * PdfPageFormat.mm),
              buildSimpleText(
                  title: '',
                  value:
                  "Email: aaaa@mail.com / tel: +229 90431956"),
            ],
          ),
        )
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
  final style = titleStyle ?? const TextStyle(fontWeight: FontWeight.bold);

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

final Locataire locataire = Locataire(name: '', somme: 0);

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

Future<ScaffoldFeatureController<SnackBar, SnackBarClosedReason>> saveAsFile(
    final BuildContext context,
    final LayoutCallback build,
    final PdfPageFormat pageFormat,
    ) async {
  final bytes = await build(pageFormat);

  final appDocDir = await getApplicationDocumentsDirectory();
  final appDocPath = appDocDir.path;
  final file = File('$appDocPath/$name-$id}.pdf');
  if (kDebugMode) {
    print('Save as file ${file.path}...');
  }
  await file.writeAsBytes(bytes);
  await OpenFile.open(file.path);

  final invoiceBox = Hive.box('invoice_box');

  final newItem = Invoice(
    id: int.parse(id),
    name: name,
    pdf: bytes,
  );

  await invoiceBox.add({
    "id" : newItem.id,
    "name": newItem.name,
    "pdf": newItem.pdf,
  });

  return ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Enregistré avec succes'),
      )
  );

}

void showPrintedToast(final BuildContext context){
  saveAsFile;
  // ScaffoldMessenger.of(context).showSnackBar(
  //     const SnackBar(
  //       content: Text('Printed'),
  //     )
  // );
}

void  showSharedToast(final BuildContext context){
  saveAsFile;
  ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Shared succes'),
      )
  );
}
