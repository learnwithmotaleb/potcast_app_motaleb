import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:podcast/core/route/route_path.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/presentation/screens/creator/home/widget/creator_top_section.dart';
import 'package:podcast/presentation/widget/card/music_card.dart';
import 'controller/creator_home_controller.dart';

class CreatorHomeScreen extends StatefulWidget {
  const CreatorHomeScreen({super.key});

  @override
  State<CreatorHomeScreen> createState() => _CreatorHomeScreenState();
}

class _CreatorHomeScreenState extends State<CreatorHomeScreen> {
  final controller = Get.find<CreatorHomeController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.only(top: 12,bottom: 44),
        itemCount: controller.newItem.length+1,
        itemBuilder: (BuildContext context, int index){
          if(index==0){
            return CreatorTopSection();
          }else{
            return MusicCard(data: controller.newItem[index-1],onTap: ()=>AppRouter.route.pushNamed(RoutePath.creatorPlayScreen,extra: controller.artistItem[index-1]));
          }
        },
      ),
    );
  }
}
