import 'package:flutter/material.dart';
import 'package:tmdb_movie_app/components/movie_details.dart';
import 'package:tmdb_movie_app/components/tv_series_detail.dart';

class DiscriptionCheckerUI extends StatefulWidget {
  const DiscriptionCheckerUI({super.key, this.newId, this.newType});
  final newId;
  final newType;

  @override
  State<DiscriptionCheckerUI> createState() => _DiscriptionCheckerUIState();
}

class _DiscriptionCheckerUIState extends State<DiscriptionCheckerUI> {
  checkType() {
    if (widget.newType == "movie") {
      return MovieDetails(movieId: widget.newId);
    } else if (widget.newType == 'tv') {
      return TVSeriesDetail(
        tvId: widget.newId,
      );
    } else {
      return const Text('Error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return checkType();
  }
}
