import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:podcast/helper/image/network_image.dart';
import 'package:podcast/presentation/screens/profile/controller/profile_controller.dart';
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';
import 'package:shimmer/shimmer.dart';

class AddPodcastNoneDesign extends StatefulWidget {
  const AddPodcastNoneDesign({super.key,});

  @override
  State<AddPodcastNoneDesign> createState() => _AddPodcastNoneDesignState();
}

class _AddPodcastNoneDesignState extends State<AddPodcastNoneDesign> {
  final _controller = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("profile".tr),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 250,
              width: width,
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Obx(() {
                      return _controller.profile.value.data?.backgroundImage != null ? CustomNetworkImage(
                        imageUrl: _controller.profile.value.data?.backgroundImage ?? "",
                        height: 200,
                        width: width,
                        borderRadius: BorderRadius.circular(12),
                      ) : ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey.withValues(alpha: 0.6),
                          highlightColor: Colors.grey.withValues(alpha: 0.3),
                          child: Container(
                            height: 200,
                            width: width,
                            decoration: BoxDecoration(
                              color: Colors.grey.withValues(alpha: 0.6),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  Positioned(
                    top: 150,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 100,
                      width: 100,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: Obx(() {
                        return _controller.profile.value.data?.avatar != null ? ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: CustomNetworkImage(
                            imageUrl: _controller.profile.value.data?.avatar ?? "",
                            height: 100,
                            width: 100,
                          ),
                        ) : Shimmer.fromColors(
                          baseColor: Colors.grey.withValues(alpha: 0.6),
                          highlightColor: Colors.grey.withValues(alpha: 0.3),
                          child: Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              color: Colors.grey.withValues(alpha: 0.6),
                              shape: BoxShape.circle,
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
            const Gap(12),
            Obx(() => Column(
              children: [
                CustomText(text: _controller.profile.value.data?.name ?? "", fontSize: 24,fontWeight: FontWeight.w800),
                const Gap(5),
                CustomText(text: _controller.profile.value.data?.email ?? "", fontSize: 16),
              ],
            )),
          ],
        ),
      ),
    );
  }
}