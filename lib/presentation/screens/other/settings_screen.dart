import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("settings".tr),
        centerTitle: true,
      ),
      /*body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 8),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: isDarkMode?const Color(0xFF1C1B1B):AppColors.whiteColor,
                borderRadius: BorderRadius.circular(8)
              ),
              child: ListTile(
                onTap: (){
                  AppRouter.route.pushNamed(RoutePath.changePasswordScreen);
                },
                title: Text("change_password".tr),
                leading: const Icon(Icons.key,color: AppColors.blueColor),
                trailing: const Icon(Icons.arrow_forward_ios,color: AppColors.blueColor),
              ),
            ),
            const Gap(8),
            Container(
              decoration: BoxDecoration(
                  color: isDarkMode?const Color(0xFF1C1B1B):AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(8)
              ),
              child: ListTile(
                onTap: (){
                  AppRouter.route.pushNamed(RoutePath.languageScreen);
                },
                title: Text("language".tr),
                leading: const Icon(Icons.language_outlined,color: AppColors.blueColor),
                trailing: const Icon(Icons.arrow_forward_ios,color: AppColors.blueColor),
              ),
            ),
            const Gap(8),
            Container(
              decoration: BoxDecoration(
                  color: isDarkMode?const Color(0xFF1C1B1B):AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(8)
              ),
              child: ListTile(
                onTap: (){
                  AppRouter.route.pushNamed(RoutePath.changeCurrencyScreen);
                },
                title: Text("change_currency".tr),
                leading: const Icon(Icons.currency_exchange,color: AppColors.blueColor),
                trailing: const Icon(Icons.arrow_forward_ios,color: AppColors.blueColor),
              ),
            ),
            const Gap(8),
            Container(
              decoration: BoxDecoration(
                  color: isDarkMode?const Color(0xFF1C1B1B):AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(8)
              ),
              child: ListTile(
                onTap: (){

                },
                title: Text("delete_account".tr),
                leading: const Icon(Icons.delete_outline,color: AppColors.blueColor),
              ),
            ),
          ],
        ),
      ),*/
    );
  }
}
