import 'dart:convert';

import 'package:api_project/Screens/movie_app.dart';
import 'package:api_project/model/newsmodel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NewsApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => NewsAppState();
}

class NewsAppState extends State<NewsApp> {
  Future<newsModel> fetchNews() async {
    final url =
        "https://newsapi.org/v2/everything?q=tesla&from=2025-07-04&sortBy=publishedAt&apiKey=cd3132d752a441479d7814bbfcd60f23";

    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      return newsModel.fromJson(result);
    } else {
      throw Exception("Failed to load news");
    }
  }

  void initState() {
    super.initState();
    fetchNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("News App"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MoviesApp()),
              );
            },
            icon: Icon(Icons.movie_sharp),
          ),
        ],
      ),
      body: FutureBuilder(
        future: fetchNews(),
        builder: (context, snapShoot) {
          if (snapShoot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapShoot.hasError) {
            return Center(child: Text("Error: ${snapShoot.error}"));
          } else if (!snapShoot.hasData || snapShoot.data!.articles == null) {
            return Center(child: Text("No data available."));
          }
          return ListView.builder(
            itemCount: snapShoot.data!.articles!.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(
                    "${snapShoot.data!.articles![index].urlToImage}",
                  ),
                ),
                title: Text("${snapShoot.data!.articles![index].title}"),
                subtitle: Text(
                  "${snapShoot.data!.articles![index].description}",
                ),
              );
            },
          );
        },
      ),
    );
  }
}
