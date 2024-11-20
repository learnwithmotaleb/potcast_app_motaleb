import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/presentation/widget/card/music_card.dart';
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';
import 'package:podcast/presentation/widget/text_field/custom_text_field.dart';
import 'package:podcast/utils/app_colors/app_colors.dart';

import 'controller/playlist_add_controller.dart';

class PlaylistAddScreen extends StatefulWidget {
  const PlaylistAddScreen({super.key});

  @override
  State<PlaylistAddScreen> createState() => _PlaylistAddScreenState();
}

class _PlaylistAddScreenState extends State<PlaylistAddScreen> {
  final controller = Get.find<PlaylistAddController>();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => AppRouter.route.pop(),
            icon: const Icon(Icons.arrow_back_ios)),
        title: Text("add_playlists".tr),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => openSaveDialog(context),
        backgroundColor: AppColors.primaryColor,
        label: Text("save".tr,
            style: const TextStyle(color: AppColors.whiteColor)),
        icon: const Icon(Icons.add, color: AppColors.whiteColor),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: controller.newItem.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return Column(
              children: [
                CustomTextField(
                  hintText: "find_playlist".tr,
                  prefixIcon: const Icon(Iconsax.search_normal_1_copy),
                ),
                const Gap(12),
              ],
            );
          } else {
            return MusicCard(data: controller.newItem[index - 1], onTap: (){});
          }
        },
      ),
    );
  }

  void openSaveDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return Center(
          child: Dialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 16,
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(30)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Gap(24),
                  CustomText(text: "new_playlist".tr, fontSize: 20, color: AppColors.blackColor),
                  const Gap(12),
                  TextField(
                    style: const TextStyle(color: AppColors.blackColor),
                    decoration: InputDecoration(
                      hintText: "give_your_playlist_a_title".tr,
                      filled: false,
                      enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey, width: 2.0)),
                      focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.blue, width: 2.0)),
                    ),
                  ),
                  const Gap(24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: ()=>AppRouter.route.pop(),
                        style: const ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(AppColors.blackColor),
                            foregroundColor: WidgetStatePropertyAll(AppColors.whiteColor),
                        ), child: Text("cancel".tr),
                      ),
                      ElevatedButton(
                          onPressed: (){
                            AppRouter.route.pop();
                            AppRouter.route.pop();
                          },
                          style: const ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(AppColors.blackColor),
                              foregroundColor: WidgetStatePropertyAll(AppColors.whiteColor),
                          ), child: Text("create".tr),
                      ),
                    ],
                  ),
                  const Gap(12),
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: animation,
            child: child,
          ),
        );
      },
    );
  }
}
