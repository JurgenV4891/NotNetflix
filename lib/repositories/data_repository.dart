import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:notnetflix/models/movie.dart';
import 'package:notnetflix/services/api_service.dart';

class DataRepository with ChangeNotifier {
  final APIService apiService = APIService();
  final List<Movie> _popularMovieList = [];
  int _popularMoviePageIndex = 1;
  final List<Movie> _nowPlaying = [];
  int _nowPlayingPageIndex = 1;
  final List<Movie> _upcomingMovies = [];
  int _upcomingMoviesPageIndex = 1;
  final List<Movie> _animationMovies = [];
  int _animationMoviesPageIndex = 1;
  final List<Movie> _topRatedMovies = [];
  int _topRatedMoviesPageIndex = 1;

//getters
  List<Movie> get popularMovieList => _popularMovieList;
  List<Movie> get nowPlaying => _nowPlaying;
  List<Movie> get upcomingMovies => _upcomingMovies;
  List<Movie> get animationMovies => _animationMovies;
  List<Movie> get topRatedMovie => _topRatedMovies;

  Future<void> getPopularMovies() async {
    try {
      List<Movie> movies =
          await apiService.getPopularMovies(pageNumber: _popularMoviePageIndex);
      _popularMovieList.addAll(movies);
      _popularMoviePageIndex++;
      notifyListeners();
    } on Response catch (response) {
      print("ERROR: ${response.statusCode}");
      rethrow;
    }
  }

  Future<void> getNowPlaying() async {
    try {
      List<Movie> movies =
          await apiService.getNowPlaying(pageNumber: _nowPlayingPageIndex);
      _nowPlaying.addAll(movies);
      _nowPlayingPageIndex++;
      notifyListeners();
    } on Response catch (response) {
      print("ERROR: ${response.statusCode}");
      rethrow;
    }
  }

  Future<void> getUpcomingMovies() async {
    try {
      List<Movie> movies = await apiService.getUpcomingMovies(
          pageNumber: _upcomingMoviesPageIndex);
      _upcomingMovies.addAll(movies);
      _upcomingMoviesPageIndex++;
      notifyListeners();
    } on Response catch (response) {
      print("ERROR: ${response.statusCode}");
      rethrow;
    }
  }

  Future<void> getAnimationMovies() async {
    try {
      List<Movie> movies = await apiService.getAnimationMovies(
          pageNumber: _animationMoviesPageIndex);
      _animationMovies.addAll(movies);
      _animationMoviesPageIndex++;
      notifyListeners();
    } on Response catch (response) {
      print("ERROR: ${response.statusCode}");
      rethrow;
    }
  }

  Future<void> getTopRatedMovies() async {
    try {
      List<Movie> movies = await apiService.getTopRatedMovies(
          pageNumber: _topRatedMoviesPageIndex);
      _topRatedMovies.addAll(movies);
      _topRatedMoviesPageIndex++;
      notifyListeners();
    } on Response catch (response) {
      print("ERROR: ${response.statusCode}");
      rethrow;
    }
  }

  Future<Movie> getMovieDetails({required Movie movie}) async {
    try {
      // on r??cup??re les infos du film
      // Movie newMovie = await apiService.getMovieDetails(movie: movie);
      // on r??cup??re les videos
      // newMovie = await apiService.getMovieVideos(movie: newMovie);
      //on r??cup??re le casting
      // newMovie = await apiService.getMovieCast(movie: newMovie);
      //on r??cup??re les images
      // newMovie = await apiService.getMovieImage(movie: newMovie);
      // Ci-dessus: on fait 4 requ??tes pour r??cup??rer les infos du film, les vid??os,le casting et les images.
      // Si on tombe sur une appli payante, ??a fait bcp de requ??tes : on arrivera vite au bout du nombre de requ??tes pr??-d??fini par l'api
      // Alors on doit cr???? une nouvelle fonction dans api_service: getMovie avec en second param??tre append_to_response !!!
      // Toujours lire la doc des API que j'utilise, souvent il y a tjrs des solutions pour combiner les requ??tes
      //Du coup j'optimise les performances de mon application et  si l'API est payante alors on fera des ??conomies
      //Ci-dessous j'ai remplacer 4 requ??tes par une seul:

      Movie newMovie = await apiService.getMovie(movie: movie);
      return newMovie;
    } on Response catch (response) {
      print("ERROR : ${response.statusCode}");
      rethrow;
    }
  }

  Future<void> initData() async {
    // Ici le pb est que le 2??me appel ne sera initialiser que lorsque le 1er aura termin?? sa t??che...niveau performance c'est pas terrible
    // await getPopularMovies();
    // await getNowPlaying();
    // await getUpcomingMovies();
    // await getAnimationMovies();

    // On doit utiliser Future.wait pour des appels simultan??s !
    await Future.wait([
      getPopularMovies(),
      getNowPlaying(),
      getUpcomingMovies(),
      getAnimationMovies(),
      getTopRatedMovies(),
    ]);
  }
}
