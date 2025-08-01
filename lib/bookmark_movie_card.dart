import 'package:flutter/material.dart';
import 'package:flutter_application_1/api_service.dart';
import 'package:flutter_application_1/movie_detail_screen.dart';

class BookmarkMovieCard extends StatelessWidget {
  final Movie movie;

  const BookmarkMovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    movie.isBookMarked = true;

    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MovieDetailScreen(movie: movie),
        ),
      ),
      child: Center(
        child: Card(
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            height: 120,
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Small Poster
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: AspectRatio(
                    aspectRatio: 2 / 3,
                    child: Image.network(
                      "https://media.themoviedb.org/t/p/w154${movie.poster_path}",
                      fit: BoxFit.cover,
                      width: 80,
                      height: 120,
                      errorBuilder: (context, error, stack) => Container(
                        width: 80,
                        height: 120,
                        color: Colors.grey[300],
                        child: const Icon(
                          Icons.movie,
                          size: 40,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Movie Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Title
                      Text(
                        movie.title ?? "",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Description (subtitle or overview)
                      Text(
                        movie.overview ?? "No description available.",
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
