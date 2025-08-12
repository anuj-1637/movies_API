import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
          late String title;
          late String description;
          late String popularity;
          if (widget.listName == "Latest Movies") {
            imagurl =
                "https://image.tmdb.org/t/p/w500${movies[widget.index].posterPath}";
            title = movies[widget.index].title!;
            description = movies[widget.index].overview!;
            popularity = movies[widget.index].popularity!.toStringAsFixed(1);
          } else if (widget.listName == "Popular Movies") {
            imagurl =
                "https://image.tmdb.org/t/p/w500${discoverMovies[widget.index].posterPath}";
            title = discoverMovies[widget.index].title!;
            description = discoverMovies[widget.index].overview!;
            popularity = discoverMovies[widget.index].popularity!
                .toStringAsFixed(1);
          } else if (widget.listName == "Top Rated Movies") {
            imagurl =
                "https://image.tmdb.org/t/p/w500${movies[widget.index].posterPath}";
            title = movies[widget.index].title!;
            description = movies[widget.index].overview!;
            popularity = movies[widget.index].popularity!.toStringAsFixed(1);
          }

          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: "Movies",

                transitionOnUserGestures: true,
                child: Image.network(
                  imagurl,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.fill,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0.w),
                child: Text('$title', style: TextStyle(fontSize: 18.sp)),
              ),
              // SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('$description', style: TextStyle(fontSize: 14.sp)),
              ),
              // SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Popularity: $popularity',
                  style: TextStyle(fontSize: 14.sp),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
