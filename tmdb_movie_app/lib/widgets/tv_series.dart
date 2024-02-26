import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tmdb_movie_app/common/api_links.dart';
import 'package:tmdb_movie_app/util/slider.dart';

class TvSeries extends StatefulWidget {
  const TvSeries({super.key});

  @override
  State<TvSeries> createState() => _TvSeriesState();
}

class _TvSeriesState extends State<TvSeries> {
  List<Map<String, dynamic>> popularTvSeries = [];
  List<Map<String, dynamic>> topRatedTvSeries = [];
  List<Map<String, dynamic>> onAirTvSeries = [];

  Future<void> tvSeriesFunction() async {
    var popularTvResponse = await http.get(Uri.parse(popularTvSeriesUrl));
    if (popularTvResponse.statusCode == 200) {
      var tempData = json.decode(popularTvResponse.body);
      var popularityJson = tempData['results'];
      for (var i = 0; i < popularityJson.length; i++) {
        popularTvSeries.add({
          "id": popularityJson[i]["id"],
          "name": popularityJson[i]["name"],
          "poster_path": popularityJson[i]["poster_path"],
          "vote_average": popularityJson[i]["vote_average"],
          "first_air_date": popularityJson[i]["first_air_date"],
        });
      }
    } else {
      throw Exception("Exception is ${popularTvResponse.body}");
    }

    var topRatedTvResponse = await http.get(Uri.parse(topRatedTvSeriesUrl));
    if (topRatedTvResponse.statusCode == 200) {
      var tempData = json.decode(topRatedTvResponse.body);
      var topRatedJson = tempData['results'];
      for (var i = 0; i < topRatedJson.length; i++) {
        topRatedTvSeries.add({
          "id": topRatedJson[i]["id"],
          "name": topRatedJson[i]["name"],
          "poster_path": topRatedJson[i]["poster_path"],
          "vote_average": topRatedJson[i]["vote_average"],
          "first_air_date": topRatedJson[i]["first_air_date"],
        });
      }
    } else {
      throw Exception("Exception is ${topRatedTvResponse.body}");
    }

    var onAirTvResponse = await http.get(Uri.parse(onAirTvSeriesUrl));
    if (onAirTvResponse.statusCode == 200) {
      var tempData = json.decode(onAirTvResponse.body);
      var onAirJson = tempData['results'];
      for (var i = 0; i < onAirJson.length; i++) {
        onAirTvSeries.add({
          "id": onAirJson[i]["id"],
          "name": onAirJson[i]["name"],
          "poster_path": onAirJson[i]["poster_path"],
          "vote_average": onAirJson[i]["vote_average"],
          "first_air_date": onAirJson[i]["first_air_date"],
        });
      }
    } else {
      throw Exception("Exception is ${onAirTvResponse.body}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: tvSeriesFunction(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              sliderList(popularTvSeries, "Popular TV Series", "tv", 20,
                  "first_air_date"),
              sliderList(topRatedTvSeries, "Top Rated TV Series", "tv", 20,
                  "first_air_date"),
              sliderList(onAirTvSeries, "On Air TV Series", "tv", 20,
                  "first_air_date"),
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
