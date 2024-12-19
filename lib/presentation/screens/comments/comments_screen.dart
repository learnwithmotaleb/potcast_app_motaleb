import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';
import 'package:podcast/utils/app_colors/app_colors.dart';
import 'controller/comments_controller.dart';

class CommentsScreen extends StatefulWidget {
  const CommentsScreen({super.key, required this.id});
  final String id;
  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final controller = Get.put(CommentsController());
/*

  @override
  void initState() {
    controller.pagingController.addPageRequestListener((pageKey) {
      controller.getPodcast(pageKey, widget.id);
    });
    super.initState();
  }
*/

  @override
  void dispose() {
    Get.delete<CommentsController>();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: ()=>AppRouter.route.pop(), icon: const Icon(Icons.arrow_back_ios,color: AppColors.whiteColor)),
        title: Text("comments".tr,style: const TextStyle(color: AppColors.whiteColor),),
      ),
      body: Column(
        children: [
          /*Expanded(
            child: RefreshIndicator(
              onRefresh: ()async{
                controller.pagingController.refresh();
              },
              child: PagedListView<int, FavoritePodcast>(
                pagingController: controller.pagingController,
                builderDelegate: PagedChildBuilderDelegate<FavoritePodcast>(
                  itemBuilder: (context, item, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
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
                                border: Border.all(color: const Color(0xFFFE7A15),width: 2)
                            ),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(25.r),
                                child: CachedNetworkImage(
                                  imageUrl: "https://img.freepik.com/free-photo/female-singer-portrait-neon-lights_155003-8240.jpg",
                                  placeholder: (context, data)=>const SizedBox(),
                                  errorWidget: (context, data, errorWidget)=>const Icon(Icons.person),
                                  fit: BoxFit.cover,
                                )
                            ),
                          ),
                          const Gap(8),
                          const Expanded(
                            child: CustomText(text: "Finally, extended version has been released, record breaking song",maxLines: 4,fontSize: 12,textAlign: TextAlign.start,),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),*/
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12,horizontal: 5),
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(12),
                topLeft: Radius.circular(12)
              )
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    maxLines: 5,
                    minLines: 1,
                    maxLength: 300,
                    keyboardType: TextInputType.multiline,
                    style: const TextStyle(color: Colors.blue),
                    decoration: InputDecoration(
                      hintText: "Write a comments...",
                      hintStyle: const TextStyle(color: Colors.blue),
                      counterText: "",
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.blue),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
