import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tmdb_movie_app/key/api_key.dart';
import 'package:http/http.dart' as http;
import 'package:tmdb_movie_app/screens/home_page.dart';
import 'package:tmdb_movie_app/util/slider.dart';

class MovieDetails extends StatefulWidget {
  const MovieDetails({super.key, this.movieId});
  final movieId;

  @override
  State<MovieDetails> createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails> {
  List<Map<String, dynamic>> movieDetails = [];
  List<Map<String, dynamic>> userReview = [];
  List<Map<String, dynamic>> similarMovieList = [];
  List<Map<String, dynamic>> recommendedMoviesList = [];
  List<Map<String, dynamic>> movieTrailersList = [];

  List moviesGenres = [];

  Future<void> moviesDetails() async {
    var movieDetailsUrl = "$baseUrl/movie/${widget.movieId}?api_key=$apiKey";
    var userReviewUrl =
        "$baseUrl/movie/${widget.movieId}/reviews?api_key=$apiKey";
    var similarMovieListUrl =
        "$baseUrl/movie/${widget.movieId}/similar?api_key=$apiKey";
    var recommendedMoviesListUrl =
        "$baseUrl/movie/${widget.movieId}/recommendations?api_key=$apiKey";
    var movieTrailersListUrl =
        "$baseUrl/movie/${widget.movieId}/videos?api_key=$apiKey";

    var movieDetailResponse = await http.get(Uri.parse(movieDetailsUrl));
    if (movieDetailResponse.statusCode == 200) {
      var movieDetailJson = json.decode(movieDetailResponse.body);
      for (var i = 0; i < 1; i++) {
        movieDetails.add({
          "backdrop_path": movieDetailJson["backdrop_path"],
          "title": movieDetailJson["title"],
          "vote_average": movieDetailJson["vote_average"],
          "overview": movieDetailJson["overview"],
          "release_date": movieDetailJson["release_date"],
          "runtime": movieDetailJson["runtime"],
          "budget": movieDetailJson["budget"],
          "revenue": movieDetailJson["revenue"],
        });
      }
      for (var i = 0; i < movieDetailJson['genres'].length; i++) {
        moviesGenres.add(movieDetailJson['genres'][i]['name']);
      }
    } else {}

    var userReviewResponse = await http.get(Uri.parse(userReviewUrl));
    if (userReviewResponse.statusCode == 200) {
      var userReviewJson = json.decode(userReviewResponse.body);
      for (var i = 0; i < userReviewJson['results'][i].length; i++) {
        userReview.add({
          "name": userReviewJson['results'][i]["author"],
          "content": userReviewJson['results'][i]["content"],
          "rating":
              userReviewJson['results'][i]["author_details"]["rating"] == null
                  ? "Not Rated"
                  : userReviewJson['results'][i]["author_details"]["rating"]
                      .toString(),
          "avatar_photo": userReviewJson['results'][i]['author_details']
                      ["avatar_path"] ==
                  null
              ? "Not Photo"
              : "https://image.tmdb.org/t/p/w500${userReviewJson['results'][i]["author_details"]["avatar_path"]}",
          "created_at":
              userReviewJson['results'][i]["created_at"].substring(0, 10),
          "url": userReviewJson['results'][i]["url"],
        });
      }
    } else {}

    var similarMovieResponse = await http.get(Uri.parse(similarMovieListUrl));
    if (similarMovieResponse.statusCode == 200) {
      var similarMovieJson = json.decode(similarMovieResponse.body);
      for (var i = 0; i < similarMovieJson['results'].length; i++) {
        similarMovieList.add({
          "poster_path": similarMovieJson['results'][i]["poster_path"],
          "title": similarMovieJson['results'][i]['title'],
          "vote_average": similarMovieJson['results'][i]["vote_average"],
          "release_date": similarMovieJson['results'][i]["release_date"],
          "id": similarMovieJson['results'][i]["id"],
        });
      }
    } else {}

    var recommendedMovieResponse =
        await http.get(Uri.parse(recommendedMoviesListUrl));
    if (recommendedMovieResponse.statusCode == 200) {
      var reommendedMovieJson = json.decode(recommendedMovieResponse.body);
      for (var i = 0; i < reommendedMovieJson["results"].length; i++) {
        recommendedMoviesList.add({
          "poster_path": reommendedMovieJson['results'][i]["poster_path"],
          "title": reommendedMovieJson['results'][i]['title'],
          "vote_average": reommendedMovieJson['results'][i]["vote_average"],
          "release_date": reommendedMovieJson['results'][i]["release_date"],
          "id": reommendedMovieJson['results'][i]["id"],
        });
      }
    } else {}

    var movieTrailerResponse = await http.get(Uri.parse(movieTrailersListUrl));
    if (movieTrailerResponse.statusCode == 200) {
      var movieTrailersJson = json.decode(movieTrailerResponse.body);
      for (var i = 0; i < movieTrailersJson['results'].length; i++) {
        if (movieTrailersJson['results'][i]['type'] == 'Trailer') {
          movieTrailersList.add({
            "key": movieTrailersJson['results'][i]['key'],
          });
        }
      }
      movieTrailersList.add({
        "key": "aJ0cZTcTh90",
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(14, 14, 14, 1),
      body: FutureBuilder(
        future: moviesDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  leading: IconButton(
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => const HomePage(),
                          ),
                          (route) => false);
                    },
                    icon: const Icon(FontAwesomeIcons.circleArrowLeft),
                    color: Colors.white,
                    iconSize: 28,
                  ),
                  actions: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => const HomePage(),
                            ),
                            (route) => false);
                      },
                      icon: const Icon(FontAwesomeIcons.houseUser),
                      iconSize: 25,
                      color: Colors.white,
                    )
                  ],
                  backgroundColor: const Color.fromRGBO(18, 18, 18, 0.5),
                  centerTitle: false,
                  pinned: true,
                  expandedHeight: MediaQuery.of(context).size.height * 0.4,
                  flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.parallax,
                    background: FittedBox(
                      fit: BoxFit.fill,
                      // child: trailerWatch(
                      //   trailerId: movieTrailersList[0]['key'],
                      // ),
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                padding:
                                    const EdgeInsets.only(left: 10, top: 10),
                                height: 50,
                                width: MediaQuery.of(context).size.width,
                                child: ListView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  itemCount: moviesGenres.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      margin: const EdgeInsets.only(right: 10),
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color:
                                            const Color.fromRGBO(25, 25, 25, 1),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(moviesGenres[index]),
                                    );
                                  },
                                ),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                margin:
                                    const EdgeInsets.only(left: 10, right: 10),
                                height: 40,
                                decoration: BoxDecoration(
                                  color: const Color.fromRGBO(25, 25, 25, 1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                // child:
                                //     Text("${moviesGenres[0]['runtime']} min"),
                              )
                            ],
                          )
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 20, top: 10),
                        child: Text("Movie Story:"),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, top: 10),
                        child: Text("${movieDetails[0]['overview']}"),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, top: 10),
                        // child: reviewUI(rewDetails: userReview),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, top: 10),
                        child: Text(
                            "Release Date: ${movieDetails[0]['release_date']}"),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, top: 10),
                        child: Text("Budget: ${movieDetails[0]['budget']}"),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, top: 10),
                        child: Text("Revenue: ${movieDetails[0]['revenue']}"),
                      ),
                      sliderList(similarMovieList, "Similar Movies", "movie",
                          similarMovieList.length, "release_date"),
                      sliderList(
                          recommendedMoviesList,
                          "Recommended Movies",
                          "movie",
                          recommendedMoviesList.length,
                          "release_date"),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  trailerWatch({required trailerId}) {}
}
