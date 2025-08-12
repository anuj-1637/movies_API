import 'package:flutter/material.dart';

import '../API/movie_api.dart';
import '../model/discover_movie_model.dart';

class Movies_Play_Screeen extends StatefulWidget {
  late int index;
  late String listName;
  Movies_Play_Screeen({required this.index, required this.listName});
  @override
  State<StatefulWidget> createState() => Movies_Play_ScreeenState();
}

class Movies_Play_ScreeenState extends State<Movies_Play_Screeen> {
  late Future<List<dynamic>> _allDataFuture;
  void initState() {
    super.initState();
    _allDataFuture = Future.wait([
      Movies_Api.fetchMovies(),
      Movies_Api.fetchDiscoverMovies(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    print(widget.index);
    return Scaffold(
      body: FutureBuilder(
        future: _allDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          final movies = snapshot.data![0].results ?? [] as List<Results>;
          final discoverMovies =
              snapshot.data![1].results ?? [] as List<discoverMovie>;

          late String imagurl;
          if (widget.listName == "Latest Movies") {
            imagurl =
                "https://image.tmdb.org/t/p/w500${movies[widget.index].posterPath}";
          } else if (widget.listName == "Popular Movies") {
            imagurl =
                "https://image.tmdb.org/t/p/w500${discoverMovies[widget.index].posterPath}";
          } else if (widget.listName == "Top Rated Movies") {
            imagurl =
                "https://image.tmdb.org/t/p/w500${movies[widget.index].posterPath}";
          }

          return Hero(
            tag: "Movies",

            transitionOnUserGestures: true,
            child: Image.network(
              imagurl,
              width: double.infinity,
              height: 200,
              fit: BoxFit.fill,
            ),
          );
        },
      ),
    );
  }
}
