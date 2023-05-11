import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:generateur_de_recu/util/url_text.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import 'category.dart';

Future<Uint8List>generatePdf(final PdfPageFormat format) async{
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

  final pageTheme = await _myPageTheme(format);

  doc.addPage(
    pw.MultiPage(
      pageTheme: pageTheme,
      header: (final context) => pw.Image(
        alignment: pw.Alignment.topLeft,
        logoImage,
        fit: pw.BoxFit.contain,
        width: 100,
      ),
      // footer: (final context) => pw.Image(
      //   footerImage,
      //   fit: pw.BoxFit.scaleDown,
      // ),
      build: (final context) => [
        pw.Container(
          padding: const pw.EdgeInsets.only(
            left: 30,
            bottom: 20,
          ),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            mainAxisAlignment: pw.MainAxisAlignment.start,
            children: [
              pw.Padding(
                padding: const pw.EdgeInsets.only(
                  top: 20,
                )
              ),
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text(
                        'Phone : ',
                      ),
                      pw.Text(
                        'Email : ',
                      )
                    ]
                  ),
                  pw.SizedBox(width: 70),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        '+229 90431956',
                      ),
                      UrlText(
                        'karlsnow000@gmail.com',
                        'karlsnow000@gmail.com'
                      ),
                    ]
                  ),
                  pw.SizedBox(width: 70),
                  pw.BarcodeWidget(
                      data: 'Flutter PDF',
                      width: 40,
                      height: 40,
                      barcode: pw.Barcode.qrCode(),
                      drawText: false
                  ),
                  pw.Padding(padding: pw.EdgeInsets.zero),
                ]
              )
            ]
          )
        ),
        pw.Center(
          child: pw.Text(
            'In the name of God',
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(
              font: ttf,
              fontSize: 30,
              fontWeight: pw.FontWeight.bold
            )
          )
        ),
        pw.Align(
          alignment: pw.Alignment.centerLeft,
          child: myCategory(
            'Flutter PDF',
            ttf
          )
        ),
        pw.Paragraph(
          margin: const pw.EdgeInsets.only(top: 10),
          text: bodyText,
          style: pw.TextStyle(
            font: ttf,
            lineSpacing: 8,
            fontSize: 16,

          )
        )
      ]
    )
  );
  return doc.save();
}

const String bodyText =
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Purus gravida quis blandit turpis cursus in hac habitasse platea. Sed cras ornare arcu dui vivamus arcu felis bibendum ut. Placerat vestibulum lectus mauris ultrices. Commodo nulla facilisi nullam vehicula ipsum a arcu cursus. Enim sit amet venenatis urna cursus eget nunc scelerisque. Nisi scelerisque eu ultrices vitae auctor eu. Tincidunt arcu non sodales neque sodales ut etiam sit amet. Diam maecenas ultricies mi eget. Nibh cras pulvinar mattis nunc sed. Quis commodo odio aenean sed adipiscing. Elementum integer enim neque volutpat ac tincidunt vitae semper.'
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Purus gravida quis blandit turpis cursus in hac habitasse platea. Sed cras ornare arcu dui vivamus arcu felis bibendum ut. Placerat vestibulum lectus mauris ultrices. Commodo nulla facilisi nullam vehicula ipsum a arcu cursus. Enim sit amet venenatis urna cursus eget nunc scelerisque. Nisi scelerisque eu ultrices vitae auctor eu. Tincidunt arcu non sodales neque sodales ut etiam sit amet. Diam maecenas ultricies mi eget. Nibh cras pulvinar mattis nunc sed. Quis commodo odio aenean sed adipiscing. Elementum integer enim neque volutpat ac tincidunt vitae semper.'
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Purus gravida quis blandit turpis cursus in hac habitasse platea. Sed cras ornare arcu dui vivamus arcu felis bibendum ut. Placerat vestibulum lectus mauris ultrices. Commodo nulla facilisi nullam vehicula ipsum a arcu cursus. Enim sit amet venenatis urna cursus eget nunc scelerisque. Nisi scelerisque eu ultrices vitae auctor eu. Tincidunt arcu non sodales neque sodales ut etiam sit amet. Diam maecenas ultricies mi eget. Nibh cras pulvinar mattis nunc sed. Quis commodo odio aenean sed adipiscing. Elementum integer enim neque volutpat ac tincidunt vitae semper.'
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Purus gravida quis blandit turpis cursus in hac habitasse platea. Sed cras ornare arcu dui vivamus arcu felis bibendum ut. Placerat vestibulum lectus mauris ultrices. Commodo nulla facilisi nullam vehicula ipsum a arcu cursus. Enim sit amet venenatis urna cursus eget nunc scelerisque. Nisi scelerisque eu ultrices vitae auctor eu. Tincidunt arcu non sodales neque sodales ut etiam sit amet. Diam maecenas ultricies mi eget. Nibh cras pulvinar mattis nunc sed. Quis commodo odio aenean sed adipiscing. Elementum integer enim neque volutpat ac tincidunt vitae semper.'
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Purus gravida quis blandit turpis cursus in hac habitasse platea. Sed cras ornare arcu dui vivamus arcu felis bibendum ut. Placerat vestibulum lectus mauris ultrices. Commodo nulla facilisi nullam vehicula ipsum a arcu cursus. Enim sit amet venenatis urna cursus eget nunc scelerisque. Nisi scelerisque eu ultrices vitae auctor eu. Tincidunt arcu non sodales neque sodales ut etiam sit amet. Diam maecenas ultricies mi eget. Nibh cras pulvinar mattis nunc sed. Quis commodo odio aenean sed adipiscing. Elementum integer enim neque volutpat ac tincidunt vitae semper.'
;

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

