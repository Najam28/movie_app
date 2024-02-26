import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tmdb_movie_app/common/api_links.dart';
import 'package:tmdb_movie_app/util/slider.dart';

class Movies extends StatefulWidget {
  const Movies({super.key});

  @override
  State<Movies> createState() => _MoviesState();
}

class _MoviesState extends State<Movies> {
  List<Map<String, dynamic>> popularMovieSeries = [];
  List<Map<String, dynamic>> topRatedMovieSeries = [];
  List<Map<String, dynamic>> nowPlayingMovieSeries = [];
  List<Map<String, dynamic>> upComingMovieSeries = [];

  Future<void> movieSeriesFunction() async {
    var popularMovieResponse = await http.get(Uri.parse(popularMoviesUrl));
    if (popularMovieResponse.statusCode == 200) {
      var tempData = json.decode(popularMovieResponse.body);
      var popularityJson = tempData['results'];
      for (var i = 0; i < popularityJson.length; i++) {
        popularMovieSeries.add({
          "id": popularityJson[i]["id"],
          "name": popularityJson[i]["name"],
          "poster_path": popularityJson[i]["poster_path"],
          "vote_average": popularityJson[i]["vote_average"],
          "release_date": popularityJson[i]["release_date"],
        });
      }
    } else {
      throw Exception("Exception is ${popularMovieResponse.body}");
    }

    var topRatedMovieResponse = await http.get(Uri.parse(topRatedMoviesUrl));
    if (topRatedMovieResponse.statusCode == 200) {
      var tempData = json.decode(topRatedMovieResponse.body);
      var nowPlayingMovieJson = tempData['results'];
      for (var i = 0; i < nowPlayingMovieJson.length; i++) {
        topRatedMovieSeries.add({
          "id": nowPlayingMovieJson[i]["id"],
          "name": nowPlayingMovieJson[i]["name"],
          "poster_path": nowPlayingMovieJson[i]["poster_path"],
          "vote_average": nowPlayingMovieJson[i]["vote_average"],
          "release_date": nowPlayingMovieJson[i]["release_date"],
        });
      }
    } else {
      throw Exception("Exception is ${topRatedMovieResponse.body}");
    }

    var nowPlayingMovieResponse = await http.get(Uri.parse(topRatedMoviesUrl));
    if (nowPlayingMovieResponse.statusCode == 200) {
      var tempData = json.decode(nowPlayingMovieResponse.body);
      var nowPlayingJson = tempData['results'];
      for (var i = 0; i < nowPlayingJson.length; i++) {
        nowPlayingMovieSeries.add({
          "id": nowPlayingJson[i]["id"],
          "name": nowPlayingJson[i]["name"],
          "poster_path": nowPlayingJson[i]["poster_path"],
          "vote_average": nowPlayingJson[i]["vote_average"],
          "release_date": nowPlayingJson[i]["release_date"],
        });
      }
    } else {
      throw Exception("Exception is ${nowPlayingMovieResponse.body}");
    }

    var upComingMovieResponse = await http.get(Uri.parse(upComingMoviesUrl));
    if (upComingMovieResponse.statusCode == 200) {
      var tempData = json.decode(upComingMovieResponse.body);
      var upComingMovieJson = tempData['results'];
      for (var i = 0; i < upComingMovieJson.length; i++) {
        upComingMovieSeries.add({
          "id": upComingMovieJson[i]["id"],
          "name": upComingMovieJson[i]["name"],
          "poster_path": upComingMovieJson[i]["poster_path"],
          "vote_average": upComingMovieJson[i]["vote_average"],
          "release_date": upComingMovieJson[i]["release_date"],
        });
      }
    } else {
      throw Exception("Exception is ${upComingMovieResponse.body}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: movieSeriesFunction(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              sliderList(popularMovieSeries, "Popular TV Series", "movie", 20,
                  "release_date"),
              sliderList(nowPlayingMovieSeries, "Top Rated TV Series", "movie",
                  20, "release_date"),
              sliderList(topRatedMovieSeries, "Top Rated TV Series", "movie",
                  20, "release_date"),
              sliderList(upComingMovieSeries, "On Air TV Series", "movie", 20,
                  "release_date"),
            ],
          );
        } else {
          return Center(
            child: CircularProgressIndicator(color: Colors.amber.shade400),
          );
        }
      },
    );
  }
}
