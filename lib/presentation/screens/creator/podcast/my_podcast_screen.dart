import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:podcast/core/route/route_path.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/model/route/audio_player_model.dart';
import 'package:podcast/presentation/widget/card/podcast_card.dart';
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';
import 'package:podcast/utils/app_colors/app_colors.dart';

class MyPodcastScreen extends StatelessWidget {
  const MyPodcastScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    List<AudioPlayerModel> newItem = [
      AudioPlayerModel(
          id: "1",
          artist: "Sabrina Carpenter",
          album: "Entertainment",
          title: "Promises (feat. Joe L Barnes & Naomi Raine) _ Maverick City Music _ TRIBL",
          url: "https://drive.usercontent.google.com/u/0/uc?id=1PggdOYJxkD5Rb23R3E48F8dDdOzH62ld&export=download",
          image: "https://img.freepik.com/free-photo/female-singer-portrait-neon-lights_155003-8240.jpg"
      ),
      AudioPlayerModel(
          id: "2",
          artist: "Sabrina Carpenter",
          album: "Entertainment",
          title: "Promises (feat. Joe L Barnes & Naomi Raine) _ Maverick City Music _ TRIBL",
          url: "https://drive.usercontent.google.com/u/0/uc?id=1uah5cRL4LxWSiNYeGfgC4i40mRW8hVgm&export=download",
          image: "https://img.freepik.com/free-photo/young-caucasian-female-musician-performer-singing-dancing-neon-light-gradient_155003-44185.jpg"
      ),
      AudioPlayerModel(
          id: "3",
          artist: "Morgan Walled",
          album: "Cubit Songs",
          title: "Promises (feat. Joe L Barnes & Naomi Raine) _ Maverick City Music _ TRIBL",
          url: "https://drive.usercontent.google.com/u/0/uc?id=1pJaX_zNFRA3IPjvU2OutmEijpwCqkWDI&export=download",
          image: "https://img.freepik.com/premium-photo/caucasian-female-singer-portrait-isolated-gradient-studio-background-neon-light_489646-16996.jpg"
      ),
      AudioPlayerModel(
          id: "4",
          artist: "Leroi Song",
          album: "Eminem",
          title: "Promises (feat. Joe L Barnes & Naomi Raine) _ Maverick City Music _ TRIBL",
          url: "https://drive.usercontent.google.com/u/0/uc?id=1CwdsEVSuVBsZuGtizMsBxdz8rpv86V8w&export=download",
          image: "https://img.freepik.com/premium-photo/image-caucasian-dark-haired-woman-wearing-stylish-jacket-standing-with-closed-eyes-listening-music-holding-cell-phone-as-microphone-singing-posing-isolated-neon-light-background_176532-19786.jpg"
      ),
      AudioPlayerModel(
          id: "5",
          artist: "Sabrina Carpenter",
          album: "Entertainment",
          title: "Promises (feat. Joe L Barnes & Naomi Raine) _ Maverick City Music _ TRIBL",
          url: "https://drive.usercontent.google.com/u/0/uc?id=1pVGY5C8cMZIdJKWhvnmt4dZi7HYoxdM3&export=download",
          image: "https://img.freepik.com/premium-photo/caucasian-female-singer-portrait-isolated-gradient-studio-background-neon-light_489646-16996.jpg"
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: ()=>AppRouter.route.pop(), icon: const Icon(Icons.arrow_back_ios)),
        title: Text("my_podcast".tr,),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.only(left: 12,right: 12,top: 12,bottom: 44),
        itemCount: newItem.length + 1,
        itemBuilder: (BuildContext context, int index){
          if(index==0){
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                children: [
                  const Gap(12),
                  GestureDetector(
                    onTap: ()=>AppRouter.route.pushNamed(RoutePath.podcastAddScreen),
                    child: Container(
                      padding: const EdgeInsets.all(5.0),
                      width: width,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(color: isDarkMode?AppColors.whiteColor:AppColors.blackColor)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 40.h,
                            width: 40.h,
                            decoration: BoxDecoration(
                                color: isDarkMode?AppColors.whiteColor:AppColors.blackColor,
                                shape: BoxShape.circle
                            ),
                            child: Icon(Icons.add_circle_outline,color: isDarkMode?AppColors.blackColor:AppColors.whiteColor),
                          ),
                          const Gap(5),
                          CustomText(text: "add_new_podcast".tr,fontSize: 12,fontWeight: FontWeight.w700),
                        ],
                      ),
                    ),
                  ),
                  const Gap(12),
                ],
              ),
            );
          }else{
            return PodcastCard(data: newItem[index-1]);
          }
        },
      ),
    );
  }
}
