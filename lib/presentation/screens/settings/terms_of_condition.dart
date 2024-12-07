import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';
import 'package:podcast/presentation/widget/no_internet/no_internet_card.dart';
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
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(onPressed: ()=>AppRouter.route.pop(), icon: const Icon(Icons.arrow_back_ios)),
        title: Text("terms_of_condition".tr),
      ),
      body: Obx(
            () {
          switch (_controller.termsLoading.value) {
            case Status.loading:
              return const Center(child: CircularProgressIndicator());
            case Status.internetError:
              return NoInternetCard(onTap: (){
                _controller.getTermsCondition();
              });
            case Status.noDataFound:
              return const Center(child: CustomText(text: "No data found!"));
            case Status.error:
              return NoInternetCard(onTap: (){
                _controller.getTermsCondition();
              });

            case Status.completed:
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8.0),
                child: CustomText(text: _controller.termsConditionsData.value.data?.text??""),
              );
          }
        },
      ),
    );
  }
}
