import 'package:flutter/material.dart';
import 'package:flutter_application_1/bookmark_screen.dart';
import 'package:flutter_application_1/movie_poster_card.dart';
import 'package:flutter_application_1/search_screen.dart';
import 'package:provider/provider.dart';
import 'view_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});
  final String title;
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    Future.microtask(
      () => Provider.of<ViewModel>(
        context,
        listen: false,
      ).fetchPlayingNowMovies(),
    );
    Future.microtask(
      () => Provider.of<ViewModel>(
        context,
        listen: false,
      ).fetchTrendingMovies(),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        bottom: TabBar(
          controller: _tabController,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          tabs: const [
            Tab(text: 'Now Playing'),
            Tab(text: 'Trending'),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.bookmark),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BookmarkScreen()),
            ),
          ),
           IconButton(
            icon: Icon(Icons.search),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MovieSearchScreen()),
            ),
          ),
        ],
      ),
      body: Consumer<ViewModel>(
        builder: (context, viewModel, child) {
          return TabBarView(
            controller: _tabController,
            children: [
              TabSectionView(
                index: 0,
                loading: viewModel.playingNowMoviesloading,
                error: viewModel.playingNowMoviesError,
                movies: viewModel.allPlayingNowMovies,
              ),
              TabSectionView(
                index: 1,

                loading: viewModel.trendingMoviesloading,
                error: viewModel.trendingMoviesError,

                movies: viewModel.allTrendingMovies,
              ),
            ],
          );
        },
      ),
    );
  }
}

class TabSectionView extends StatelessWidget {
  const TabSectionView({
    super.key,
    required this.index,
    required this.error,
    required this.loading,
    required this.movies,
  });
  final int index;
  final String error;
  final bool loading;
  final List movies;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: <Widget>[
          if (loading) ...[Center(child: CircularProgressIndicator())],
          if (error.isNotEmpty) ...[
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
                      if (index == 0) {
                        Future.microtask(
                          () => Provider.of<ViewModel>(
                            context,
                            listen: false,
                          ).fetchPlayingNowMovies(),
                        );
                      } else {
                        Future.microtask(
                          () => Provider.of<ViewModel>(
                            context,
                            listen: false,
                          ).fetchTrendingMovies(),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
          SizedBox(height: 18),
          if (movies.isNotEmpty) ...[
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: movies.length,
              itemBuilder: (context, index) {
                final movie = movies[index];
                return MoviePosterCard(movie: movie);
              },
            ),
          ],
        ],
      ),
    );
  }
}
