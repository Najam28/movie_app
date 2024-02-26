import 'package:flutter/material.dart';
import 'package:tmdb_movie_app/components/movie_details.dart';
import 'package:tmdb_movie_app/components/tv_series_detail.dart';

Widget sliderList(List firstListName, String categoryTitle, String type,
    int itemCount, String date) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 10, top: 15, bottom: 40),
        child: Text(categoryTitle),
      ),
      Container(
        height: 250,
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: itemCount,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                if (type == 'movie') {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        MovieDetails(movieId: firstListName[index]['id']),
                  ));
                } else if (type == 'tv') {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        TVSeriesDetail(tvId: firstListName[index]['id']),
                  ));
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.3),
                      BlendMode.darken,
                    ),
                    image: NetworkImage(
                        "https://image.tmdb.org/t/p/w500${firstListName[index]['poster_path']}"),
                    fit: BoxFit.cover,
                  ),
                ),
                margin: const EdgeInsets.only(left: 13),
                width: 170,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 2, left: 6),
                      child: Text("${firstListName[index][date]}"),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 2, right: 6),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(5)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 2, vertical: 5),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.yellow,
                                size: 15,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                "${firstListName[index]['vote_average']}",
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      )
    ],
  );
}
