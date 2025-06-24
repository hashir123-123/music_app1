import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tayyab_flutter_task/model/movie_model.dart';
import 'package:tayyab_flutter_task/view_model/moive_controller.dart';
import '../services/api_urls.dart';
import 'package:intl/intl.dart';

class MoviesScreen extends StatefulWidget {
  const MoviesScreen({super.key});

  @override
  State<MoviesScreen> createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen> {
  final MovieController _movieController = Get.put(MovieController());
  final ScrollController _controllerScroll = ScrollController();
  int pageNo = 1;

  @override
  void initState() {
    _movieController.fetchMovies(pageNo);
    _controllerScroll.addListener(_scrollListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<MovieController>(
          builder: (controller){
            return Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: _controllerScroll,
                    padding: EdgeInsets.zero,
                    itemCount: controller.listMovies.length,
                    itemBuilder: (context, index) {
                      DateTime date = DateTime.parse(controller.listMovies[index].releaseDate.toString());
                      String formattedDate = DateFormat('MMM d, yyyy').format(date);
                      return Card(
                        color: Colors.black,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                        ),
                        elevation: 10,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(controller.listMovies[index].title ?? "--"),
                              SizedBox(height: 10.h),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Image.network(
                                  ConstantString.baseUrlImage+controller.listMovies[index].posterPath!.toString(),
                                  scale: 3.5,
                                ),
                              ),
                              SizedBox(height: 10.h,),
                              Text(controller.listMovies[index].overview ?? ""),
                              SizedBox(height: 10.h,),
                              Text(formattedDate),
                              SizedBox(height: 10.h,),
                              InkWell(
                                  onTap: (){
                                    print("Tab On Fav");
                                    if(controller.listFavourite.contains(controller.listMovies[index].title)){
                                      print("Im here remove");
                                      controller.removeToFavourite(FavouriteItem(
                                          movieTitle: controller.listMovies[index].title ?? '',
                                          posterUrl: controller.listMovies[index].posterPath.toString() ?? '',
                                          overView: controller.listMovies[index].overview ?? '',
                                          releaseDate: controller.listMovies[index].releaseDate.toString() ?? ''));
                                    }else{
                                      print("Im here add");
                                      controller.addToFavourite(FavouriteItem(
                                          movieTitle: controller.listMovies[index].title ?? '',
                                          posterUrl: controller.listMovies[index].posterPath.toString() ?? '',
                                          overView: controller.listMovies[index].overview ?? '',
                                          releaseDate: controller.listMovies[index].releaseDate.toString() ?? ''));
                                    }
                                  },
                                  child: Icon(Icons.favorite,  color: controller.listFavourite.contains(controller.listMovies[index].title) ? Colors.red : Colors.white,size: 30.r)),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 5.h,),
                controller.showProgress ? SizedBox(
                    height: 50.h,
                    width: double.infinity,
                    child: const Center(child: CircularProgressIndicator(color: Colors.black))) : Container()
              ],
            );
          }),
    );
  }

  _scrollListener(){
    if(_controllerScroll.offset >= _controllerScroll.position.maxScrollExtent && !_controllerScroll.position.outOfRange){
      pageNo++;
      _movieController.fetchMovies(pageNo);
    }
  }

}

class FavouriteItem{
  String movieTitle;
  String posterUrl;
  String overView;
  String releaseDate;

  FavouriteItem(
  {required this.movieTitle, required this.posterUrl, required this.overView, required this.releaseDate});
}