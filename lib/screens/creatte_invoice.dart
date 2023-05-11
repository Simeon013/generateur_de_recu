import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import 'package:pdf/widgets.dart' as pw;

import '../pdf/pdf_page.dart';


class CreateInvoicePage extends StatefulWidget {
  @override
  _CreateInvoicePageState createState() => _CreateInvoicePageState();
}

class _CreateInvoicePageState extends State<CreateInvoicePage> {
  final _formKey = GlobalKey<FormState>();

  final _locataireController = TextEditingController();
  final _montantController = TextEditingController();
  final _dateController = TextEditingController();

  final GlobalKey<SfSignaturePadState> signatureGlobalKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _locataireController.dispose();
    _montantController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  void _handleClearButtonPressed() {
    signatureGlobalKey.currentState!.clear();
  }

  // Future saving() async {
  //   DialogRoute(
  //     barrierDismissible: false,
  //     context: context,
  //     builder: (BuildContext context) {
  //       return const Center(
  //         child: CircularProgressIndicator(),
  //       );
  //     }
  //   );
  //   final image = await signatureGlobalKey.currentState?.toImage();
  //
  //   final imageSignature = await image!.toByteData(format: ui.ImageByteFormat.png);
  //
  //   final file = await PdfApi.generatePdf(
  //     // order: widget.order,
  //     locataire: _locataireController.text,
  //     montant: _montantController.text,
  //     date: _dateController.text,
  //     signature: imageSignature!,
  //   );
  //
  //   PdfApi.openFile(file!);
  //
  //   // Navigator.of(context).pop();
  //   await OpenFile.open(file.path);
  // }

  @override
  Widget build(BuildContext context) {
    // GlobalKey<SfSignaturePadState> _signaturePadKey = GlobalKey();
    return Scaffold(
      appBar: AppBar(
        title: Text('Créer un recu'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                    controller: _locataireController,
                    decoration: const InputDecoration(labelText: 'Nom du locataire'),
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Veuillez entrer un nom du locataire';
                      }
                      return null;
                    },

                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _montantController,
                  decoration: const InputDecoration(labelText: 'Somme'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Veuillez entrer la somme';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _dateController,
                  decoration: const InputDecoration(labelText: 'Mois'),
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Veuillez entrer le mois';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                // Column(
                //   children: [
                //     Container(
                //       decoration: BoxDecoration(
                //         border: Border.all(color: Colors.grey),
                //       ),
                //       child: SfSignaturePad(
                //         key: signatureGlobalKey,
                //       ),
                //     ),
                //     ElevatedButton(
                //         child: Text("Clear"),
                //         onPressed: () async {
                //           _handleClearButtonPressed();
                //         })
                //   ],
                // ),
                SizedBox(height: 16),
                // ElevatedButton(
                //   child: Text('Ajouter'),
                //   onPressed: () async {
                //     PermissionStatus status = await Permission.storage.request();
                //     if (status == PermissionStatus.granted) {
                //       saving();
                //     }
                //     if (status == PermissionStatus.denied) {
                //       ScaffoldMessenger.of(context).showSnackBar(
                //         const SnackBar(
                //           content: Text('Permission denied'),
                //         )
                //       );
                //     }
                //     if (status == PermissionStatus.permanentlyDenied) {
                //       openAppSettings();
                //     }
                //   },
                // ),
                ElevatedButton(
                  onPressed: onSubmit,
                  child: Text('Ajouter'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
  Future<void> onSubmit() async {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    final image = await signatureGlobalKey.currentState?.toImage();
    final imageSignature = await image?.toByteData(format: ui.ImageByteFormat.png);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PdfPage(locataire: _locataireController.text, montant: _montantController.text, mois: _dateController.text)),
    );
  }

}
