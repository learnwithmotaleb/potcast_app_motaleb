import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:podcast/controller/search_my_location_controller.dart';
import "package:get/get.dart";
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';
import 'package:podcast/presentation/widget/no_internet/no_internet_card.dart';
import 'package:podcast/utils/app_colors/app_colors.dart';
import 'package:podcast/utils/app_const/app_const.dart';

Future<String?> showMapDialog({required BuildContext context, bool isShotAddress = false}) async {
  final controller = Get.put(SearchMyLocationController());

  final result = await showModalBottomSheet<String>(
    context: context,
    barrierColor: Colors.black.withAlpha(120),
    isDismissible: true,
    isScrollControlled: true,
    builder: (BuildContext ctx) {
      final height = MediaQuery.of(context).size.height;
      final width = MediaQuery.of(context).size.width;

      return SafeArea(
        child: SizedBox(
          width: width,
          height: height * 0.9,
          child: Column(
            children: [
              const Gap(24),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
                child: CupertinoSearchTextField(
                  controller: controller.searchText,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                  onSubmitted: (String value) {
                    controller.searchLocationByGoogle(context: context);
                  },
                  placeholder: "Search your location",
                  placeholderStyle: const TextStyle(color: Colors.grey),
                  style: const TextStyle(color: AppColors.whiteColor),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A2B31),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const Divider(),
              Obx(() {
                switch (controller.searchLoading.value) {
                  case Status.loading:
                    return const Center(child: CircularProgressIndicator());
                  case Status.internetError:
                    return NoInternetCard(onTap: () => controller.searchLocationByGoogle(context: context));
                  case Status.noDataFound:
                    return const Center(child: CustomText(text: "No data found!"));
                  case Status.error:
                    return NoInternetCard(onTap: () => controller.searchLocationByGoogle(context: context));
                  case Status.completed:
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.addressList.length,
                      itemBuilder: (BuildContext context, int index) {
                        final address = controller.addressList[index];
                        final shotAddress = address.structuredFormatting?.mainText ?? "";
                        final value = address.description ?? shotAddress;

                        return GestureDetector(
                          onTap: () {
                            if(isShotAddress){
                              Navigator.pop(context, shotAddress);
                            }else{
                              Navigator.pop(context, value);
                            }
                          },
                          child: Container(
                            color: Colors.green.withValues(alpha: 0.1),
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.location_on, color: AppColors.blackColor),
                                    const Gap(5),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            address.structuredFormatting?.mainText ?? "",
                                            maxLines: 1,
                                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
                                          ),
                                          const Gap(5),
                                          Text(
                                            address.description ?? "",
                                            maxLines: 1,
                                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w100),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                }
              }),
            ],
          ),
        ),
      );
    },
  );

  Get.delete<SearchMyLocationController>();
  return result;
}

