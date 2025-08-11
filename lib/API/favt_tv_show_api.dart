import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/favt_tv_show_model.dart';

class Favt_Tv_Show_Api {
  static Future<FavtTvShowModel> fetchShows() async {
    final url =
        "https://api.themoviedb.org/3/tv/popular?api_key=2161dc6e0c1c24b144896c952175288e";

    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return FavtTvShowModel.fromJson(data);
    }
    throw Exception("Failed to load movies");
  }
}
