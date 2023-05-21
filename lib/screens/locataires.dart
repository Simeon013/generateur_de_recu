import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/locataire.dart';


class LocatairesPage extends StatefulWidget {
  const LocatairesPage({super.key});

  @override
  State<LocatairesPage> createState() => _LocatairesPageState();
}

class _LocatairesPageState extends State<LocatairesPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _sommeController = TextEditingController();

  List<Map<String, dynamic>> _items = [];

  final _locationBox = Hive.box('location_box');

  @override
  void initState() {
    super.initState();
    _refreshItems();
  }


  @override
  void dispose() {
    _nameController.dispose();
    _sommeController.dispose();
    // _locationBox.close();
    super.dispose();
  }

  void _refreshItems() {
    final data = _locationBox.keys.map((key) {
      final item = _locationBox.get(key);

      final locataire = Locataire(name: item['name'] ?? '', somme: item['somme'] ?? 0);
      if (kDebugMode) {
        print(item['somme']);
      }

      return {
        "key": key,
        "locataire": locataire,
      };
    }).toList();
    setState(() {
      _items = data.reversed.toList();
    });
  }


  //Create new item
  Future<void> _createItem(Locataire newItem) async {
    await _locationBox.add({
      "name": newItem.name,
      "somme": newItem.somme,
    });
    _refreshItems();
  }


  //Update item
  Future<void> _updateItem(int itemKey, Locataire item) async {
    await _locationBox.put(itemKey, {
      "name": item.name,
      "somme": item.somme,
    });
    _refreshItems();
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
                await _locationBox.delete(key);
                _refreshItems();
                Navigator.of(dialogContext).pop(); // Dismiss alert dialog
              },
            ),
          ],
        );
      },
    );
  }

  void _showForm(BuildContext ctx, int? itemKey) async {

    if (itemKey != null) {
      final item = _locationBox.get(itemKey);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des locataires'),
      ),
      body: ListView.builder(
          itemCount: _items.length,
          itemBuilder: (_, index) {
            final item = _items[index];
            final locataire = item['locataire'] as Locataire;
            return Card(
                color: Colors.grey,
                margin: const EdgeInsets.all(10),
                elevation: 3,
                child: ListTile(
                  title: Text(locataire.name),
                  subtitle: Text('${locataire.somme} CFA'),
                  trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () => _showForm(context, item['key']),
                          icon: const Icon(Icons.edit),
                        ),
                        IconButton(
                          onPressed: () => _deleteItem(item['key']),
                          icon: const Icon(Icons.delete),
                        )
                      ]
                  ),
                )
            );
          }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(context, null),
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
