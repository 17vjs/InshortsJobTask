import 'package:flutter/material.dart';
import 'package:flutter_application_1/api_service.dart';
import 'package:flutter_application_1/view_model.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class MovieDetailScreen extends StatefulWidget {
  final Movie? movie;
  final int? movie_id;
  const MovieDetailScreen({Key? key, this.movie, this.movie_id})
    : super(key: key);

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  late Movie? movie;
  bool isLoading = false;
  String? error;
  @override
  void initState() {
    super.initState();

    if (widget.movie != null) {
      // If movie is passed directly, use it
      movie = widget.movie!;
      fetchBookMarkState();
    } else {
      // Otherwise, fetch movie details by ID
      movie = null;
      _fetchMovieDetails();
    }
  }

  Future<void> _fetchMovieDetails() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      // Replace this with your actual fetch logic, for example:
      final fetchedMovie = await Provider.of<ViewModel>(
        context,
        listen: false,
      ).fetchMovie(widget.movie_id ?? -1);
      setState(() {
        movie = fetchedMovie;
      });
      fetchBookMarkState();
    } catch (e) {
      setState(() {
        error = 'Failed to load movie details.';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _shareMovie() {
    final deepLink = 'my_movie_app://movie/${movie!.id}';
    SharePlus.instance.share(
      ShareParams(text: 'Check out this movie: $deepLink'),
    );
  }

  Future<void> fetchBookMarkState() async {
    bool isBookMarked = await Provider.of<ViewModel>(
      context,
      listen: false,
    ).isBookMarked(movie!.id ?? -1);
    setState(() {
      movie!.isBookMarked = isBookMarked;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (movie == null || isLoading) {
      return Center(child: CircularProgressIndicator());
    } else if (error != null && error!.isNotEmpty) {
      return Center(child: Text(error!));
    }
    final releaseDate =
        movie!.release_date != null && movie!.release_date!.isNotEmpty
        ? DateFormat('d MMMM y').format(DateTime.parse(movie!.release_date!))
        : 'Unknown';

    return Consumer<ViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.white),
            actions: [
              IconButton(
                icon: Icon(Icons.share, color: Colors.white),
                onPressed: () {
                  _shareMovie();
                },
                tooltip: "Share",
              ),

              IconButton(
                icon: Icon(
                  movie!.isBookMarked == true
                      ? Icons.bookmark
                      : Icons.bookmark_border,
                  color: Colors.white,
                ),
                onPressed: () {
                  if (movie!.isBookMarked ?? false) {
                    viewModel.removeBookmark(movie!.id ?? -1);
                  } else {
                    viewModel.addBookmark(movie!);
                  }
                },
                tooltip: "Bookmark",
              ),
            ],
          ),
          extendBodyBehindAppBar: true,
          body: ListView(
            padding: EdgeInsets.zero,
            children: [
              Stack(
                alignment: Alignment.bottomLeft,
                children: [
                  // Movie poster
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(36),
                    ),
                    child: Image.network(
                      'https://image.tmdb.org/t/p/w780${movie!.poster_path}',
                      width: double.infinity,
                      height: 420,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stack) => Container(
                        color: Colors.grey[700],
                        height: 420,
                        child: const Center(
                          child: Icon(
                            Icons.broken_image,
                            color: Colors.white30,
                            size: 60,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Gradient for text readability
                  Container(
                    height: 140,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black87],
                      ),
                    ),
                  ),
                  // Movie title and rating
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Text(
                            movie!.title ?? 'No Title',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                              shadows: [
                                Shadow(
                                  blurRadius: 12,
                                  color: Colors.black87,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.white,
                                size: 20,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                (movie!.vote_average ?? 0).toStringAsFixed(1),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // Movie details
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Genres, release date, language
                    Wrap(
                      children: [
                        Chip(
                          label: Text(
                            "Release: $releaseDate",
                            style: const TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Colors.blueGrey[700],
                        ),
                        const SizedBox(width: 10),
                        Chip(
                          label: Text(
                            "Language: ${movie!.original_language?.toUpperCase() ?? '-'}",
                            style: const TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Colors.blueGrey[700],
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Overview
                    const Text(
                      'Overview',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      movie!.overview?.isNotEmpty == true
                          ? movie!.overview!
                          : 'No description available.',
                      style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      children: [
                        Icon(Icons.people, color: Colors.white54),
                        const SizedBox(width: 6),
                        Text(
                          '${movie!.vote_count ?? 0} votes',
                          style: const TextStyle(
                            color: Colors.white60,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
