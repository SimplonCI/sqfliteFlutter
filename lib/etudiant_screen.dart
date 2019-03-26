import 'package:crudsqflite/database.dart';
import 'package:crudsqflite/etudiant.dart';
import 'package:flutter/material.dart';

class EtudiantScreen extends StatefulWidget {
  final Etudiant etudiant;
  EtudiantScreen(this.etudiant);

  @override
  _EtudiantScreenState createState() => _EtudiantScreenState();
}

class _EtudiantScreenState extends State<EtudiantScreen> {
  DatabaseHelper db = new DatabaseHelper();

  TextEditingController nomController;
  TextEditingController prenomController;
  bool _validateNom= false;
  bool _validatePrenom = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.nomController = TextEditingController(text: widget.etudiant.nom);
    this.prenomController = TextEditingController(text: widget.etudiant.prenom);
  }
  @override
  Widget build(BuildContext context) {

    // champ nom
    final nom = TextFormField(
      controller: nomController,
      keyboardType: TextInputType.text,
      autofocus: false,
      decoration: InputDecoration(
          fillColor: Color(0xffe60028),
          focusedBorder: OutlineInputBorder(
              borderSide: new BorderSide(
                  color: Colors.black54
              )
          ),
          border: OutlineInputBorder(),
          labelText: 'Votre nom',
          labelStyle: TextStyle(
              color: Colors.black54
          ),
          errorText: _validateNom? 'Le nom est obligatoire': null
      ),
    );


    // champ nom
    final prenom = TextFormField(
      controller: prenomController,
      keyboardType: TextInputType.text,
      autofocus: false,
      decoration: InputDecoration(
          fillColor: Color(0xffe60028),
          focusedBorder: OutlineInputBorder(
              borderSide: new BorderSide(
                  color: Colors.black54
              )
          ),
          border: OutlineInputBorder(),
          labelText: 'Votre prenom',
          labelStyle: TextStyle(
              color: Colors.black54
          ),
          errorText: _validatePrenom? 'Le prenom est obligatoire': null
      ),
    );

    final button = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        padding: EdgeInsets.all(15),
        color: new Color(0xff236E94),
        child: (widget.etudiant.id != null) ?
          Text(
              'Mettre à jour',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,

              )
          ) :
          Text(
              'Ajouter',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,

              )
          ),
        onPressed: () {
          setState(() {
            nomController.text.isEmpty ? _validateNom = true : _validateNom = false;
            prenomController.text.isEmpty ? _validatePrenom = true : _validatePrenom = false;
          });

          if(_validatePrenom == false && _validateNom == false){
            if (widget.etudiant.id != null) {
              db.updateEtudiant(Etudiant.fromMap({
                'id': widget.etudiant.id,
                'nom': nomController.text,
                'prenom': prenomController.text
              })).then((_) {
                Navigator.pop(context, 'update');
              });
            }else {
              db.saveEtudiant(Etudiant(nomController.text, prenomController.text)).then((_) {
                Navigator.pop(context, 'save');
              });
            }
          }

        },
      ),
    );
    return Scaffold(
      appBar: AppBar(

        title: (widget.etudiant.id != null) ? Text("Update d'un etudiant") : Text('Ajouter un etudiant'),
      ),
      body: new Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0,right: 24.0),
          children: <Widget>[
            nom,
            SizedBox(height: 20.0,),
            prenom,
            SizedBox(height: 20.0,),
            button
          ],
        ),

      ),

    );
  }
}
