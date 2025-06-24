import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:tayyab_flutter_task/view/movies_screen.dart';

import '../model/movie_model.dart';
import '../services/api_urls.dart';

class MovieController extends GetxController{
  late List<Result> listMovies;
  late List<FavouriteItem> listFavourite;
  bool showProgress = false;

  @override
  void onInit() {
    listMovies = [];
    listFavourite = [];
    super.onInit();
  }

  fetchMovies(int page) async{
    showProgress = true;
    update();
    final response = await http.get(Uri.parse("${ConstantString.apiUrl}$page"));
    if (response.statusCode == 200) {
      MovieModel movieModel = MovieModel.fromRawJson(response.body);
      listMovies.addAll(movieModel.results ?? []);
      showProgress = false;
      update();
    }
    else {
      throw Exception('Failed to load movies');
    }
  }

  addToFavourite(FavouriteItem){
    listFavourite.add(FavouriteItem);
    update();
  }

  removeToFavourite(FavouriteItem){
    listFavourite.remove(FavouriteItem);
    update();
  }

}