import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';
import 'package:podcast/presentation/widget/no_internet/no_internet_card.dart';
import 'package:podcast/utils/app_colors/app_colors.dart';
import 'package:podcast/utils/app_const/app_const.dart';
import 'controller/settings_controller.dart';

class TermsOfCondition extends StatefulWidget {
  const TermsOfCondition({super.key});

  @override
  State<TermsOfCondition> createState() => _TermsOfConditionState();
}

class _TermsOfConditionState extends State<TermsOfCondition> {
  final _controller = Get.find<SettingsController>();

  @override
  void initState() {
    _controller.getTermsCondition();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text("terms_of_condition".tr),
      ),
      body: Obx(
        () {
          switch (_controller.termsLoading.value) {
            case Status.loading:
              return const Center(child: CircularProgressIndicator());
            case Status.internetError:
              return NoInternetCard(onTap: () {
                _controller.getTermsCondition();
              });
            case Status.noDataFound:
              return const Center(child: CustomText(text: "No data found!"));
            case Status.error:
              return NoInternetCard(onTap: () {
                _controller.getTermsCondition();
              });

            case Status.completed:
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8.0,
                ),
                child: Html(
                  data: _controller.termModel.value.data?.description ?? "",
                ),
              );
          }
        },
      ),
    );
  }
}
