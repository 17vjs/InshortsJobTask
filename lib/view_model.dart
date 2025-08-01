import 'package:flutter/material.dart';
import 'home_repository.dart';
import 'api_service.dart';

class ViewModel extends ChangeNotifier {
  final Repository _repository = Repository();
  // Playing Now

  bool _playingNowMoviesloading = false;
  bool get playingNowMoviesloading => _playingNowMoviesloading;

  String _playingNowMoviesError = "";
  String get playingNowMoviesError => _playingNowMoviesError;

  List<Movie> _allPlayingNowMovies = [];
  List<Movie> get allPlayingNowMovies => _allPlayingNowMovies;
  // Trending
  bool _trendingMoviesloading = false;
  bool get trendingMoviesloading => _trendingMoviesloading;

  String _trendingMoviesError = "";
  String get trendingMoviesError => _trendingMoviesError;

  List<Movie> _allTrendingMovies = [];
  List<Movie> get allTrendingMovies => _allTrendingMovies;

  //Bookmarks

  bool _bookmarkMoviesloading = false;
  bool get bookmarkMoviesloading => _bookmarkMoviesloading;

  String _bookmarkMoviesError = "";
  String get bookmarkMoviesError => _bookmarkMoviesError;

  List<Movie> _allBookmarkMovies = [];
  List<Movie> get allBookmarkMovies => _allBookmarkMovies;

  Future<void> addBookmark(Movie movie) async {
    await _repository.addBookmarkMovie(movie);

    _allPlayingNowMovies
            .firstWhere((m) => m.id == movie.id, orElse: () => Movie())
            .isBookMarked =
        true;
    _allTrendingMovies
            .firstWhere((m) => m.id == movie.id, orElse: () => Movie())
            .isBookMarked =
        true;

    notifyListeners();
  }

  Future<void> removeBookmark(int id) async {
    await _repository.deleteBookmarkMovie(id);

    _allPlayingNowMovies
            .firstWhere((m) => m.id == id, orElse: () => Movie())
            .isBookMarked =
        false;
    _allTrendingMovies
            .firstWhere((m) => m.id == id, orElse: () => Movie())
            .isBookMarked =
        false;
    _allBookmarkMovies
            .firstWhere((m) => m.id == id, orElse: () => Movie())
            .isBookMarked =
        false;
    getBookmarkMovies();

    notifyListeners();
  }

  Future<bool> isBookMarked(int id) async {
    Movie? movie = await _repository.getBookmarkMovie(id);
    return (movie != null);
  }

  Future<void> getBookmarkMovies() async {
    _bookmarkMoviesloading = true;
    _bookmarkMoviesError = "";
    notifyListeners();
    try {
      final result = await _repository.getAllBookmarkMovies();
      _allBookmarkMovies = result;
    } catch (e) {
      _bookmarkMoviesError = e.toString();
    } finally {
      _bookmarkMoviesloading = false;
      notifyListeners();
    }
  }

  
  Future<void> fetchPlayingNowMovies() async {
    _playingNowMoviesloading = true;
    _playingNowMoviesError = "";

    notifyListeners();
    try {
      final result = await _repository.fetchAndStorePlayingNowMovies();
      _allPlayingNowMovies = result;
    } catch (e) {
      _playingNowMoviesError = e.toString();

      final result = await _repository.getAllPlayingNowMovies();
      _allPlayingNowMovies = result;
    } finally {
      _playingNowMoviesloading = false;

      notifyListeners();
    }
  }

  Future<void> fetchTrendingMovies() async {
    _trendingMoviesloading = true;
    _trendingMoviesError = "";
    notifyListeners();
    try {
      final result = await _repository.fetchAndStoreTrendingMovies();
      _allTrendingMovies = result;
    } catch (e) {
      _trendingMoviesError = e.toString();

      final result = await _repository.getAllTrendingMovies();
      _allTrendingMovies = result;
    } finally {
      _trendingMoviesloading = false;

      notifyListeners();
    }
  }

  Future<List<Movie>> searchMovie(String text) async {
    return await _repository.searchMovie(text);
  }

  Future<Movie> fetchMovie(int id) async {
    return _repository.fetchMovie(id);
  }

  Future<void> closeDatabase() async {
    try {
      await _repository.closeDatabase();
    } catch (e) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    closeDatabase();
    super.dispose();
  }
}
