import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:podcast/core/custom_assets/assets.gen.dart';
import 'package:podcast/core/route/route_path.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/helper/image/network_image.dart';
import 'package:podcast/presentation/screens/user/home/controller/user_home_controller.dart';
import 'package:podcast/presentation/screens/user/home/model/home_model.dart';
import 'package:podcast/presentation/widget/button/custom_button.dart';
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';
import 'package:podcast/utils/app_colors/app_colors.dart';

class UserHomeTopSection extends StatefulWidget {
  const UserHomeTopSection({super.key, this.categories});

  final CategoryElement? categories;

  @override
  State<UserHomeTopSection> createState() => _UserHomeTopSectionState();
}

class _UserHomeTopSectionState extends State<UserHomeTopSection> {
  final controller = Get.find<UserHomeController>();

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Gap(70.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 25.h, width: 25.w),
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: Assets.images.splashLogo.image(
                  height: 60.h,
                  width: 150.w,
                  fit: BoxFit.cover,
                  color: isDarkMode ? null : AppColors.blackColor,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 18.0),
              child: GestureDetector(
                onTap: ()=>AppRouter.route.pushNamed(RoutePath.notificationScreen),
                child: Assets.icons.notification.svg(height: 25.h, width: 25.w),
              ),
            ),
          ],
        ),
        const Gap(24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: GestureDetector(
            onTap: () => AppRouter.route.pushNamed(RoutePath.searchScreen, extra: "all"),
            child: Container(
              width: width,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: AppColors.searchBoxColor, borderRadius: BorderRadius.circular(8.r)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Assets.icons.search.svg(height: 22, width: 22),
                  const Gap(8),
                  CustomText(text: "what_would_you_like_to_listen".tr, color: AppColors.blackColor, fontSize: 16),
                ],
              ),
            ),
          ),
        ),
        const Gap(24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 1,
                child: Hero(
                  tag: "r gyug efegfwuefg weug",
                  child: GestureDetector(
                    onTap: () => showMapDialog(context),
                    child: Container(
                      height: 80.h,
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD9DCDE),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(child: CustomText(text: controller.model.value.data?.location ?? "select_your_location".tr, fontSize: 20.sp, color: AppColors.blackColor, maxLines: 2,)),
                          SizedBox(
                            height: 80.h,
                            width: 60,
                            child: Assets.images.map.image(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Gap(8.w),
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: () => AppRouter.route.pushNamed(RoutePath.categoriesScreen, extra: widget.categories?.id ?? ""),
                  child: Container(
                    height: 80.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEF4849),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 2.0, bottom: 2.0),
                            child: CustomText(text: widget.categories?.title ?? "", fontSize: 20, color: AppColors.whiteColor, maxLines: 2, textAlign: TextAlign.center),
                          ),
                        ),
                        Expanded(child: ClipRRect(borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(8.0),
                          bottomRight: Radius.circular(8.0),
                        ),child: CustomNetworkImage(imageUrl: widget.categories?.categoryImage ?? ""))),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  void showMapDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      transitionDuration: const Duration(milliseconds: 600),
      pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
        return SafeArea(
          child: Dialog(
            insetPadding: EdgeInsets.zero,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: [
                  Obx(() => GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: controller.selectedPosition.value,
                      zoom: 14,
                    ),
                    myLocationButtonEnabled: false,
                    onCameraMove: (CameraPosition position) {
                      controller.updatePosition(position.target);
                    },
                  )),
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      height: 50,
                      width: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.blackColor.withValues(alpha: 0.8),
                        shape: BoxShape.circle
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
                        onPressed: () {
                          AppRouter.route.pop();
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: Obx(() {
                      return CustomButton(
                        text: "Save",
                        isLoading: controller.isLocationSaveLoading.value,
                        onTap: () {
                          controller.saveLocationAddress(location: controller.selectedPosition.value);
                        },
                      );
                    }),
                  ),
                  // Center marker (static UI marker)
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Colors.red,
                          size: 40,
                        ),
                        Obx(() {
                          return CustomText(text: controller.selectedAddress.value, color: AppColors.blackColor,);
                        })
                      ],
                    ),
                  ),
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
