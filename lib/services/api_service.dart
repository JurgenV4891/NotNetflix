import 'package:dio/dio.dart';
import 'package:notnetflix/services/api.dart';
import 'package:notnetflix/models/movie.dart';

import '../models/person.dart';

class APIService {
  final API api = API();
  final Dio dio = Dio();

  Future<Response> getData(String path, {Map<String, dynamic>? params}) async {
    // je construis l'URL
    String _url = api.baseURL + path;

    //je construis les paramètres de la requête
    // ces paramètres seront présents dans chaque requêtes
    Map<String, dynamic> query = {
      'api_key': api.apiKey,
      'language': 'fr-FR',
    };

// si params n'est pas null, alors j'ajoute son contenu à query
    if (params != null) {
      query.addAll(params);
    }

    // je fais l'appel
    final response = await dio.get(_url, queryParameters: query);
// on check si la requête s'est bien passé
    if (response.statusCode == 200) {
      return response;
    } else {
      throw response;
    }
  }

  Future<List<Movie>> getPopularMovies({required int pageNumber}) async {
    Response response = await getData('/movie/popular', params: {
      'page': pageNumber,
    });

    if (response.statusCode == 200) {
      Map data = response.data;
      List<dynamic> results = data['results'];
      List<Movie> movies = [];
      for (Map<String, dynamic> json in results) {
        Movie movie = Movie.fromJson(json);
        movies.add(movie);
      }

      return movies;
    } else {
      throw response;
    }
  }

  Future<List<Movie>> getNowPlaying({required int pageNumber}) async {
    Response response = await getData('/movie/now_playing', params: {
      'page': pageNumber,
    });

    if (response.statusCode == 200) {
      Map data = response.data;
      List<Movie> movies = data['results'].map<Movie>((dynamic movieJson) {
        return Movie.fromJson(movieJson);
      }).toList();
      return movies;
    } else {
      throw response;
    }
  }

  Future<List<Movie>> getUpcomingMovies({required int pageNumber}) async {
    Response response = await getData('/movie/upcoming', params: {
      'page': pageNumber,
    });

    if (response.statusCode == 200) {
      Map data = response.data;
      List<Movie> movies = data['results'].map<Movie>((dynamic movieJson) {
        return Movie.fromJson(movieJson);
      }).toList();
      return movies;
    } else {
      throw response;
    }
  }

  Future<List<Movie>> getAnimationMovies({required int pageNumber}) async {
    Response response = await getData('/discover/movie',
        params: {'page': pageNumber, 'with_genres': '16'});

    if (response.statusCode == 200) {
      Map data = response.data;
      List<Movie> movies = data['results'].map<Movie>((dynamic movieJson) {
        return Movie.fromJson(movieJson);
      }).toList();
      return movies;
    } else {
      throw response;
    }
  }

  Future<List<Movie>> getTopRatedMovies({required int pageNumber}) async {
    Response response = await getData('/movie/top_rated', params: {
      'page': pageNumber,
    });

    if (response.statusCode == 200) {
      Map data = response.data;
      List<Movie> movies = data['results'].map<Movie>((dynamic movieJson) {
        return Movie.fromJson(movieJson);
      }).toList();
      return movies;
    } else {
      throw response;
    }
  }

  Future<Movie> getMovie({required Movie movie}) async {
    Response response = await getData('/movie/${movie.id}', params: {
      'include_image_language': 'null',
      'append_to_response': 'videos, images, credits',
    });
    if (response.statusCode == 200) {
      Map _data = response.data;
      //on récupère les genres
      var genres = _data['genres'] as List;
      List<String> genreList = genres.map((item) {
        return item['name'] as String;
      }).toList();

      // on récupère les vidéos
      List<String> videoKeys =
          _data['videos']['results'].map<String>((dynamic videoJson) {
        return videoJson['key'] as String;
      }).toList();

//on récupère les images
      List<String> imagePath =
          _data['images']['backdrops'].map<String>((dynamic imageJson) {
        return imageJson['file_path'] as String;
      }).toList();

      // on récupère le casting
      List<Person> _casting =
          _data['credits']['cast'].map<Person>((dynamic personJson) {
        return Person.fromJson(personJson);
      }).toList();

      return movie.copyWith(
        videos: videoKeys,
        images: imagePath,
        casting: _casting,
        genres: genreList,
        releaseDate: _data['release_date'],
        vote: _data['vote_average'],
      );
    } else {
      throw response;
    }
  }
}
