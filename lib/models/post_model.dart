class PostModel {
  int? idPost;
  String? dsc;
  String? datePost;

  PostModel({this.idPost, this.dsc, this.datePost});
  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
        idPost: map['idPost'], dsc: map['dsc'], datePost: map['datePost']);
  }
}

// FutureBuilder -> Retorna un Widget -> Se ejecuta una sola vez y si se necesita mas elementos se vuelve a ejecutar de nuevo
// StreamBuilder -> Retorna un Widget -> Se suscribe a un flujo en la nube o servicio interno -> No se necesita hacer un setstate()

