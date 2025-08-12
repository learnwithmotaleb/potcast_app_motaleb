import 'package:flutter/material.dart';
import 'package:flutter_faq/flutter_faq.dart';
import 'package:get/get.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';
import 'package:podcast/presentation/widget/no_internet/no_internet_card.dart';
import 'package:podcast/utils/app_colors/app_colors.dart';
import 'package:podcast/utils/app_const/app_const.dart';
import 'controller/settings_controller.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  final _controller = Get.find<SettingsController>();

  @override
  void initState() {
    _controller.getSupportUs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
            onPressed: () => AppRouter.route.pop(),
            icon: const Icon(Icons.arrow_back_ios)),
        title: Text("support".tr),
      ),
      body: Obx(
        () {
          switch (_controller.supportsLoading.value) {
            case Status.loading:
              return const Center(child: CircularProgressIndicator());
            case Status.internetError:
              return NoInternetCard(onTap: () {
                _controller.getSupportUs();
              });
            case Status.noDataFound:
              return const Center(child: CustomText(text: "No data found!"));
            case Status.error:
              return NoInternetCard(onTap: () {
                _controller.getSupportUs();
              });

            case Status.completed:
              return ListView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8.0),
                itemCount: _controller.supportsData.value.data?.length ?? 0,
                itemBuilder: (BuildContext context, int index) {
                  return FAQ(
                    question:
                        _controller.supportsData.value.data?[index].question ??
                            "",
                    answer:
                        _controller.supportsData.value.data?[index].answer ??
                            "",
                    queStyle: const TextStyle(
                      color: AppColors.whiteColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                    ansStyle: const TextStyle(
                      color: AppColors.whiteColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    queDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: AppColors.greenLight.withValues(alpha: 0.1),
                    ),
                    ansDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: AppColors.greenLight.withValues(alpha: 0.1),
                    ),
                  );
                },
              );
          }
        },
      ),
    );
  }
}
