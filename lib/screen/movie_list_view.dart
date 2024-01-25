import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pertemuan11/component/http_helper.dart';
import 'movie_detail.dart';

class MovieListView extends StatefulWidget {
  const MovieListView({Key? key}) : super(key: key);
  @override
  State<MovieListView> createState() => _MovieListViewState();
}

class _MovieListViewState extends State<MovieListView> {
  Icon searchIcon = const Icon(Icons.search);
  Widget titleBar = const Text('Daftar Film Upcoming');

  late int moviesCount;
  late List movies;
  late HttpHelper helper;
  final String iconBase = 'https://image.tmdb.org/t/p/w92/';
  final String defaultImage =
      'https://images.freeimages.com/images/large-previews/5eb/movie-clap board1184339.jpg';

  @override
  void initState() {
    defaultList();
    super.initState();
  }

  void toggleSearch() {
    setState(() {
        setState(() {
          searchIcon = const Icon(Icons.search);
          titleBar = const Text('Daftar Film');
        });
        defaultList();
    });
  }

  Future defaultList() async {
    moviesCount = 0;
    movies = [];
    helper = HttpHelper();
    List moviesFromAPI = [];
    moviesFromAPI = await helper.getUpcomingAsList();
    setState(() {
      movies = moviesFromAPI;
      moviesCount = movies.length;
    });
  }

  Future topRatedList() async {
    moviesCount = 0;
    movies = [];
    helper = HttpHelper();
    List moviesFromAPI = [];
    moviesFromAPI = await helper.getTopRatedMovieAsList();
    setState(() {
      movies = moviesFromAPI;
      moviesCount = movies.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    NetworkImage image;
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: const Text('Upcoming'),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  searchIcon = const Icon(Icons.search);
                  titleBar = const Text('Daftar Film Upcoming');
                });
                defaultList();
              },
            ),
            ListTile(
              title: const Text('Top Rated'),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  searchIcon = const Icon(Icons.search);
                  titleBar = const Text('Film Rating Tertinggi');
                });
                topRatedList();
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: titleBar,
        actions: [
          IconButton(
            icon: searchIcon,
            onPressed: toggleSearch,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: moviesCount,
        itemBuilder: (context, position) {
          var selectedMovies = movies[position];
          if (selectedMovies.posterPath != null) {
            image = NetworkImage(iconBase + movies[position].posterPath);
          } else {
            image = NetworkImage(defaultImage);
          }

          var date = movies[position].releaseDate;
          var formattedDate = DateTime.parse(date);

          date = DateFormat("d MMM yyyy").format(formattedDate);

          return InkWell(
            onTap: () {
              MaterialPageRoute route = MaterialPageRoute(
                builder: (context) {
                  return MovieDetail(
                    selectedMovie: movies[position],
                  );
                },
              );
              Navigator.push(context, route);
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    offset: const Offset(0, 4),
                    blurRadius: 16,
                  )
                ],
              ),
              child: Row(
                children: [
                  ClipRRect(
                    child: Image(
                      image: image,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(
                        selectedMovies.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(date),
                      const SizedBox(height: 4),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          
                          const SizedBox(width: 2),
                          Text(
                            'Rating : '+selectedMovies.voteAverage.toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 12,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 4),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
