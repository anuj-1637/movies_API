import 'package:api_project/API/movie_api.dart';
import 'package:api_project/model/discover_movie_model.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:intl/intl.dart';
import 'package:intl/intl.dart';

class MoviesApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MoviesAppState();
}

class MoviesAppState extends State<MoviesApp> {
  late Future<List<dynamic>> _allDataFuture;

  String formatDate(String rawDate) {
    final parsedDate = DateTime.tryParse(rawDate);
    if (parsedDate == null) return "Invalid date";
    return DateFormat('d MMM y').format(parsedDate); // Output: 1 Aug 2025
  }

  late var count = 0;

  void initState() {
    super.initState();
    _allDataFuture = Future.wait([
      Movies_Api.fetchMovies(),
      Movies_Api.fetchDiscoverMovies(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(" Aks Movies", style: TextStyle(fontSize: 20.sp)),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: _allDataFuture,
          builder: (context, snapShot) {
            if (snapShot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapShot.hasError) {
              return Center(child: Text("Error: ${snapShot.error}"));
            }
            ;
            var movies = snapShot.data![0].results ?? [] as List<Results>;
            var discoverMovies =
                snapShot.data![1].results ?? [] as List<discoverMovie>;

            List<dynamic> LatestMovies = movies
                .map((m) => "https://image.tmdb.org/t/p/w500${m.posterPath}")
                .toList();

            List<dynamic> PopularMovies = discoverMovies
                .map((m) => "https://image.tmdb.org/t/p/w500${m.posterPath}")
                .toList();
            List<dynamic> TopRatedMovies = movies
                .map((m) => "https://image.tmdb.org/t/p/w500${m.posterPath}")
                .toList();

            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CarouselSlider.builder(
                  itemCount: movies.length,
                  itemBuilder: (context, index, realindex) {
                    final movie = movies[index];
                    return Container(
                      width: double.infinity,
                      child: Image.network(
                        "https://image.tmdb.org/t/p/w500${movie.posterPath}",
                        width: double.infinity,
                        fit: BoxFit.fill,
                      ),
                    );
                  },
                  options: CarouselOptions(
                    height: 190.0.h,
                    enlargeCenterPage: false,
                    autoPlay: true,
                    autoPlayAnimationDuration: Duration(seconds: 2),
                    aspectRatio: 16 / 9,
                    viewportFraction: 1.0,
                  ),
                ),
                SizedBox(height: 20),
                sectionMovie(LatestMovies, "Latest Movies"),
                // SizedBox(height: 20),
                sectionMovie(PopularMovies, "Popular Movies"),
                // SizedBox(height: 20),
                sectionMovie(TopRatedMovies, "Top Rated Movies"),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget sectionMovie(List<dynamic> moviesList, String? title) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title',
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10.h),
          SizedBox(
            height: 120.h,
            child: ListView.separated(
              itemCount: moviesList.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(
                      moviesList[index],
                      width: 100.w,
                      height: 100.h,
                      fit: BoxFit.fill,
                    ),
                  ],
                );
              },
              separatorBuilder: (context, index) => SizedBox(width: 10.w),
            ),
          ),
        ],
      ),
    );
  }
}
