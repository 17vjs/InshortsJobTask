// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_service.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieResponse _$MovieResponseFromJson(Map<String, dynamic> json) =>
    MovieResponse(
      dates: json['dates'] == null
          ? null
          : Dates.fromJson(json['dates'] as Map<String, dynamic>),
      page: (json['page'] as num?)?.toInt(),
      results: (json['results'] as List<dynamic>?)
          ?.map((e) => Movie.fromJson(e as Map<String, dynamic>))
          .toList(),
      total_pages: (json['total_pages'] as num?)?.toInt(),
      total_results: (json['total_results'] as num?)?.toInt(),
    );

Map<String, dynamic> _$MovieResponseToJson(MovieResponse instance) =>
    <String, dynamic>{
      'dates': instance.dates,
      'page': instance.page,
      'results': instance.results,
      'total_pages': instance.total_pages,
      'total_results': instance.total_results,
    };

Dates _$DatesFromJson(Map<String, dynamic> json) => Dates(
  maximum: json['maximum'] as String?,
  minimum: json['minimum'] as String?,
);

Map<String, dynamic> _$DatesToJson(Dates instance) => <String, dynamic>{
  'maximum': instance.maximum,
  'minimum': instance.minimum,
};

Movie _$MovieFromJson(Map<String, dynamic> json) => Movie(
  adult: json['adult'] as bool?,
  backdrop_path: json['backdrop_path'] as String?,
  genre_ids: (json['genre_ids'] as List<dynamic>?)
      ?.map((e) => (e as num).toInt())
      .toList(),
  id: (json['id'] as num?)?.toInt(),
  original_language: json['original_language'] as String?,
  original_title: json['original_title'] as String?,
  overview: json['overview'] as String?,
  popularity: (json['popularity'] as num?)?.toDouble(),
  poster_path: json['poster_path'] as String?,
  release_date: json['release_date'] as String?,
  title: json['title'] as String?,
  video: json['video'] as bool?,
  vote_average: (json['vote_average'] as num?)?.toDouble(),
  vote_count: (json['vote_count'] as num?)?.toInt(),
  isBookMarked: json['isBookMarked'] as bool?,
);

Map<String, dynamic> _$MovieToJson(Movie instance) => <String, dynamic>{
  'adult': instance.adult,
  'backdrop_path': instance.backdrop_path,
  'genre_ids': instance.genre_ids,
  'id': instance.id,
  'original_language': instance.original_language,
  'original_title': instance.original_title,
  'overview': instance.overview,
  'popularity': instance.popularity,
  'poster_path': instance.poster_path,
  'release_date': instance.release_date,
  'title': instance.title,
  'video': instance.video,
  'vote_average': instance.vote_average,
  'vote_count': instance.vote_count,
  'isBookMarked': instance.isBookMarked,
};

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers,unused_element,unnecessary_string_interpolations,unused_element_parameter

class _ApiService implements ApiService {
  _ApiService(this._dio, {this.baseUrl, this.errorLogger}) {
    baseUrl ??= 'https://api.themoviedb.org/3/';
  }

  final Dio _dio;

  String? baseUrl;

  final ParseErrorLogger? errorLogger;

  @override
  Future<MovieResponse> getNowPlayingMovies(
    String language,
    int page, {
    String api_key = "ff158e05b28644b68f847cbfc05eb30e",
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'language': language,
      r'page': page,
      r'api_key': api_key,
    };
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<MovieResponse>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            'movie/now_playing',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late MovieResponse _value;
    try {
      _value = MovieResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<MovieResponse> getTrendingMovies(
    String language,
    int page, {
    String api_key = "ff158e05b28644b68f847cbfc05eb30e",
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'language': language,
      r'page': page,
      r'api_key': api_key,
    };
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<MovieResponse>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            'trending/movie/day',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late MovieResponse _value;
    try {
      _value = MovieResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<MovieResponse> searchMovie(
    String query,
    String language,
    int page, {
    String api_key = "ff158e05b28644b68f847cbfc05eb30e",
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'query': query,
      r'language': language,
      r'page': page,
      r'api_key': api_key,
    };
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<MovieResponse>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            'search/movie',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late MovieResponse _value;
    try {
      _value = MovieResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Movie> fetchMovie(
    int movie_id,
    String language, {
    String api_key = "ff158e05b28644b68f847cbfc05eb30e",
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'language': language,
      r'api_key': api_key,
    };
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<Movie>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            'movie/${movie_id}',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late Movie _value;
    try {
      _value = Movie.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }

  String _combineBaseUrls(String dioBaseUrl, String? baseUrl) {
    if (baseUrl == null || baseUrl.trim().isEmpty) {
      return dioBaseUrl;
    }

    final url = Uri.parse(baseUrl);

    if (url.isAbsolute) {
      return url.toString();
    }

    return Uri.parse(dioBaseUrl).resolveUri(url).toString();
  }
}
