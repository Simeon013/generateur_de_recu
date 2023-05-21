import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import 'package:pdf/widgets.dart' as pw;

import '../models/locataire.dart';
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

  Locataire selectedLocataire = Locataire(name: '', somme: 0);

  final GlobalKey<SfSignaturePadState> signatureGlobalKey = GlobalKey();

  List<Map<String, dynamic>> _items = [];

  final _locationBox = Hive.box('location_box');

  @override
  void initState() {
    super.initState();
    _refreshItems();
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

  void _refreshItems() {
    final data = _locationBox.keys.map((key) {
      final item = _locationBox.get(key);

      final locataire = Locataire(name: item['name'], somme: item['somme']);

      return {
        "key": key,
        "locataire": locataire,
      };
    }).toList();
    setState(() {
      _items = data.reversed.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    // GlobalKey<SfSignaturePadState> _signaturePadKey = GlobalKey();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Créer un recu'),
      ),
      body: Builder(
        builder: (BuildContext context) {
          return SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DropdownButtonFormField<Locataire>(
                      // value: selectedLocataire,
                      onChanged: (Locataire? newValue) {
                        setState(() {
                          selectedLocataire = newValue!;
                          print(selectedLocataire.name);
                        });
                      },
                      decoration: const InputDecoration(labelText: 'Sélectionnez un locataire'),
                      items: _items.map((item) {
                        final locataire = item['locataire'] as Locataire;
                        return DropdownMenuItem<Locataire>(
                          value: locataire,
                          child: Text(locataire.name),
                          // child: Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   children: [
                          //     Text(locataire.name),
                          //     Text(locataire.somme.toString() + 'F'),
                          //   ],
                          // ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 16),
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
                    // InputDatePickerFormField(
                    //   firstDate: DateTime.now(), lastDate: DateTime.now().add(Duration(days: 365)),
                    // ),
                    const SizedBox(height: 16),
                    Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                          ),
                          child: SfSignaturePad(
                            key: signatureGlobalKey,
                          ),
                        ),
                        ElevatedButton(
                          child: Text("Clear"),
                          onPressed: () async {
                            _handleClearButtonPressed();
                          }
                        )
                      ],
                    ),
                    const SizedBox(height: 16),
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
          );
        }
      ),
    );
  }

  Future<void> onSubmit() async {
    final image = await signatureGlobalKey.currentState?.toImage();
    final imageSignature = await image?.toByteData(format: ui.ImageByteFormat.png);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PdfPage(locataire: selectedLocataire, mois: _dateController.text, signature: imageSignature!)),
    );
  }

}
