import 'package:flutter/material.dart';
import 'package:generateur_de_recu/pdf/pdf_page.dart';
import 'package:generateur_de_recu/screens/signature.dart';

import 'creatte_invoice.dart';
import 'locataires.dart';

class MenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu Page'),
      ),
      body: Center(
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
          padding: EdgeInsets.all(10.0),
          children: [
            // GridTile(
            //   child: ElevatedButton.icon(
            //     onPressed: () {
            //       // Naviguer vers la page d'ajout d'un nouveau locataire
            //       Navigator.push(context, MaterialPageRoute(builder: (context) => AddTenantPage()));
            //     },
            //     icon: Icon(Icons.add),
            //     label: Text('Ajouter un locataire'),
            //   ),
            // ),
            // GridTile(
            //   child: ElevatedButton.icon(
            //     onPressed: () {
            //       // Naviguer vers la page d'ajout d'un nouvel appartement
            //       Navigator.push(context, MaterialPageRoute(builder: (context) => AddApartmentPage()));
            //     },
            //     icon: Icon(Icons.apartment),
            //     label: Text('Ajouter un appartement'),
            //   ),
            // ),
            GridTile(
              child: ElevatedButton.icon(
                onPressed: () {
                  // Naviguer vers la page de la liste des locataires
                  Navigator.push(context, MaterialPageRoute(builder: (context) => LocatairesPage()));
                },
                icon: Icon(Icons.list),
                label: Text('Liste des locataires'),
              ),
            ),
            GridTile(
              child: ElevatedButton.icon(
                onPressed: () {
                  // Naviguer vers la page de la liste des appartements
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => ApartmentListPage()));
                },
                icon: Icon(Icons.list),
                label: Text('Liste des appartements'),
              ),
            ),
            GridTile(
              child: ElevatedButton.icon(
                onPressed: () {
                  // Naviguer vers la page de l'historique des reçus
                },
                icon: Icon(Icons.history),
                label: Text("Voir"),
              ),
            ),
            GridTile(
              child: ElevatedButton.icon(
                onPressed: () {
                  // Naviguer vers la page de l'historique des reçus
                },
                icon: Icon(Icons.history),
                label: Text("Historique des reçus"),
              ),
            ),
            GridTile(
              child: ElevatedButton.icon(
                onPressed: () {
                  // Naviguer vers la page de génération de reçu de location
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CreateInvoicePage()));
                },
                icon: Icon(Icons.receipt),
                label: Text('Générer un reçu'),
              ),
            ),
            GridTile(
              child: ElevatedButton.icon(
                onPressed: () {
                  // Naviguer vers la page de modification de signature
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SignaturePage()));
                },
                icon: Icon(Icons.edit),
                label: Text("Modifier la signature"),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(15.0),
        child: FloatingActionButton(
          onPressed: () {
            // Naviguer vers la page de génération d'une nouvelle facture
            // Navigator.push(context, MaterialPageRoute(builder: (context) => SqliteExample()));
            Navigator.push(context, MaterialPageRoute(builder: (context) => CreateInvoicePage()));
          },
          child: Icon(Icons.add),
          tooltip: 'Nouvelle facture',
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
