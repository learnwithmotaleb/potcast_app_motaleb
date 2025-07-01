import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:podcast/core/custom_assets/assets.gen.dart';
import 'package:podcast/core/route/route_path.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/helper/image/network_image.dart';
import 'package:podcast/helper/toast_message/toast_message.dart';
import 'package:podcast/presentation/screens/play/controller/audio_play_controller.dart';
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';
import 'package:podcast/presentation/widget/text_field/custom_text_field.dart';
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
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.black,
              builder: (context) {
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: DraggableScrollableSheet(
                    initialChildSize: 0.7,
                    minChildSize: 0.4,
                    maxChildSize: 0.95,
                    expand: false,
                    builder: (context, scrollController) {
                      return Column(
                        children: [
                          const Gap(12),
                          Container(
                            height: 3,
                            width: 45,
                            decoration: BoxDecoration(
                              color: AppColors.whiteColor.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const Gap(5),
                          const CustomText(
                            text: "Comments",
                            fontSize: 18,
                          ),
                          Divider(
                            color: AppColors.whiteColor.withOpacity(0.1),
                          ),
                          Expanded(
                            child: ListView.builder(
                              controller: scrollController,
                              itemCount: 10,
                              itemBuilder: (BuildContext context, int index) {
                                return ListTile(
                                  leading: const CircleAvatar(
                                    backgroundImage: CachedNetworkImageProvider(
                                      "https://plus.unsplash.com/premium_photo-1681335986095-5a9585e77246",
                                    ),
                                  ),
                                  title: RichText(
                                    text: const TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "Jon Brenton ",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white,
                                          ),
                                        ),
                                        TextSpan(
                                          text: " 6h",
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.white70,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  subtitle: CustomText(
                                    text:
                                    "Production is where you make your app available to billions of users on Google Play.",
                                    maxLines: 2,
                                    color: AppColors.whiteColor.withOpacity(0.7),
                                    textAlign: TextAlign.start,
                                  ),
                                );
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8),
                            child: TextFormField(
                              maxLines: 5,
                              minLines: 1,
                              maxLength: 100,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                if (value != null && value.isNotEmpty) {
                                  return null;
                                } else {
                                  return "Please Add Comments";
                                }
                              },
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                contentPadding:
                                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                hintText: "Write a comment...",
                                hintStyle: const TextStyle(color: AppColors.whiteColor),
                                suffixIcon: IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Iconsax.send_1),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  borderSide: const BorderSide(color: AppColors.whiteColor),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  borderSide: const BorderSide(color: AppColors.whiteColor),
                                ),
                              ),
                            ),
                          )
                        ],
                      );
                    },
                  ),
                );
              },
            );
          },
          child: Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: AppColors.blackColor,
                border: Border.all(color: AppColors.whiteColor)),
            child: Row(
              children: [
                Assets.icons.comments.svg(height: 20.h, width: 20.h),
                const Gap(2),
                const CustomText(
                  text: "....",
                  color: AppColors.whiteColor,
                ),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            _openBrowser(controller.postModel.value.data?.podcast?.creator?.donations ?? "");
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
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
                border: Border.all(color: AppColors.whiteColor)),
            child: const CustomText(text: "Give", color: AppColors.whiteColor),
          ),
        ),
      ],
    );
  }

  Future<void> _openBrowser(String urlString) async {
    try {
      final Uri url = Uri.parse(urlString);
      if (await canLaunchUrl(url)) {
        await launchUrl(
          url,
          mode: LaunchMode.externalApplication,
        );
      } else {
        toastMessage(message: "Donations URL not found");
      }
    } catch (e) {
      toastMessage(message: "Donations URL not found");
    }
  }
}
