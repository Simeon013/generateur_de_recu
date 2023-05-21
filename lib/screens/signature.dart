import 'dart:ui' as ui;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

import '../models/locataire.dart';

class SignaturePage extends StatefulWidget {
  const SignaturePage({Key? key}) : super(key: key);

  @override
  State<SignaturePage> createState() => _SignaturePageState();
}

class _SignaturePageState extends State<SignaturePage> {
  final GlobalKey<SfSignaturePadState> signatureGlobalKey = GlobalKey();

  final _locationBox = Hive.box('location_box');

  void _handleClearButtonPressed() {
    signatureGlobalKey.currentState!.clear();
  }

  Uint8List? signatureBytes;

  void _handleSaveButtonPressed() async {
    final data = await signatureGlobalKey.currentState!.toImage(pixelRatio: 3.0);
    final byteData = await data.toByteData(format: ui.ImageByteFormat.png);
    setState(() {
      signatureBytes = byteData!.buffer.asUint8List();
    });
    _locationBox.put('signature', signatureBytes);
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var sign = _locationBox.get('signature');
    return Scaffold(
      appBar: AppBar(
        title: Text('Signature'),
      ),
      body: sign == null
          ? Image.asset(
        'assets/vs_code.png',
        height: 150,
        fit: BoxFit.cover,
      )
          : Image.memory(sign),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(context, null),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showForm(BuildContext ctx, int? itemKey) async {
    showModalBottomSheet(
      context: ctx,
      elevation: 5,
      isScrollControlled: true,
      builder: (_) => Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom,
          top: 15,
          left: 15,
          right: 15,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
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
                  onPressed: () {
                    _handleClearButtonPressed();
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _handleSaveButtonPressed();
              },
              child: Text('Enregistrer'),
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}
