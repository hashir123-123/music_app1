import 'dart:convert';
import 'package:tayyab_flutter_task/services/api_urls.dart';
import 'package:http/http.dart' as http;
import '../model/movie_model.dart';

class MovieServices{
  static fetchMovies({required int pageNo}) async {
    final response = await http.get(Uri.parse("${ConstantString.apiUrl}$pageNo"));
    if (response.statusCode == 200) {
      MovieModel movieModel = MovieModel.fromRawJson(response.body);
      return movieModel.results;
    }
    else {
      throw Exception('Failed to load movies');
    }
  }
}