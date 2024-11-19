import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:podcast/core/route/routes.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(onPressed: ()=>AppRouter.route.pop(), icon: const Icon(Icons.arrow_back_ios)),
        title: Text("support".tr),
      ),
    );
  }
}
