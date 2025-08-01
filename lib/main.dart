import 'package:flutter/material.dart';
import 'package:flutter_application_1/movie_detail_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'home_screen.dart';
import 'view_model.dart';
void main() {

  runApp( MyApp());
}

class MyApp extends StatelessWidget {
   MyApp({super.key});


 final GoRouter _router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) =>   const HomeScreen(title: 'Home'),
      ),
      GoRoute(
        path: '/movie/:movie_id',
        builder: (context, state) {
          final movieIdStr = state.pathParameters['movie_id'];
          final movieId = int.tryParse(movieIdStr ?? '');
          if (movieId == null) {
            return const Scaffold(
              body: Center(child: Text('Invalid movie ID')),
            );
          }
          return MovieDetailScreen(movie_id: movieId);
        },
      ),
    ],
  );
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ViewModel()),
      ],
      child: 
      MaterialApp.router(
      routerConfig: _router,
       title: 'Movie App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 2, 199, 113),  )),
        
    ));
      
     
  
  }
}
