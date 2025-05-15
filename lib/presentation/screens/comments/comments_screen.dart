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
          style: const TextStyle(
              color: AppColors.whiteColor,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        child: Column(
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
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 50.w,
                                  width: 50.w,
                                  padding: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: AppColors.whiteColor,
                                          width: 2,
                                      ),
                                  ),
                                  child: CustomNetworkImage(
                                    imageUrl: item.user?.avatar ?? "",
                                    borderRadius: BorderRadius.circular(25.r),
                                  ),
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
                                ),
                              ],
                            ),
                          ),
                          const Divider(),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
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
                        maxLength: 100,
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
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          hintText: "Write a comment...",
                          hintStyle: const TextStyle(color: AppColors.whiteColor),
                          suffixIcon: IconButton(onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              controller.commentsAdd(id: widget.id);
                            }
                          }, icon: const Icon(Iconsax.send_1)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: const BorderSide(color: AppColors.whiteColor),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: const BorderSide(color: AppColors.whiteColor),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: const BorderSide(color: AppColors.whiteColor),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: const BorderSide(color: AppColors.whiteColor),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: const BorderSide(color: AppColors.whiteColor),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Gap(44),
          ],
        ),
      ),
    );
  }
}
