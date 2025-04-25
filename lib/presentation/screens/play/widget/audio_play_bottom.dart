import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:podcast/core/custom_assets/assets.gen.dart';
import 'package:podcast/core/route/route_path.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/helper/toast_message/toast_message.dart';
import 'package:podcast/presentation/screens/play/controller/audio_play_controller.dart';
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';
import 'package:podcast/utils/app_colors/app_colors.dart';
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: ()=>AppRouter.route.pushNamed(RoutePath.commentsScreen,extra:  controller.postModel.value.data?.podcast?.id),
          child: Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              /*gradient: const LinearGradient(
                colors: [
                  Color(0xFF093028),
                  Color(0xFF0F593B),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),*/
              color: AppColors.blackColor,
                border: Border.all(color: AppColors.whiteColor)
            ),
            child: Row(
              children: [
                Assets.icons.comments.svg(height: 20.h,width: 20.h),
                const Gap(2),
                const CustomText(text: "...."),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: (){
            _openBrowser(controller.postModel.value.data?.podcast?.creator?.donations??"");
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18,vertical: 10),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              /*gradient: const LinearGradient(
                colors: [
                  Color(0xFF093028),
                  Color(0xFF0F593B),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),*/
              color: AppColors.blackColor,
              border: Border.all(color: AppColors.whiteColor)
            ),
            child: const CustomText(text: "Give"),
          ),
        ),
      ],
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
        toastMessage(message: "Donations URL not found");
      }
    }catch(e){
      toastMessage(message: "Donations URL not found");
    }
  }
}
