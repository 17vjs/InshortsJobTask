import 'package:dio/dio.dart';
import 'api_service.dart';
import 'db_helper.dart';

class Repository {
  late final ApiService _apiService;
  final DBHelper _dbHelper = DBHelper();

  Repository() {
    final dio = Dio();
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.headers['Authorization'] = 'Basic MTd2anM6VmlqYXlAMTIz';
          options.headers['Accept'] = 'application/json';
          return handler.next(options);
        },
      ),
    );
    _apiService = ApiService(dio);
  }

  Future<List<Movie>> fetchAndStorePlayingNowMovies() async {
    try {
      final response = await _apiService.getNowPlayingMovies('en-US', 1);
      if (response.results != null) {
        await _dbHelper.insertMovies(response.results!);
        return response.results!;
      } else {
        return await getAllPlayingNowMovies();
      }
    } catch (e) {
      throw Exception('Failed to fetch movie: $e');
    }
  }

  Future<List<Movie>> searchMovie(String text) async {
    try {
      final response = await _apiService.searchMovie(text, 'en-US', 1);
      if (response.results != null) {
        return response.results!;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<Movie> fetchMovie(int id) async {
    return await _apiService.fetchMovie(id, 'en-US');
  }

  Future<List<Movie>> fetchAndStoreTrendingMovies() async {
    try {
      final response = await _apiService.getTrendingMovies('fr-FR', 5);
      if (response.results != null) {
        await _dbHelper.insertTrendingMovies(response.results!);
        return response.results!;
      } else {
        return await getAllTrendingMovies();
      }
    } catch (e) {
      throw Exception('Failed to fetch movie: $e');
    }
  }

  Future<void> addBookmarkMovie(Movie movie) async {
    await _dbHelper.insertBookmarkMovie(movie);
  }

  Future<Movie?> getBookmarkMovie(int id) async {
    try {
      return await _dbHelper.getBookmarkMovie(id);
    } catch (e) {
      throw Exception('Failed to get local movie: $e');
    }
  }

  Future<List<Movie>> getAllPlayingNowMovies() async {
    try {
      return await _dbHelper.getAllMovies();
    } catch (e) {
      throw Exception('Failed to get all local movies: $e');
    }
  }

  Future<List<Movie>> getAllTrendingMovies() async {
    try {
      return await _dbHelper.getAllTrendingMovies();
    } catch (e) {
      throw Exception('Failed to get all local movies: $e');
    }
  }

  Future<List<Movie>> getAllBookmarkMovies() async {
    try {
      return await _dbHelper.getAllBookmarkMovies();
    } catch (e) {
      throw Exception('Failed to get all local movies: $e');
    }
  }

  Future<void> deleteBookmarkMovie(int id) async {
    try {
      await _dbHelper.deleteBookmarkMovie(id);
    } catch (e) {
      throw Exception('Failed to delete local movie: $e');
    }
  }

  Future<void> clearAllLocalMovies() async {
    try {
      await _dbHelper.clearAllMovies();
    } catch (e) {
      throw Exception('Failed to clear all local movies: $e');
    }
  }

  Future<void> closeDatabase() async {
    try {
      await _dbHelper.close();
    } catch (e) {
      throw Exception('Failed to close database: $e');
    }
  }
}
