import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';
import 'package:podcast/core/route/route_path.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/helper/image/network_image.dart';
import 'package:podcast/presentation/screens/profile/controller/profile_controller.dart';
import 'package:podcast/presentation/widget/button/custom_button.dart';
import 'package:podcast/presentation/widget/card/custom_profile_tile.dart';
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';
import 'package:podcast/presentation/widget/no_internet/no_internet_card.dart';
import 'package:podcast/utils/app_colors/app_colors.dart';
import 'package:podcast/utils/app_const/app_const.dart';

class ViewProfileScreen extends StatefulWidget {
  const ViewProfileScreen({super.key});

  @override
  State<ViewProfileScreen> createState() => _ViewProfileScreenState();
}

class _ViewProfileScreenState extends State<ViewProfileScreen> {
  final _controller = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: Obx(
        () {
          switch (_controller.loading.value) {
            case Status.loading:
              return const Center(child: CircularProgressIndicator());
            case Status.internetError:
              return NoInternetCard(onTap: () {
                _controller.getProfile();
              });
            case Status.noDataFound:
              return const Center(child: CustomText(text: "No data found!"));
            case Status.error:
              return NoInternetCard(onTap: () {
                _controller.getProfile();
              });

            case Status.completed:
              final dateOfBirth = _controller.profile.value.data?.dateOfBirth;
              final address = _controller.profile.value.data?.address;
              final isHaveDate = dateOfBirth != null && dateOfBirth.isUtc;
              final profileImage = _controller.profile.value.data?.profileImage ?? "";
              final coverImage = _controller.profile.value.data?.profileCover ?? "";
              final gender = _controller.profile.value.data?.gender ?? "";
              final name = _controller.profile.value.data?.name ?? "";
              final email = _controller.profile.value.data?.email ?? "";
              return SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        width: width,
                        height: 150,
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        decoration: BoxDecoration(
                          color: isDarkMode ? AppColors.whiteColor : const Color(0xFFB6B4B4),
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30),
                          ),
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: CachedNetworkImageProvider(coverImage.isNotEmpty? coverImage: "https://plus.unsplash.com/premium_photo-1681426414801-f36575c2de9e")
                          ),
                        ),
                        child: Column(
                          children: [
                            Container(
                              height: 100.h,
                              width: 100.h,
                              decoration: BoxDecoration(
                                color: profileImage.isNotEmpty ? null : AppColors.blackColor,
                                borderRadius: BorderRadius.circular(50.0.r),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50.0.r),
                                child: CustomNetworkImage(
                                  imageUrl: profileImage.isNotEmpty
                                      ? profileImage
                                      : "https://cdn-icons-png.flaticon.com/512/3135/3135715.png",
                                ),
                              ),
                            ),
                            /*Gap(8.h),
                            CustomText(
                              text: name.isNotEmpty? name : "No data found!",
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: isDarkMode ? AppColors.blackColor : AppColors.blackColor,
                            ),
                            const Gap(2),
                            CustomText(
                              text: email.isNotEmpty? email: "No data found!",
                              fontSize: 14,
                              fontWeight: FontWeight.w100,
                              color: isDarkMode ? AppColors.blackColor : AppColors.blackColor,
                            ),*/
                          ],
                        ),
                      ),
                      Gap(44.h),
                      CustomProfileTile(
                        text:  name.isNotEmpty? name : "No data found!",
                        // widget: Assets.icons.person.svg(height: 24, width: 24,colorFilter: isDarkMode?null:const ColorFilter.mode(AppColors.blackColor, BlendMode.srcIn)),
                        onTap: () {},
                        icon: Iconsax.user_copy,
                        isIcon: true,
                      ),
                      const Gap(24),
                      CustomProfileTile(
                        text:  email.isNotEmpty? email : "No data found!",
                        // widget: Assets.icons.person.svg(height: 24, width: 24,colorFilter: isDarkMode?null:const ColorFilter.mode(AppColors.blackColor, BlendMode.srcIn)),
                        onTap: () {},
                        icon: Icons.email_outlined,
                        isIcon: true,
                      ),
                      const Gap(24),
                      CustomProfileTile(
                        text: isHaveDate
                            ? DateFormat("dd MMMM yyyy - EEEE").format(dateOfBirth)
                            : "No data found!",
                        // widget: Assets.icons.birthday.svg(height: 24, width: 24,colorFilter: isDarkMode?null:const ColorFilter.mode(AppColors.blackColor, BlendMode.srcIn)),
                        onTap: () {},
                        icon: Iconsax.calendar_edit_copy,
                        isIcon: true,
                      ),
                      const Gap(24),
                      CustomProfileTile(
                        text:  gender.isNotEmpty? gender: "No data found!",
                        // widget: Assets.icons.gender.svg(height: 28, width: 32,colorFilter: isDarkMode?null:const ColorFilter.mode(AppColors.blackColor, BlendMode.srcIn)),
                        onTap: () {},
                        icon: Icons.male,
                        isIcon: true,
                      ),
                      /*const Gap(24),
                      CustomProfileTile(
                        text: _controller.profile.value.data?.contact??""
                        // widget: Assets.icons.phone.svg(height: 22, width: 22,colorFilter: isDarkMode?null:const ColorFilter.mode(AppColors.blackColor, BlendMode.srcIn)),
                        onTap: (){},
                        icon: Iconsax.call_copy,
                        isIcon: true,
                      ),*/
                      const Gap(24),
                      CustomProfileTile(
                        text: address != null && address.isNotEmpty ? address : "No data found!",
                        // widget: Assets.icons.a.svg(height: 24, width: 24,colorFilter: isDarkMode?null:const ColorFilter.mode(AppColors.blackColor, BlendMode.srcIn)),
                        onTap: () {},
                        icon: Iconsax.location_copy,
                        isIcon: true,
                      ),
                      const Gap(32),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: CustomButton(
                          text: "edit_profile".tr,
                          onTap: () => AppRouter.route.pushNamed(RoutePath.editProfileScreen),
                        ),
                      ),
                    ],
                  ),
                ),
              );
          }
        },
      ),
    );
  }
}
