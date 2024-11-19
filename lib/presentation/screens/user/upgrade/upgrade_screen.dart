import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/presentation/widget/button/custom_button.dart';
import 'package:podcast/presentation/widget/card/subscription_card.dart';

class UpgradeScreen extends StatelessWidget {
  const UpgradeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () => AppRouter.route.pop(),
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: Text("subscription".tr),
      ),
      bottomNavigationBar: Container(
        height: 80.h,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 16),
        child: CustomButton(text: "pay_now".tr),
      ),
      body: ListView.builder(
        itemCount: 3,
        padding: const EdgeInsets.only(left: 12),
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index){
          return SubscriptionCard(index: index);
        },
      ),
    );
  }
}
