import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';
import 'package:podcast/presentation/widget/no_internet/no_internet_card.dart';
import 'package:podcast/utils/app_colors/app_colors.dart';
import 'package:podcast/utils/app_const/app_const.dart';

import 'controller/settings_controller.dart';

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({super.key});

  @override
  State<AboutUsScreen> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  final _controller = Get.find<SettingsController>();
  @override
  void initState() {
    _controller.getAboutUs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text("about_us".tr),
      ),
      body: Obx(
        () {
          switch (_controller.aboutLoading.value) {
            case Status.loading:
              return const Center(child: CircularProgressIndicator());
            case Status.internetError:
              return NoInternetCard(onTap: () {
                _controller.getAboutUs();
              });
            case Status.noDataFound:
              return const Center(child: CustomText(text: "No data found!"));
            case Status.error:
              return NoInternetCard(onTap: () {
                _controller.getAboutUs();
              });

            case Status.completed:
              return SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8.0),
                child:
                    Html(data: _controller.aboutUsData.value.data?.description ?? ""),
              );
          }
        },
      ),
    );
  }
}
