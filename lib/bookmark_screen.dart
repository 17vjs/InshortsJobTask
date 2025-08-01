import 'package:flutter/material.dart';
import 'package:flutter_application_1/bookmark_movie_card.dart';
import 'package:flutter_application_1/view_model.dart';
import 'package:provider/provider.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({super.key});
  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  @override
  void initState() {
    super.initState();
   Future.microtask(
      () => Provider.of<ViewModel>(
        context,
        listen: false,
      ).getBookmarkMovies(),
    );   
  }

  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Bookmarks")
      ),
      body: Consumer<ViewModel>(
        builder: (context, viewModel, child) {
          return 
           SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: <Widget>[
          if (viewModel.bookmarkMoviesloading) ...[Center(child: CircularProgressIndicator())],
          if (viewModel.bookmarkMoviesError.isNotEmpty) ...[
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.red, // Set solid red background
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Colors.white, // White icon
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Couldn’t fetch latest data. Try again.",
                      style: TextStyle(
                        color: Colors.white, // White text
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.refresh,
                      color: Colors.white,
                    ), // White icon
                    tooltip: 'Retry',
                    splashRadius: 22,
                    onPressed: () {
                    
                        Future.microtask(
                          () => Provider.of<ViewModel>(
                            context,
                            listen: false,
                          ).getBookmarkMovies(),
                        );
                     
                    },
                  ),
                ],
              ),
            ),
          ],
          SizedBox(height: 18),
          if (viewModel.allBookmarkMovies.isNotEmpty) ...[
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: viewModel.allBookmarkMovies.length,
              itemBuilder: (context, index) {
                final movie = viewModel.allBookmarkMovies[index];
                return BookmarkMovieCard(movie: movie);
              },
            ),
          ]else Text("No Bookmarks yet..."),
        ],
      ),
    );
  
        },
      ),
    );
 
  }
}
