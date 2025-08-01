import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:json_annotation/json_annotation.dart';

part 'api_service.g.dart';

@RestApi(baseUrl: "https://api.themoviedb.org/3/")
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  @GET("movie/now_playing")
  Future<MovieResponse> getNowPlayingMovies(
    @Query("language") String language,
    @Query("page") int page, {
    @Query("api_key") String api_key = "ff158e05b28644b68f847cbfc05eb30e",
  });
  @GET("trending/movie/day")
  Future<MovieResponse> getTrendingMovies(
    @Query("language") String language,
    @Query("page") int page, {
    @Query("api_key") String api_key = "ff158e05b28644b68f847cbfc05eb30e",
  });
  @GET("search/movie")
  Future<MovieResponse> searchMovie(
    @Query("query") String query,
    @Query("language") String language,
    @Query("page") int page, {
    @Query("api_key") String api_key = "ff158e05b28644b68f847cbfc05eb30e",
  });
  @GET("movie/{movie_id}")
  Future<Movie> fetchMovie(
    @Path("movie_id") int movie_id,
    @Query("language") String language, {
    @Query("api_key") String api_key = "ff158e05b28644b68f847cbfc05eb30e",
  });
}

@JsonSerializable()
class MovieResponse {
  final Dates? dates;
  final int? page;
  final List<Movie>? results;
  final int? total_pages;
  final int? total_results;

  MovieResponse({
    this.dates,
    this.page,
    this.results,
    this.total_pages,
    this.total_results,
  });

  factory MovieResponse.fromJson(Map<String, dynamic> json) =>
      _$MovieResponseFromJson(json);
  Map<String, dynamic> toJson() => _$MovieResponseToJson(this);
}

@JsonSerializable()
class Dates {
  final String? maximum;
  final String? minimum;

  Dates({this.maximum, this.minimum});

  factory Dates.fromJson(Map<String, dynamic> json) => _$DatesFromJson(json);
  Map<String, dynamic> toJson() => _$DatesToJson(this);
}

@JsonSerializable()
class Movie {
  final bool? adult;
  final String? backdrop_path;
  final List<int>? genre_ids;
  final int? id;
  final String? original_language;
  final String? original_title;
  final String? overview;
  final double? popularity;
  final String? poster_path;
  final String? release_date;
  final String? title;
  final bool? video;
  final double? vote_average;
  final int? vote_count;
  bool? isBookMarked;

  Movie({
    this.adult,
    this.backdrop_path,
    this.genre_ids,
    this.id,
    this.original_language,
    this.original_title,
    this.overview,
    this.popularity,
    this.poster_path,
    this.release_date,
    this.title,
    this.video,
    this.vote_average,
    this.vote_count,
    this.isBookMarked,
  });

  factory Movie.fromJson(Map<String, dynamic> json) => _$MovieFromJson(json);
  Map<String, dynamic> toJson() => _$MovieToJson(this);
}
