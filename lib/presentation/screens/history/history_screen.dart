import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:podcast/core/custom_assets/assets.gen.dart';
import 'package:podcast/core/route/route_path.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/model/route/audio_player_model.dart';
import 'package:podcast/presentation/widget/card/music_card.dart';
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';
import 'package:podcast/utils/app_colors/app_colors.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key, required this.isUser});
  final bool isUser;
  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
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
        centerTitle: true,
        title: Text("history".tr),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.only(left: 12,right: 12,top: 12,bottom: 44),
        itemCount: newItem.length + 1,
        itemBuilder: (BuildContext context, int index){
          if(index ==0){
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Row(
                children: [
                  Assets.icons.sort.svg(height: 15,width: 15,color: isDarkMode?null:AppColors.blackColor),
                  const Gap(5),
                  CustomText(text: "recently_played".tr,fontWeight: FontWeight.w600,fontSize: 16),
                ],
              ),
            );
          }else{
            return MusicCard(data: newItem[index - 1],onTap: (){
              if(isUser){
                AppRouter.route.pushNamed(RoutePath.userPlayScreen,extra: newItem[index - 1]);
              }else{
                AppRouter.route.pushNamed(RoutePath.creatorPlayScreen,extra: newItem[index - 1]);
              }
            });
          }
        },
      ),
    );
  }
}
