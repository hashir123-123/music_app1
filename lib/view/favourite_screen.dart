import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../model/movie_model.dart';
import '../services/api_urls.dart';
import '../view_model/moive_controller.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({super.key});

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<MovieController>(
          builder: (controller){
            return Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: controller.listFavourite.isNotEmpty ? ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: controller.listFavourite.length,
                    itemBuilder: (context, index) {
                      DateTime date = DateTime.parse(controller.listFavourite[index].releaseDate.toString());
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
                              Text(controller.listFavourite[index].movieTitle ?? "--"),
                              SizedBox(height: 10.h),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Image.network(
                                  ConstantString.baseUrlImage+controller.listFavourite[index].posterUrl!.toString(),
                                  scale: 3.5,
                                ),
                              ),
                              SizedBox(height: 10.h,),
                              Text(controller.listFavourite[index].overView ?? ""),
                              SizedBox(height: 10.h,),
                              Text(formattedDate),
                              SizedBox(height: 10.h,),
                              InkWell(
                                  onTap: (){
                                    print("Tab On Fav Remove");
                                    if(controller.listFavourite.contains(controller.listMovies[index])){
                                      controller.removeToFavourite(controller.listMovies[index].title ?? '');
                                    }
                                    print("FavList${controller.listFavourite.toString()}");
                                  },
                                  child: Icon(Icons.delete, color: Colors.white,size: 30.r)),
                            ],
                          ),
                        ),
                      );
                    },
                  ) : Container(),
                ),
                SizedBox(height: 5.h,),
                controller.showProgress ? Container(
                    height: 50.h,
                    width: double.infinity,
                    child: const Center(child: CircularProgressIndicator(color: Colors.black))) : Container()
              ],
            );
          }),
    );
  }
}
