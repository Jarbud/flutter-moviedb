import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:pertemuan11/model/movie.dart';

class HttpHelper {
  final String urlKey = 'api_key=faf56eff21101633f2aee8ca5e781480';
  final String urlBase = 'https://api.themoviedb.org/3/movie';
  final String urlUpcoming = '/upcoming?';
  final String urlTopRated = '/top_rated?';

  final String urlLanguage = '&language=en-US';

  Future<String> getUpcoming() async {
    final Uri upcoming =
        Uri.parse(urlBase + urlUpcoming + urlKey + urlLanguage);
    http.Response result = await http.get(upcoming);
    if (result.statusCode == HttpStatus.ok) {
      String responseBody = result.body;
      return responseBody;
    } else {
      return '{}';
    }
  }

  Future<List> getUpcomingAsList() async {
    final Uri upcoming =
        Uri.parse(urlBase + urlUpcoming + urlKey + urlLanguage);

    http.Response result = await http.get(upcoming);
    if (result.statusCode == HttpStatus.ok) {
      final jsonResponseBody = json.decode(result.body);
      final movieObjects = jsonResponseBody['results'];
      List movies = movieObjects.map((json) => Movie.fromJson(json)).toList();
      return movies;
    } else {
      return [];
    }
  }

  Future<List> getTopRatedMovieAsList() async {
    final Uri topRated = Uri.parse(
      urlBase + urlTopRated + urlKey + urlLanguage,
    );

    http.Response result = await http.get(topRated);
    if (result.statusCode == HttpStatus.ok) {
      final jsonResponseBody = json.decode(result.body);
      final movieObjects = jsonResponseBody['results'];
      List movies = movieObjects.map((json) => Movie.fromJson(json)).toList();
      return movies;
    } else {
      return [];
    }
  }

  
}
