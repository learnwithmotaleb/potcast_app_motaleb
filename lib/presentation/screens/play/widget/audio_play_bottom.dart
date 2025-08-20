import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:podcast/core/custom_assets/assets.gen.dart';
import 'package:podcast/helper/toast_message/toast_message.dart';
import 'package:podcast/presentation/screens/play/controller/podcast_feed_controller.dart';
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';
import 'package:podcast/presentation/widget/text_field/custom_text_field.dart';
import 'package:podcast/utils/app_colors/app_colors.dart';
import 'package:podcast/utils/app_const/app_const.dart';
import 'package:url_launcher/url_launcher.dart';

import '../model/comment_model.dart';

class AudioPlayBottom extends StatelessWidget {
  const AudioPlayBottom({
    super.key,
    required this.controller,
  });

  final PodcastFeedController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            showModel(
              context: context,
              feedController: controller,
              id: controller.currentItem.value.id ?? "",
            );
          },
          child: Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: AppColors.blackColor,
              border: Border.all(
                color: AppColors.whiteColor,
              ),
            ),
            child: Row(
              children: [
                Assets.icons.comments.svg(
                  height: 20.h,
                  width: 20.h,
                ),
                const Gap(2),
                const CustomText(
                  text: "....",
                  color: AppColors.whiteColor,
                ),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            // _openBrowser(controller.postModel.value.data?.podcast?.creator?.donations ?? "");
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: AppColors.blackColor,
              border: Border.all(
                color: AppColors.whiteColor,
              ),
            ),
            child: const CustomText(
              text: "Give",
              color: AppColors.whiteColor,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _openBrowser(String urlString) async {
    try {
      final Uri url = Uri.parse(urlString);
      if (await canLaunchUrl(url)) {
        await launchUrl(
          url,
          mode: LaunchMode.externalApplication,
        );
      } else {
        toastMessage(message: "Donations URL not found");
      }
    } catch (e) {
      toastMessage(message: "Donations URL not found");
    }
  }

  Future<void> showModel({
    required BuildContext context,
    required PodcastFeedController feedController,
    required String id,
  }) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black,
      builder: (context) {
        return _CommentsSheet(
          feedController: feedController,
          id: id,
        );
      },
    );
  }
}

class _CommentsSheet extends StatefulWidget {
  final PodcastFeedController feedController;
  final String id;

  const _CommentsSheet({
    required this.feedController,
    required this.id,
  });

  @override
  State<_CommentsSheet> createState() => _CommentsSheetState();
}

class _CommentsSheetState extends State<_CommentsSheet> {
  late final PagingController<int, CommentItem> commentsPagingController;
  late final TextEditingController comments;
  late final ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    comments = TextEditingController();
    scrollController = ScrollController();
    commentsPagingController = PagingController<int, CommentItem>(firstPageKey: 1);

    commentsPagingController.addPageRequestListener((pageKey) {
      widget.feedController.getComments(
        id: widget.id,
        page: pageKey,
        commentsPagingController: commentsPagingController,
      );
    });
  }

  @override
  void dispose() {
    comments.dispose();
    commentsPagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.4,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return Column(
            children: [
              const SizedBox(height: 12),
              Container(
                height: 3,
                width: 45,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                "Comments",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              Divider(color: Colors.white.withValues(alpha: 0.1)),
              Expanded(
                child: PagedListView<int, CommentItem>(
                  scrollController: scrollController,
                  pagingController: commentsPagingController,
                  builderDelegate: PagedChildBuilderDelegate<CommentItem>(
                    itemBuilder: (context, item, index) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: CachedNetworkImageProvider(
                            item.commentorProfileImage ?? AppConstants.defaultCoverImage,
                          ),
                        ),
                        title: Text(
                          "${item.commentorName ?? ""} • ${GetTimeAgo.parse(item.updatedAt ?? DateTime.now())}",
                          style: const TextStyle(fontSize: 12, color: Colors.white),
                        ),
                        subtitle: Text(
                          item.text ?? "",
                          maxLines: 2,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.7),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                  child: CustomTextField(
                    controller: comments,
                    hintText: "Write a comment...",
                    maxLines: 3,
                    minLines: 1,
                    suffixIcon: IconButton(
                      icon: const Icon(Iconsax.send_1, color: Colors.white),
                      onPressed: () {
                        widget.feedController.addComments(
                          id: widget.id,
                          comments: comments,
                          commentsPagingController: commentsPagingController,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
