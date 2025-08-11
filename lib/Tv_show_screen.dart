import 'package:flutter/material.dart';

import 'API/favt_tv_show_api.dart';

class Favt_Tv_Show extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => Favt_Tv_Show_State();
}

class Favt_Tv_Show_State extends State<Favt_Tv_Show> {
  @override
  void initState() {
    super.initState();
    Favt_Tv_Show_Api.fetchShows();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Favt Tv Shows')),

      body: FutureBuilder(
        future: Favt_Tv_Show_Api.fetchShows(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          return ListView.builder(
            itemCount: snapshot.data!.results?.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  leading: Image.network(
                    'https://image.tmdb.org/t/p/w500${snapshot.data!.results![index].posterPath}',
                    width: 50,
                  ),
                  title: Text(
                    '${snapshot.data!.results![index].originalTitle}' ??
                        "no title",
                  ),
                  subtitle: Text(
                    "${snapshot.data!.results![index].overview}" ??
                        'no popularity',
                  ),
                  trailing: Text(
                    "${snapshot.data!.results![index].voteAverage?.toStringAsFixed(1) ?? "no rating"}",
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
