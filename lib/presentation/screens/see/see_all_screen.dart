import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:podcast/core/route/route_path.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/model/route/audio_player_model.dart';
import 'package:podcast/presentation/widget/card/music_card.dart';

class SeeAllScreen extends StatelessWidget {
  const SeeAllScreen({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
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
        leading: IconButton(
          onPressed: () => AppRouter.route.pop(),
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: Text(title.tr),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.only(left: 12,right: 12,top: 12,bottom: 44),
        itemCount: newItem.length,
        itemBuilder: (BuildContext context, int index){
          return MusicCard(data: newItem[index],onTap: (){
            AppRouter.route.pushNamed(RoutePath.userPlayScreen,extra: newItem[index]);
          });
        },
      ),
    );
  }
}
