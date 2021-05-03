// Generated by https://quicktype.io
class Peliculas {
  List<Pelicula> items = new List();
  Peliculas();
  //Recibir mapa de todas las respuestas (peliculas)
  Peliculas.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return;
    //recibo un mapa con propiedades, no una pelicula como tal aun
    for (var item in jsonList) {
      //Construccion de cada pelicula
      final pelicula = new Pelicula.fromJsonMap(item);
      //Agregar cada pelicula
      items.add(pelicula);
    }
  }
}

class Pelicula {
  String uniqueId;

  bool adult;
  String backdropPath;
  List<int> genreIds;
  int id;
  String originalLanguage;
  String originalTitle;
  String overview;
  double popularity;
  String posterPath;
  String releaseDate;
  String title;
  bool video;
  double voteAverage;
  int voteCount;

  Pelicula({
    this.adult,
    this.backdropPath,
    this.genreIds,
    this.id,
    this.originalLanguage,
    this.originalTitle,
    this.overview,
    this.popularity,
    this.posterPath,
    this.releaseDate,
    this.title,
    this.video,
    this.voteAverage,
    this.voteCount,
  });
  //Para generar una instancia de pelicula que viene de un Mapa en formato JSON
  Pelicula.fromJsonMap(Map<String, dynamic> json) {
    voteCount = json['vote_count'];
    id = json['id'];
    video = json['video'];
    voteAverage = json['vote_average'] / 1;
    title = json['title'];
    popularity = json['popularity'] / 1;
    posterPath = json['poster_path'];
    originalLanguage = json['original_language'];
    originalTitle = json['original_title'];
    genreIds = json['genre_ids'].cast<int>();
    backdropPath = json['backdrop_path'];
    adult = json['adult'];
    overview = json['overview'];
    releaseDate = json['release_date'];
  }
  getBackgroundImg() {
    if (posterPath == null) {
      return 'https://cdn11.bigcommerce.com/s-auu4kfi2d9/stencil/59512910-bb6d-0136-46ec-71c445b85d45/e/933395a0-cb1b-0135-a812-525400970412/icons/icon-no-image.svg';
    } else {
      return 'https://image.tmdb.org/t/p/w500/$backdropPath';
    }
  }

  getPosterImg() {
    if (posterPath == null) {
      return 'https://i.pinimg.com/736x/b5/b2/26/b5b22648ca883192bb2a121948fb1f59.jpg';
    } else {
      return 'https://image.tmdb.org/t/p/w500/$posterPath';
    }
  }
}