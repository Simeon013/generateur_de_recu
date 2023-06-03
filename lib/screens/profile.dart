import 'dart:ui' as ui;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

import '../models/profile.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _telController = TextEditingController();
  final TextEditingController _adresseController = TextEditingController();
  final GlobalKey<SfSignaturePadState> signatureGlobalKey = GlobalKey();

  final _profileBox = Hive.box('profile_box');

  @override
  void initState() {
    super.initState();

    if (_profileBox.isNotEmpty) {
      _nameController.text = _profileBox.get('name');
      _emailController.text = _profileBox.get('email');
      _telController.text = _profileBox.get('tel').toString();
      _adresseController.text = _profileBox.get('adresse');
    }
  }


  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _telController.dispose();
    _adresseController.dispose();
    super.dispose();
  }

  //Update item
  Future<void> _update(Profile item) async {
    await _profileBox.put('name', item.name);
    await _profileBox.put('email', item.email);
    await _profileBox.put('tel', item.tel);
    await _profileBox.put('adresse', item.adress);
  }


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
    _profileBox.put('signature', signatureBytes);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    var sign = _profileBox.get('signature');

      // _nameController.text = _profileBox.get('name');
      // _emailController.text = _profileBox.get('email');
      // _telController.text = _profileBox.get('tel').toString();
      // _adresseController.text = _profileBox.get('adresse');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              // Center(
              //   child: Stack(
              //     children: [
              //       Container(
              //         width: 130,
              //         height: 130,
              //         decoration: BoxDecoration(
              //           border: Border.all(
              //             width: 4,
              //             color: Colors.white,
              //           ),
              //           boxShadow: [
              //             BoxShadow(
              //               spreadRadius: 2,
              //               blurRadius: 10,
              //               color: Colors.black.withOpacity(0.1),
              //             )
              //           ],
              //           shape: BoxShape.circle,
              //           image: DecorationImage(
              //             fit: BoxFit.cover,
              //             image: AssetImage('assets/icons/file.png'),
              //           )
              //         ),
              //       ),
              //       Positioned(
              //         bottom: 0,
              //         right: 0,
              //         child: Container(
              //           height: 40,
              //           width: 40,
              //           decoration: BoxDecoration(
              //             shape: BoxShape.circle,
              //             border: Border.all(
              //               width: 4,
              //               color: Colors.white,
              //             ),
              //             color: Colors.blue,
              //           ),
              //           child: Icon(
              //             Icons.edit,
              //             color: Colors.white,
              //           )
              //         )
              //       )
              //     ],
              //   ),
              // ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: TextField(
                  controller: _nameController,
                  keyboardType: TextInputType.name,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(bottom: 5),
                    label: const Text('Nom'),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    hintText: 'John Doe',
                    hintStyle: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    )
                  ),
                )
              ),
              Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(bottom: 5),
                        label: const Text('Email'),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        hintText: 'johndoe@gmail.com',
                        hintStyle: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        )
                    ),
                  )
              ),
              Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: TextField(
                    controller: _telController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(bottom: 5),
                        label: const Text('Telephone'),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        hintText: '66000000',
                        hintStyle: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        )
                    ),
                  )
              ),
              Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: TextField(
                    controller: _adresseController,
                    keyboardType: TextInputType.streetAddress,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(bottom: 5),
                        label: const Text('Adresse'),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        hintText: 'Cotonou, Bénin',
                        hintStyle: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        )
                    ),
                  )
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                      ),
                      child: sign == null
                          ? Image.asset(
                        'assets/vs_code.png',
                        height: 150,
                        fit: BoxFit.cover,
                      )
                          : Image.memory(sign),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        backgroundColor: Colors.blue.shade800,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        )
                      ),
                      child: const Text("Modifier"),
                      onPressed: () => _showForm(context, null),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      )
                    ),
                    child: const Text(
                      'ANNULER',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        letterSpacing: 2,
                      )
                    )
                  ),
                  ElevatedButton(
                    onPressed: () {
                      final inputs = Profile(
                        name: _nameController.text,
                        email: _emailController.text,
                        tel: int.parse(_telController.text),
                        adress: _adresseController.text,
                        imageBytes: sign
                      );
                      _update(inputs);
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Profile modifié avec succès.'),
                          )
                      );
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 50),
                      backgroundColor: Colors.blue.shade800,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      )
                    ),
                    child: const Text(
                      'VALIDER',
                      style: TextStyle(
                        fontSize: 15,
                        letterSpacing: 2,
                        color: Colors.white,
                      )
                    )
                  )
                ],
              )
            ],
          ),
        ),
      )
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
