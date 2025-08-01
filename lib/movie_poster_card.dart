import 'package:flutter/material.dart';
import 'package:flutter_application_1/api_service.dart';
import 'package:flutter_application_1/view_model.dart';
import 'package:flutter_application_1/movie_detail_screen.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MoviePosterCard extends StatefulWidget {
  final Movie movie;

  const MoviePosterCard({super.key, required this.movie});

  @override
  State<MoviePosterCard> createState() => _MoviePosterCardState();
}

class _MoviePosterCardState extends State<MoviePosterCard> {
  Future<void> fetchBookMarkState() async {
    bool isBookMarked = await Provider.of<ViewModel>(
      context,
      listen: false,
    ).isBookMarked(widget.movie.id ?? -1);
    setState(() {
      widget.movie.isBookMarked = isBookMarked;
    });
  }
@override
  void initState() {
    super.initState();
    fetchBookMarkState();
    
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<ViewModel>(
      builder: (context, viewModel, child) {
        return InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MovieDetailScreen(movie: widget.movie),
            ),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Material(
                  elevation: 8,
                  borderRadius: BorderRadius.circular(18),
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    clipBehavior: Clip.none,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: AspectRatio(
                          aspectRatio: 2 / 3,
                          child: Image.network(
                            "https://media.themoviedb.org/t/p/w440_and_h660_face${widget.movie.poster_path}",
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stack) => Container(
                              color: Colors.grey[300],
                              child: const Icon(
                                Icons.movie,
                                size: 56,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 12,
                        right: 12,
                        child: Material(
                          color: Colors.black,
                          elevation: 3,
                          borderRadius: BorderRadius.circular(50),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(50),
                            onTap: () async {
                              if (widget.movie.isBookMarked ?? false) {
                                viewModel.removeBookmark(widget.movie.id ?? -1);
                              } else {
                                viewModel.addBookmark(widget.movie);
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                !(widget.movie.isBookMarked ?? false)
                                    ? Icons.bookmark_border
                                    : Icons
                                          .bookmark, // use Icons.bookmark for filled state
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Dark gradient at bottom for readable overlay
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Container(
                          height: 200,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.vertical(
                              bottom: Radius.circular(18),
                            ),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.77),
                                Colors.black87,
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Rating badge
                      // Title and availability overlay
                      Positioned(
                        bottom: 22,
                        left: 0,
                        right: 0,
                        child: Column(
                          children: [
                            Text(
                              widget.movie.title ?? "",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 16,
                                letterSpacing: 2,
                                shadows: [
                                  Shadow(
                                    blurRadius: 6,
                                    color: Colors.black54,
                                    offset: Offset(1, 2),
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.star,
                                        color: Colors.yellow,
                                        size: 15,
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        (widget.movie.vote_average ?? 0)
                                            .toStringAsFixed(2),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                          letterSpacing: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  "   |   ${DateFormat('d MMMM y').format(DateTime.parse(widget.movie.release_date ?? ""))}",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 32),
              ],
            ),
          ),
        );
      },
    );
  }
}
