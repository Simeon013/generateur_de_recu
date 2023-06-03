import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:generateur_de_recu/constants/colors.dart';
import 'package:generateur_de_recu/constants/dimensions.dart';
import 'package:generateur_de_recu/constants/widgets.dart';
import 'package:generateur_de_recu/screens/profile.dart';
import 'package:generateur_de_recu/screens/signature.dart';
import 'package:hive/hive.dart';

import '../constants/strings.dart';
import '../models/invoice.dart';
import '../models/locataire.dart';
import '../pdf/reader.dart';
import 'creatte_invoice.dart';
import 'invoices.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _sommeController = TextEditingController();

  List<Map<String, dynamic>> _locatairesItems = [];
  List<Map<String, dynamic>> _invoicesItems = [];

  final _locataireBox = Hive.box('locataire_box');
  final _invoiceBox = Hive.box('invoice_box');

  @override
  void initState() {
    super.initState();
    _refreshLocataires();
    _refreshInvoices();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _sommeController.dispose();
    super.dispose();
  }

  void _refreshLocataires() {
    final data = _locataireBox.keys.map((key) {
      final item = _locataireBox.get(key);

      final locataire = Locataire(name: item['name'] ?? '', somme: item['somme'] ?? 0);

      return {
        "key": key,
        "locataire": locataire,
      };
    }).toList();
    setState(() {
      _locatairesItems = data.reversed.toList();
    });
  }

  void _refreshInvoices() {
    final data = _invoiceBox.keys.map((key) {
      final item = _invoiceBox.get(key);

      final invoice = Invoice(id: item['id'] ?? 0, name: item['name'] ?? '', pdf: item['pdf']);

      return {
        "key": key,
        "invoice": invoice,
      };
    }).toList();
    setState(() {
      _invoicesItems = data.reversed.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.homeBackgroundColor,
      body: Column(children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
          alignment: Alignment.bottomCenter,
          height: AppDimensions.screenHeightPercent(context, 20),
          decoration: BoxDecoration(color: AppColors.headerBackgroundColor),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    AppStrings.headerTitle,
                    style: AppStrings.headerTitleStyle,
                  ),
                  Text(
                    AppStrings.headerSubtitle,
                    style: AppStrings.headerSubtitleStyle,
                  )
                ]),
            Row(
              children: [
                Container(
                  decoration: AppWidgets.iconBoxDecoration,
                  child: IconButton(
                    onPressed: () => _showForm(context, null),
                    icon: AppWidgets.addIcon,
                  ),
                ),
                SizedBox(
                  width: AppDimensions.screenWidthPercent(context, 1),
                ),
                Container(
                  decoration: AppWidgets.iconBoxDecoration,
                  child: IconButton(
                    onPressed: () {
                      // Naviguer vers la page de modification de signature
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePage()));
                    },
                    icon: AppWidgets.profileIcon,
                  ),
                )
              ],
            )
          ]),
        ),
        const SizedBox(height: 15),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(25),
            children: [
              Text(AppStrings.listTitle[0],
                style: AppStrings.listTitleStyle
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(_locatairesItems.length, (index) {
                    final item = _locatairesItems[index];
                    final locataire = item['locataire'] as Locataire;
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () => _showForm(context, item['key']),
                            child: Container(
                              padding: const EdgeInsets.all(38.0),
                              decoration: AppWidgets.locataireBoxDecoration,
                              height: 110.0,
                              child: SvgPicture.asset(AppStrings.personIconAsset),
                            ),
                          ),
                          const SizedBox(height: 15,),
                          RichText(
                              text: TextSpan(
                                  text: locataire.name,
                                  style: AppStrings.littleText1,
                                  // children: [
                                  //   TextSpan(text: '.sketch', style: AppStrings.littleText2)
                                  // ]
                              )
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
              const Divider(height: 60),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppStrings.listTitle[1],
                    style: AppStrings.listTitleStyle
                  ),
                  TextButton(
                    onPressed: // Naviguer vers la page de l'historique des reçus
                        () => Navigator.push(context, MaterialPageRoute(builder: (context) => InvoicesPage())),
                    child: const Text(
                      'Voir plus',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Column(
                children: List.generate(_invoicesItems.length, (index) {
                  final item = _invoicesItems[index];
                  final invoice = item['invoice'] as Invoice;
                  String text = invoice.name;
                  String limitedText = text.length < 25 ? text : '${text.substring(0, 25)}...';
                  return _invoiceBox.isEmpty
                    ? Center(
                      child: Text(AppStrings.noInvoice),
                     )
                    : GestureDetector(
                    onTap: () => _openInvoice(invoice),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: AppWidgets.invoiceBoxDecoration,
                      height: 65.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset(AppStrings.pdfIconAsset),
                              // const Icon(Icons.picture_as_pdf_outlined, color: Colors.red,),
                              const SizedBox(width: 12,),
                              Text(limitedText, style: const TextStyle(fontSize: 16), overflow: TextOverflow.ellipsis,)
                            ],
                          ),
                          IconButton(onPressed: (){}, icon: const Icon(Icons.more_vert_rounded, color: Colors.grey,))
                        ],
                      ),
                    ),
                  );
                }),
              )
            ],
          ),
        ),
      ]),
    );
  }

  //Create new item
  Future<void> _createItem(Locataire newItem) async {
    await _locataireBox.add({
      "name": newItem.name,
      "somme": newItem.somme,
    });
    _refreshLocataires();
  }
  
  //Update item
  Future<void> _updateItem(int itemKey, Locataire item) async {
    await _locataireBox.put(itemKey, {
      "name": item.name,
      "somme": item.somme,
    });
    _refreshLocataires();
  }


  //Delete item
  Future<void> _deleteItem(int key) async {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      // false = user must tap button, true = tap outside dialog
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Avertissement'),
          content: const Text('Voulez-vous supprimer cet élément ?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Non'),
              onPressed:(){
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: const Text('Oui'),
              onPressed: () async {
                await _locataireBox.delete(key);
                _refreshLocataires();
                Navigator.of(dialogContext).pop();
                Navigator.of(dialogContext).pop();// Dismiss alert dialog
              },
            ),
          ],
        );
      },
    );
  }

  void _showForm(BuildContext ctx, int? itemKey) async {

    if (itemKey != null) {
      final item = _locataireBox.get(itemKey);
      _nameController.text = item['name'];
      _sommeController.text = item['somme'].toString();
    }

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
                itemKey == null
                ? const Center(
                  child: Text(
                    'Ajouter un nouveau locataire',
                    style: AppStrings.formTitleStyle,
                  ),
                )
                : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Modifier un locataire',
                      style: AppStrings.formTitleStyle,
                    ),
                    IconButton(onPressed: () => _deleteItem(itemKey), icon: const Icon(Icons.delete, color: Colors.red,))
                  ],
                ),
                const SizedBox(height: 10),
                TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nom',
                    )
                ),
                const SizedBox(height: 10),
                TextField(
                    controller: _sommeController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Somme',
                    )
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    final newItem = Locataire(
                      name: _nameController.text,
                      somme: int.parse(_sommeController.text),
                    );

                    if (itemKey == null) {
                      _createItem(newItem);
                    }

                    if (itemKey != null) {
                      _updateItem(itemKey, newItem);
                    }

                    _nameController.text = '';
                    _sommeController.text = '';

                    Navigator.of(context).pop();
                  },
                  child: Text(itemKey==null? 'Enregistrer' : 'Modifier'),
                ),
                const SizedBox(height: 15),
              ],
            )
        )
    );
  }

  void _createInvoice(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => CreateInvoicePage()));
  }

  Future<void> _openInvoice(Invoice invoice) async {
    final pdfData = invoice.pdf;
    final pdfBytes = pdfData.buffer.asUint8List();

    Navigator.push(context, MaterialPageRoute(builder: (context) => ReaderPage(pdf: pdfBytes, pdfName: invoice.name,)));
  }
}
