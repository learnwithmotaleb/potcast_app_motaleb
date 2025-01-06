import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:podcast/core/custom_assets/assets.gen.dart';
import 'package:podcast/core/route/route_path.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/helper/toast_message/toast_message.dart';
import 'package:podcast/presentation/screens/play/controller/audio_play_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class AudioPlayBottom extends StatefulWidget {
  const AudioPlayBottom({super.key});

  @override
  State<AudioPlayBottom> createState() => _AudioPlayBottomState();
}

class _AudioPlayBottomState extends State<AudioPlayBottom> {
  final controller = Get.find<AudioPlayController>();

  @override
  Widget build(BuildContext context) {
    final double width= MediaQuery.of(context).size.width;
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 12),
      decoration: BoxDecoration(
          color:const  Color(0xFF1C1C77),
          borderRadius: BorderRadius.circular(8.r)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: ()=>AppRouter.route.pushNamed(RoutePath.commentsScreen,extra:  controller.postModel.value.data?.podcast?.id),
            child: Assets.icons.comments.svg(height: 20.h,width: 20.h),
          ),
          GestureDetector(
            onTap: (){
              _openBrowser(controller.postModel.value.data?.podcast?.creator?.donations??"");
            },
            child: Assets.icons.donate.svg(height: 20.h,width: 20.h),
          ),
        ],
      ),
    );
  }
  Future<void> _openBrowser(String urlString) async {
    try{
      final Uri url = Uri.parse(urlString);
      if (await canLaunchUrl(url)) {
        await launchUrl(
          url,
          mode: LaunchMode.externalApplication,
        );
      } else {
        toastMessage(message: "URL not open");
      }
    }catch(e){
      toastMessage(message: "URL not open");
    }
  }
}
