import 'package:tmdb_movie_app/key/api_key.dart';

String trendingWeekUrl = "$baseUrl/trending/all/week?api_key=$apiKey";

String trendingDayUrl = "$baseUrl/trending/all/day?api_key=$apiKey";
String popularTvSeriesUrl = "$baseUrl/tv/popular?api_key=$apiKey";
String topRatedTvSeriesUrl = "$baseUrl/tv/top_rated?api_key=$apiKey";
String onAirTvSeriesUrl = "$baseUrl/tv/on_the_air?api_key=$apiKey";
String popularMoviesUrl = "$baseUrl/movie/popular?api_key=$apiKey";
String nowPlayingMoviesUrl = "$baseUrl/movie/now_playing?api_key=$apiKey";
String topRatedMoviesUrl = "$baseUrl/movie/top_rated?api_key=$apiKey";
String upComingMoviesUrl = "$baseUrl/movie/latest?api_key=$apiKey";
