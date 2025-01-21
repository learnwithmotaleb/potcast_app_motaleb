import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:podcast/helper/image/network_image.dart';
import 'package:podcast/utils/app_colors/app_colors.dart';
import 'package:readmore/readmore.dart';
import 'controller/comments_controller.dart';
import 'model/comments_model.dart';

class CommentsScreen extends StatefulWidget {
  const CommentsScreen({super.key, required this.id});

  final String id;

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final controller = Get.put(CommentsController());

  @override
  void initState() {
    controller.pagingController.addPageRequestListener((pageKey) {
      controller.getPodcast(pageKey, widget.id);
    });
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    Get.delete<CommentsController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "comments".tr,
          style: const TextStyle(color: AppColors.whiteColor),
        ),
        backgroundColor: const Color(0xFF0F593B),
      ),
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                controller.pagingController.refresh();
              },
              child: PagedListView<int, Comment>(
                pagingController: controller.pagingController,
                builderDelegate: PagedChildBuilderDelegate<Comment>(
                  itemBuilder: (context, item, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        padding: const EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF0F2027),
                              Color(0xFF203A43),
                              Color(0xFF2C5364),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: 50.w,
                              width: 50.w,
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: const Color(0xFFFE7A15), width: 2)),
                              child: ClipRRect(borderRadius: BorderRadius.circular(25.r), child: CustomNetworkImage(imageUrl: item.user?.avatar ?? "")),
                            ),
                            const Gap(8),
                            Expanded(
                              child: ReadMoreText(
                                item.text ?? "",
                                trimMode: TrimMode.Line,
                                trimLines: 2,
                                colorClickableText: Colors.pink,
                                trimCollapsedText: 'Show more',
                                trimExpandedText: 'Show less',
                                moreStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 5),
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF093028),
                  Color(0xFF237A57),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Form(
              key: _formKey,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      maxLines: 5,
                      minLines: 1,
                      controller: controller.comments,
                      maxLength: 300,
                      keyboardType: TextInputType.multiline,
                      validator: (value) {
                        if (value != null && value.isNotEmpty) {
                          return null;
                        } else {
                          return "Please Add Comments";
                        }
                      },
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Write a comments...",
                        counterText: "",
                        filled: true,
                        hintStyle: TextStyle(color: AppColors.whiteColor),
                        fillColor: const Color(0xFF2C5364),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  Obx(() {
                    return controller.addComments.value
                        ? const Center(child: CircularProgressIndicator())
                        : IconButton(
                            icon: const Icon(Iconsax.send_1, size: 30),
                            style: ButtonStyle(
                              padding: WidgetStatePropertyAll(EdgeInsets.zero)
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                controller.commentsAdd(id: widget.id);
                              }
                            },
                          );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
