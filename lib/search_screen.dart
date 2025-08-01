import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/api_service.dart';
import 'package:flutter_application_1/view_model.dart';
import 'package:flutter_application_1/movie_poster_card.dart';
import 'package:provider/provider.dart';
class MovieSearchScreen extends StatefulWidget {
  @override
  _MovieSearchScreenState createState() => _MovieSearchScreenState();
}

class _MovieSearchScreenState extends State<MovieSearchScreen> {
  List<Movie> searchResults = [];
  Timer? _debounce;
  String _currentQuery = "";
  bool _isLoading = false;

  void _onSearchChanged(String query) {
    setState(() {
      _currentQuery = query;
    });

    if (_debounce?.isActive ?? false) _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds:600), () async {
      if (query.isNotEmpty) {
        setState(() {
          _isLoading = true;
        });
        final results =     await Provider.of<ViewModel>(
        context,
        listen: false,
      ).searchMovie(query)
     ;
        setState(() {
          searchResults = results;
          _isLoading = false;
        });
      } else {
        setState(() {
          searchResults = [];
        });
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Movie Search")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search Movies...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: _onSearchChanged,
            ),
          ),
          if (_isLoading) LinearProgressIndicator(),
          Expanded(
            child: searchResults.isEmpty && _currentQuery.isNotEmpty && !_isLoading
                ? Center(child: Text("No results found."))
                : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView.builder(
                    
                      itemCount: searchResults.length,
                      itemBuilder: (context, index) {
                        return MoviePosterCard(movie: searchResults[index]);
                      },
                    ),
                ),
          ),
        ],
      ),
    );
  }
}