import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tmdb_movie_app/common/api_links.dart';
import 'package:tmdb_movie_app/widgets/movies.dart';
import 'package:tmdb_movie_app/widgets/tv_series.dart';
import 'package:tmdb_movie_app/widgets/upcoming.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  List<Map<String, dynamic>> trendingList = [];
  Future<void> trendingListHome() async {
    if (uval == "Weekly") {
      var trendingWeekRespnse = await http.get(Uri.parse(trendingWeekUrl));
      if (trendingWeekRespnse.statusCode == 200) {
        var tempData = json.decode(trendingWeekRespnse.body);
        var trendingWeekJson = tempData['results'];
        for (var i = 0; i < trendingWeekJson.length; i++) {
          trendingList.add({
            'id': trendingWeekJson[i]['id'],
            'poster_path': trendingWeekJson[i]['poster_path'],
            'vote_average': trendingWeekJson[i]['vote_average'],
            'media_type': trendingWeekJson[i]['media_type'],
            'indexno': i,
          });
        }
      }
    } else if (uval == "Daily") {
      var trendingDayRespnse = await http.get(Uri.parse(trendingDayUrl));
      if (trendingDayRespnse.statusCode == 200) {
        var tempData = json.decode(trendingDayRespnse.body);
        var trendingDayJson = tempData['results'];
        for (var i = 0; i < trendingDayJson.length; i++) {
          trendingList.add({
            'id': trendingDayJson[i]['id'],
            'poster_path': trendingDayJson[i]['poster_path'],
            'vote_average': trendingDayJson[i]['vote_average'],
            'media_type': trendingDayJson[i]['media_type'],
            'indexno': i,
          });
        }
      }
    } else {}
  }

  String uval = "Weekly";
  List<String> selectValues = ["Weekly", "Daily"];

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    TabController _tabController = TabController(length: 3, vsync: this);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            centerTitle: true,
            toolbarHeight: 60,
            pinned: true,
            expandedHeight: _height * 0.5,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: FutureBuilder(
                future: trendingListHome(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return CarouselSlider(
                        items: trendingList.map((e) {
                          return Builder(
                            builder: (context) {
                              return GestureDetector(
                                onTap: () {},
                                child: Container(
                                  width: _width,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(
                                          "https://image.tmdb.org/t/p/w500${e['poster_path']}"),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }).toList(),
                        options: CarouselOptions(
                          viewportFraction: 1,
                          autoPlay: true,
                          autoPlayInterval: const Duration(seconds: 2),
                          height: _height,
                        ));
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Trending",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  height: 45,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(6)),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: DropdownButton(
                      underline:
                          Container(height: 0, color: Colors.transparent),
                      icon: const Icon(
                        Icons.arrow_drop_down_sharp,
                        color: Colors.amber,
                        size: 30,
                      ),
                      value: uval,
                      items: selectValues
                          .map((e) => DropdownMenuItem(
                              value: e,
                              child: Text(
                                e,
                                style: const TextStyle(
                                  color: Colors.white,
                                  decoration: TextDecoration.none,
                                  fontSize: 16,
                                ),
                              )))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          trendingList.clear();
                          // uval = int.parse("$uval");
                          uval = value!;
                        });
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                const Center(
                  child: Text("Sample Text"),
                ),
                Container(
                  height: 45,
                  width: _width,
                  child: TabBar(
                    physics: const BouncingScrollPhysics(),
                    labelPadding: const EdgeInsets.symmetric(horizontal: 25),
                    isScrollable: true,
                    controller: _tabController,
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.amber.withOpacity(0.4),
                    ),
                    tabs: const [
                      Tab(
                        child: Text('TV Series'),
                      ),
                      Tab(
                        child: Text('Movies'),
                      ),
                      Tab(
                        child: Text('Upcoming'),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: _height,
                  child: TabBarView(
                    controller: _tabController,
                    children: const [
                      TvSeries(),
                      Movies(),
                      Upcoming(),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
