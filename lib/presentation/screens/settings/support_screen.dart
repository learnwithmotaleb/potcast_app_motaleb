import 'package:flutter/material.dart';
import 'package:flutter_easy_faq/flutter_easy_faq.dart';
import 'package:get/get.dart';
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';
import 'package:podcast/presentation/widget/loading/loading_widget.dart';
import 'package:podcast/presentation/widget/no_internet/no_internet_card.dart';
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
        title: Text("support".tr),
      ),
      body: Obx(() {
          switch (_controller.supportsLoading.value) {
            case Status.loading:
              return const LoadingWidget();
            case Status.internetError:
              return NoInternetCard(
                onTap: () {
                  _controller.getSupportUs();
                },
              );
            case Status.noDataFound:
              return const Center(child: CustomText(text: "No data found!"));
            case Status.error:
              return NoInternetCard(
                onTap: () {
                  _controller.getSupportUs();
                },
              );

            case Status.completed:
              final items = _controller.supportsData.value.data ?? [];
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8.0),
                itemCount: items.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: EasyFaq(
                      question: _controller.supportsData.value.data?[index].question ?? "",
                      answer: _controller.supportsData.value.data?[index].answer ?? "",
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
