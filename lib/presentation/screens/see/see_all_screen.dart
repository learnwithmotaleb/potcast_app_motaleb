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
