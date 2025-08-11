import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/movie_model.dart';

class Movies_Api {
  static Future<MoviesModel> fetchMovies() async {
    final url =
        "https://api.themoviedb.org/3/movie/popular?api_key=2161dc6e0c1c24b144896c952175288e";

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data);
      return MoviesModel.fromJson(data);
    } else {
      throw Exception("Failed to load movies");
    }
  }
}
