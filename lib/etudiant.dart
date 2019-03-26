
class Etudiant{
  int _id;
  String _nom;
  String _prenom;

  //constructeur
  Etudiant(this._nom,this._prenom);

  Etudiant.map(dynamic obj){
    this._id = obj['id'];
    this._nom = obj['nom'];
    this._prenom = obj['prenom'];
  }


  int get id => _id;
  String get nom => _nom;
  String get prenom => _prenom;

  Map<String, dynamic> toMap(){
    var map = new Map<String,dynamic>();
    if(_id != null){
      map['id'] = _id;
    }
    map['nom'] = _nom;
    map['prenom'] = _prenom;
    return map;
  }

  Etudiant.fromMap(Map<String ,dynamic>map){
    this._id = map['id'];
    this._nom = map['nom'];
    this._prenom = map['prenom'];
  }
}