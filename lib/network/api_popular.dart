import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:socialtec/models/actor_model.dart';
import 'package:socialtec/models/popular_model.dart';

class ApiPopular {
  Uri link = Uri.parse(
      'https://api.themoviedb.org/3/movie/popular?api_key=0cb894064f40656f3575e8ccae3d8d73&language=es-MX&page=1');
  Future<List<PopularModel>?> getAllPopular() async {
    var result = await http.get(link);
    var listJSON = jsonDecode(result.body)['results'] as List;
    if (result.statusCode == 200) {
      return listJSON.map((popular) => PopularModel.fromMap(popular)).toList();
    }
    return null;
  }

  Future<String> getVideo(int id_popular) async {
    Uri auxVideo = Uri.parse('https://api.themoviedb.org/3/movie/' +
        id_popular.toString() +
        '/videos?api_key=0cb894064f40656f3575e8ccae3d8d73');
    var result = await http.get(auxVideo);
    var listJSON = jsonDecode(result.body)['results'] as List;
    if (result.statusCode == 200) {
      return listJSON[0]['key'];
    }
    return '';
  }

  Future<List<ActorModel>?> getAllAuthors(PopularModel popularModel) async {
    Uri auxActores = Uri.parse('https://api.themoviedb.org/3/movie/' +
        popularModel.id.toString() +
        '/credits?api_key=0cb894064f40656f3575e8ccae3d8d73');
    var result = await http.get(auxActores);
    var listJSON = jsonDecode(result.body)['cast'] as List;
    if (result.statusCode == 200) {
      return listJSON.map((actor) => ActorModel.fromMap(actor)).toList();
    }
    return null;
  }
}
