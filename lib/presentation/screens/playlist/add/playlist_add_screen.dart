import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:podcast/core/custom_assets/assets.gen.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/helper/toast_message/toast_message.dart';
import 'package:podcast/model/route/audio_player_model.dart';
import 'package:podcast/presentation/screens/playlist/controller/playlist_controller.dart';
import 'package:podcast/presentation/widget/card/music_card.dart';
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';
import 'package:podcast/utils/app_colors/app_colors.dart';

import '../../search/model/search_podcast_model.dart';

class PlaylistAddScreen extends StatefulWidget {
  const PlaylistAddScreen({super.key});

  @override
  State<PlaylistAddScreen> createState() => _PlaylistAddScreenState();
}

class _PlaylistAddScreenState extends State<PlaylistAddScreen> {
  final controller = Get.find<PlaylistController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => AppRouter.route.pop(),
            icon: const Icon(Icons.arrow_back_ios)),
        title: Text("add_playlists".tr),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 20.0, bottom: 20),
        child: FloatingActionButton(
            onPressed: () {
              if (controller.selectedPlayListId.isNotEmpty) {
                openSaveDialog(context);
              } else {
                toastMessage(message: "Please select at last one podcast");
              }
            },
            backgroundColor: AppColors.blackColor,
            child: const Center(child: Icon(Iconsax.add, size: 80))),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          controller.pagingController.refresh();
        },
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Gap(12),
                    CupertinoSearchTextField(
                      itemColor: CupertinoColors.systemGrey,
                      placeholder: "what_would_you_like_to_listen".tr,
                      style: const TextStyle(
                          fontSize: 16, color: CupertinoColors.white),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: CupertinoColors.systemGrey5,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      onSubmitted: controller.updateSearch,
                    ),
                    const Gap(12),
                  ],
                ),
              ),
            ),
            PagedSliverList<int, SearchPodcast>(
              pagingController: controller.pagingController,
              builderDelegate: PagedChildBuilderDelegate<SearchPodcast>(
                itemBuilder: (context, item, index) {
                  final data = AudioPlayerModel(
                    id: item.id ?? "",
                    title: item.title ?? "",
                    image: item.cover ?? "",
                    categories: item.category?.title ?? "",
                    duration: item.audioDuration.toString(),
                    artist: item.creator?.user?.name ?? "",
                    url: "",
                  );
                  return Obx(() {
                    return MusicCard(
                      data: data,
                      bgColor: controller.playList[index] == true
                          ? AppColors.redColor
                          : null,
                      onTap: () {
                        final currentStatus = controller.playList[index];
                        controller.playList[index] = !currentStatus;

                        if (!currentStatus &&
                            item.id != null &&
                            item.id!.isNotEmpty) {
                          // Add to selectedPlayListId
                          controller.selectedPlayListId.add(item.id!);
                        } else {
                          // Remove from selectedPlayListId
                          controller.selectedPlayListId.remove(item.id);
                        }

                        // Refresh the observable list
                        controller.playList.refresh();

                        print(
                            "Selected IDs: ${controller.selectedPlayListId.length} ${controller.selectedPlayListId.toJson()}");
                      },
                    );
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void openSaveDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
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
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Gap(24),
                    CustomText(
                        text: "new_playlist".tr,
                        fontSize: 20,
                        color: AppColors.blackColor),
                    const Gap(12),
                    TextFormField(
                      style: const TextStyle(color: AppColors.blackColor),
                      controller: controller.title,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Name is required';
                        }
                        if (value.length < 2) {
                          return 'Name must be at least 2 characters';
                        }
                        final nameRegex = RegExp(r'^[a-zA-Z\s]+$');
                        if (!nameRegex.hasMatch(value)) {
                          return 'Name can only contain letters and spaces';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: "give_your_playlist_a_title".tr,
                        filled: false,
                        enabledBorder: const UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 2.0)),
                        focusedBorder: const UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.blue, width: 2.0)),
                      ),
                    ),
                    const Gap(24),
                    Obx(() {
                      return controller.editLoading.value
                          ? const Center(child: CircularProgressIndicator())
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ElevatedButton(
                                  onPressed: () => AppRouter.route.pop(),
                                  style: const ButtonStyle(
                                    backgroundColor: WidgetStatePropertyAll(
                                        AppColors.blackColor),
                                    foregroundColor: WidgetStatePropertyAll(
                                        AppColors.whiteColor),
                                  ),
                                  child: Text("cancel".tr),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    if (formKey.currentState!.validate()) {
                                      controller.playlistAdd();
                                    }
                                  },
                                  style: const ButtonStyle(
                                    backgroundColor: WidgetStatePropertyAll(
                                        AppColors.blackColor),
                                    foregroundColor: WidgetStatePropertyAll(
                                        AppColors.whiteColor),
                                  ),
                                  child: Text("create".tr),
                                ),
                              ],
                            );
                    }),
                    const Gap(12),
                  ],
                ),
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
