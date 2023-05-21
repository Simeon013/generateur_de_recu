import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/person.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  List<Map<String, dynamic>> _items = [];

  final _testBox = Hive.box('test_box');

  @override
  void initState() {
    super.initState();
    _refreshItems();
  }

  // @override
  // void dispose() {
  //   _nameController.dispose();
  //   _ageController.dispose();
  //   super.dispose();
  // }

  void _refreshItems() {
    final data = _testBox.keys.map((key) {
      final item = _testBox.get(key);

      final person = Person(name: item['name'] ?? '', age: item['age'] ?? 0);

      return {
        "key": key,
        "person": person,
      };
    }).toList();
    setState(() {
      _items = data.reversed.toList();
    });
  }


  //Create new item
  Future<void> _createItem(Person newItem) async {
    await _testBox.add({
      "name": newItem.name,
      "age": newItem.age,
    });
    _refreshItems();
  }


  //Update item
  Future<void> _updateItem(int itemKey, Person item) async {
    await _testBox.put(itemKey, {
      "name": item.name,
      "age": item.age,
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
                await _testBox.delete(key);
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
      final item = _testBox.get(itemKey);
      _nameController.text = item['name'];
      _ageController.text = item['age'].toString();
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
                      labelText: 'Item Name',
                    )
                ),
                const SizedBox(height: 10),
                TextField(
                    controller: _ageController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'age',
                    )
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    final newItem = Person(
                      name: _nameController.text,
                      age: int.parse(_ageController.text),
                    );

                    if (itemKey == null) {
                      _createItem(newItem);
                    }

                    if (itemKey != null) {
                      _updateItem(itemKey, newItem);

                    }

                    _nameController.text = '';
                    _ageController.text = '';

                    Navigator.of(context).pop();
                  },
                  child: Text(itemKey==null? 'Save' : 'Update'),
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
        title: Text('Person List'),
      ),
      body: ListView.builder(
          itemCount: _items.length,
          itemBuilder: (_, index) {
            final item = _items[index];
            final person = item['person'] as Person;
            print(_items[index][1]);
            return Card(
                color: Colors.grey,
                margin: const EdgeInsets.all(10),
                elevation: 3,
                child: ListTile(
                  title: Text(person.name?? 'Unknown'),
                  subtitle: Text(person.age.toString()),
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
