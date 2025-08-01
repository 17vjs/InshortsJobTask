import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';
import 'api_service.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await _getDatabasePath();
    return await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE IF NOT EXISTS movies(
            id INTEGER PRIMARY KEY,
            title TEXT,
            originalTitle TEXT,
            overview TEXT,
            posterPath TEXT,
            backdropPath TEXT,
            releaseDate TEXT,
            voteAverage REAL,
            voteCount INTEGER,
            popularity REAL,
            adult INTEGER,
            video INTEGER,
            originalLanguage TEXT,
            genreIds TEXT
          )
          
        ''');
         await db.execute('''
          CREATE TABLE IF NOT EXISTS trending_movies(
            id INTEGER PRIMARY KEY,
            title TEXT,
            originalTitle TEXT,
            overview TEXT,
            posterPath TEXT,
            backdropPath TEXT,
            releaseDate TEXT,
            voteAverage REAL,
            voteCount INTEGER,
            popularity REAL,
            adult INTEGER,
            video INTEGER,
            originalLanguage TEXT,
            genreIds TEXT
          )
          
        ''');
          await db.execute('''
          CREATE TABLE IF NOT EXISTS bookmark_movies(
            id INTEGER PRIMARY KEY,
            title TEXT,
            originalTitle TEXT,
            overview TEXT,
            posterPath TEXT,
            backdropPath TEXT,
            releaseDate TEXT,
            voteAverage REAL,
            voteCount INTEGER,
            popularity REAL,
            adult INTEGER,
            video INTEGER,
            originalLanguage TEXT,
            genreIds TEXT
          )
          
        ''');
      },
    );
  }

  Future<String> _getDatabasePath() async {
    // Use path_provider to get the proper app documents directory
    final documentsDir = await getApplicationDocumentsDirectory();
    final dbDir = Directory('${documentsDir.path}/databases');
    if (!await dbDir.exists()) {
      await dbDir.create(recursive: true);
    }
    return join(dbDir.path, 'movies.db');
  }

 Future<void> insertBookmarkMovie(Movie movie) async {
    final db = await database;
    await db.insert(
      'bookmark_movies',
      {
        'id': movie.id,
        'title': movie.title,
        'originalTitle': movie.original_title,
        'overview': movie.overview,
        'posterPath': movie.poster_path,
        'backdropPath': movie.backdrop_path,
        'releaseDate': movie.release_date,
        'voteAverage': movie.vote_average,
        'voteCount': movie.vote_count,
        'popularity': movie.popularity,
        'adult': movie.adult == true ? 1 : 0,
        'video': movie.video == true ? 1 : 0,
        'originalLanguage': movie.original_language,
        'genreIds': movie.genre_ids != null ? jsonEncode(movie.genre_ids) : null,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  

  Future<void> insertMovie(Movie movie) async {
    final db = await database;
    await db.insert(
      'movies',
      {
        'id': movie.id,
        'title': movie.title,
        'originalTitle': movie.original_title,
        'overview': movie.overview,
        'posterPath': movie.poster_path,
        'backdropPath': movie.backdrop_path,
        'releaseDate': movie.release_date,
        'voteAverage': movie.vote_average,
        'voteCount': movie.vote_count,
        'popularity': movie.popularity,
        'adult': movie.adult == true ? 1 : 0,
        'video': movie.video == true ? 1 : 0,
        'originalLanguage': movie.original_language,
        'genreIds': movie.genre_ids != null ? jsonEncode(movie.genre_ids) : null,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  Future<void> insertTrendingMovie(Movie movie) async {
    final db = await database;
    await db.insert(
      'trending_movies',
      {
        'id': movie.id,
        'title': movie.title,
        'originalTitle': movie.original_title,
        'overview': movie.overview,
        'posterPath': movie.poster_path,
        'backdropPath': movie.backdrop_path,
        'releaseDate': movie.release_date,
        'voteAverage': movie.vote_average,
        'voteCount': movie.vote_count,
        'popularity': movie.popularity,
        'adult': movie.adult == true ? 1 : 0,
        'video': movie.video == true ? 1 : 0,
        'originalLanguage': movie.original_language,
        'genreIds': movie.genre_ids != null ? jsonEncode(movie.genre_ids) : null,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertMovies(List<Movie> movies) async {
   clearAllMovies();
    for (final movie in movies) {
      await insertMovie(movie);
    }
  }
Future<void> insertTrendingMovies(List<Movie> movies) async {
  clearAllTrendingMovies();
    for (final movie in movies) {
      await insertTrendingMovie(movie);
    }
  }
 Future<List<Movie>> getAllBookmarkMovies() async {
    final db = await database;
    final result = await db.query('bookmark_movies');
    
    return result.map((row) {
      final genreIdsString = row['genreIds'] as String?;
      List<int>? genreIds;
      if (genreIdsString != null) {
        genreIds = List<int>.from(jsonDecode(genreIdsString));
      }
      
      return Movie(
        id: row['id'] as int?,
        title: row['title'] as String?,
        original_title: row['originalTitle'] as String?,
        overview: row['overview'] as String?,
        poster_path: row['posterPath'] as String?,
        backdrop_path: row['backdropPath'] as String?,
        release_date: row['releaseDate'] as String?,
        vote_average: row['voteAverage'] as double?,
        vote_count: row['voteCount'] as int?,
        popularity: row['popularity'] as double?,
        adult: (row['adult'] as int?) == 1,
        video: (row['video'] as int?) == 1,
        original_language: row['originalLanguage'] as String?,
        genre_ids: genreIds,
      );
    }).toList();
  }

 Future<List<Movie>> getAllMovies() async {
    final db = await database;
    final result = await db.query('movies');
    
    return result.map((row) {
      final genreIdsString = row['genreIds'] as String?;
      List<int>? genreIds;
      if (genreIdsString != null) {
        genreIds = List<int>.from(jsonDecode(genreIdsString));
      }
      
      return Movie(
        id: row['id'] as int?,
        title: row['title'] as String?,
        original_title: row['originalTitle'] as String?,
        overview: row['overview'] as String?,
        poster_path: row['posterPath'] as String?,
        backdrop_path: row['backdropPath'] as String?,
        release_date: row['releaseDate'] as String?,
        vote_average: row['voteAverage'] as double?,
        vote_count: row['voteCount'] as int?,
        popularity: row['popularity'] as double?,
        adult: (row['adult'] as int?) == 1,
        video: (row['video'] as int?) == 1,
        original_language: row['originalLanguage'] as String?,
        genre_ids: genreIds,
      );
    }).toList();
  }
  Future<List<Movie>> getAllTrendingMovies() async {
    final db = await database;
    final result = await db.query('trending_movies');
    
    return result.map((row) {
      final genreIdsString = row['genreIds'] as String?;
      List<int>? genreIds;
      if (genreIdsString != null) {
        genreIds = List<int>.from(jsonDecode(genreIdsString));
      }
      
      return Movie(
        id: row['id'] as int?,
        title: row['title'] as String?,
        original_title: row['originalTitle'] as String?,
        overview: row['overview'] as String?,
        poster_path: row['posterPath'] as String?,
        backdrop_path: row['backdropPath'] as String?,
        release_date: row['releaseDate'] as String?,
        vote_average: row['voteAverage'] as double?,
        vote_count: row['voteCount'] as int?,
        popularity: row['popularity'] as double?,
        adult: (row['adult'] as int?) == 1,
        video: (row['video'] as int?) == 1,
        original_language: row['originalLanguage'] as String?,
        genre_ids: genreIds,
      );
    }).toList();
  }



 Future<Movie?> getBookmarkMovie(int id) async {
    final db = await database;
    final result = await db.query(
      'bookmark_movies',
      where: 'id = ?',
      whereArgs: [id],
    );
    
    if (result.isNotEmpty) {
      final row = result.first;
      final genreIdsString = row['genreIds'] as String?;
      List<int>? genreIds;
      if (genreIdsString != null) {
        genreIds = List<int>.from(jsonDecode(genreIdsString));
      }
      
      return Movie(
        id: row['id'] as int?,
        title: row['title'] as String?,
        original_title: row['originalTitle'] as String?,
        overview: row['overview'] as String?,
        poster_path: row['posterPath'] as String?,
        backdrop_path: row['backdropPath'] as String?,
        release_date: row['releaseDate'] as String?,
        vote_average: row['voteAverage'] as double?,
        vote_count: row['voteCount'] as int?,
        popularity: row['popularity'] as double?,
        adult: (row['adult'] as int?) == 1,
        video: (row['video'] as int?) == 1,
        original_language: row['originalLanguage'] as String?,
        genre_ids: genreIds,
      );
    }
    return null;
  }

  
  Future<void> deleteBookmarkMovie(int id) async {
    final db = await database;
    await db.delete(
      'bookmark_movies',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> clearAllMovies() async {
    final db = await database;
    await db.delete('movies');
  }

  Future<void> clearAllTrendingMovies() async {
    final db = await database;
    await db.delete('trending_movies');
  }

  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}