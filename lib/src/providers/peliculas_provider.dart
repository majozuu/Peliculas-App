import 'dart:async';
import 'dart:convert';

import 'package:peliculas/src/models/actores_model.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:http/http.dart' as http;

class PeliculasProvider {
  String _apiKey = 'ff27dabe3e6688d53b4295910dc0796f';
  String _url = 'api.themoviedb.org';
  String _language = 'es-ES';

  int _popularesPage = 0;
  bool _cargando = false;

  List<Pelicula> _populares = new List();

  //Todos pueden escuchar este stream
  final _popularesStream = StreamController<List<Pelicula>>.broadcast();

  //Introducir peliculas
  Function(List<Pelicula>) get popularesSink => _popularesStream.sink.add;

  //Escuchar informacion
  Stream<List<Pelicula>> get popularesStream => _popularesStream.stream;

  void disposeStreams() {
    _popularesStream?.close();
  }

  Future<List<Pelicula>> _procesarRespuesta(Uri url) async {
    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);

    final peliculas = new Peliculas.fromJsonList(decodedData['results']);

    return peliculas.items;
  }

  Future<List<Pelicula>> getEnCines() async {
    //Construccion de url para hacer HTTP request
    final url = Uri.https(_url, '3/movie/now_playing', {
      'api_key': _apiKey,
      'language': _language,
    });
    //Devuelve un Future
    final resp = await http.get(url);
    //Decodificacion de la respuesta para obtener data
    final decodedData = json.decode(resp.body);
    //Generacion de lista de peliculas
    final peliculas = new Peliculas.fromJsonList(decodedData['results']);
    //Retorna las peliculas ya mapeadas
    return peliculas.items;
  }

  Future<List<Pelicula>> getPopulares() async {
    //Si sigue cargando, no sigo con el codigo
    if (_cargando) return [];
    _cargando = true;
    _popularesPage++;
    //Construccion de url para hacer HTTP request
    final url = Uri.https(_url, '3/movie/popular', {
      'api_key': _apiKey,
      'language': _language,
      'page': _popularesPage.toString()
    });

    final resp = await _procesarRespuesta(url);

    //Añadir informacion al Stream
    _populares.addAll(resp);
    //Usando el sink
    popularesSink(_populares);

    _cargando = false;

    //Retorna las peliculas ya mapeadas
    return resp;
  }

  Future<List<Actor>> getCast(String peliculaId) async {
    final url = Uri.https(_url, '3/movie/$peliculaId/credits', {
      'api_key': _apiKey,
      'language': _language,
    });
    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);
    final cast = new Cast.fromJsonList(decodedData['cast']);

    return cast.actores;
  }

  Future<List<Pelicula>> buscarPelicula(String query) async {
    //Construccion de url para hacer HTTP request
    final url = Uri.https(_url, '3/search/movie',
        {'api_key': _apiKey, 'language': _language, 'query': query});

    return await _procesarRespuesta(url);
  }
}
