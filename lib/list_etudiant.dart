import 'package:crudsqflite/etudiant_screen.dart';
import 'package:flutter/material.dart';
import 'database.dart';
import 'etudiant.dart';


class ListEtudiantPage extends StatefulWidget {
  @override
  _ListEtudiantPageState createState() => _ListEtudiantPageState();
}

class _ListEtudiantPageState extends State<ListEtudiantPage> {
  List<Etudiant> items = new List();
  DatabaseHelper db = new DatabaseHelper();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    db.getAllEtudiants().then((etudiant){
      setState((){
        etudiant.forEach((etudiant){
          items.add(Etudiant.fromMap(etudiant));
        });
      });
    });
  }


  void _deleteEtudiant(BuildContext context, Etudiant etudiant, int position) async {
    db.deleteEtudiant(etudiant.id).then((notes) {
      setState(() {
        items.removeAt(position);
      });
    });
  }

  void _navigateToEtudiant(BuildContext context, Etudiant etudiant) async {
    String result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EtudiantScreen(etudiant)),
    );

    if (result == 'update') {
      db.getAllEtudiants().then((etudiants) {
        setState(() {
          items.clear();
          etudiants.forEach((etudiant) {
            items.add(Etudiant.fromMap(etudiant));
          });
        });
      });
    }
  }

  void _createNewEtudiant(BuildContext context) async {
    String result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EtudiantScreen(Etudiant('', ''))),
    );

    if (result == 'save') {
      db.getAllEtudiants().then((etudiants) {
        setState(() {
          items.clear();
          etudiants.forEach((etudiant) {
            items.add(Etudiant.fromMap(etudiant));
          });
        });
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des etudiants'),
      ),
      body: Center(
        child: ListView.builder(
            itemCount: items.length,
            padding: const EdgeInsets.all(15.0),
            itemBuilder: (context, position) {
              return Column(
                children: <Widget>[
                  Divider(height: 5.0),
                  ListTile(
                    title: Text(
                      '${items[position].nom}',
                      style: TextStyle(
                        fontSize: 22.0,
                        color: Colors.deepOrangeAccent,
                      ),
                    ),
                    subtitle: Text(
                      '${items[position].prenom}',
                      style: new TextStyle(
                        fontSize: 18.0,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    leading: Column(
                      children: <Widget>[
                        Padding(padding: EdgeInsets.all(10.0)),
                        CircleAvatar(
                          backgroundColor: Colors.blueAccent,
                          radius: 15.0,
                          child: Text(
                            '${items[position].id}',
                            style: TextStyle(
                              fontSize: 22.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        IconButton(
                            icon: const Icon(Icons.remove_circle_outline),
                            onPressed: () => _deleteEtudiant(context, items[position], position)),
                      ],
                    ),
                    onTap: () => _navigateToEtudiant(context, items[position]),
                  ),
                ],
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _createNewEtudiant(context),
      ),
    );
  }


}



