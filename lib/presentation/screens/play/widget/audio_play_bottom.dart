import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:podcast/utils/app_const/app_const.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controller/podcast_play_controller.dart';
import '../model/comment_model.dart';

class AudioPlayBottom extends StatelessWidget {
  const AudioPlayBottom({
    super.key,
    required this.controller,
  });

  final PodcastFeedController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final currentItem = controller.currentItem.value;
      final itemId = currentItem?.id ?? "";

      return Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildActionButton(
              onTap: itemId.isNotEmpty ? () => showModel(
                context: context,
                feedController: controller,
                id: itemId,
              ) : null,
              icon: Icons.comment_outlined,
              label: "Comments",
              enabled: itemId.isNotEmpty,
            ),
            _buildActionButton(
              onTap: () {
                final donationUrl = currentItem?.creator?.donationLink ?? "";
                if (donationUrl.isNotEmpty) {
                  _openBrowser(donationUrl);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Donation not available'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              icon: Icons.volunteer_activism_outlined,
              label: "Support",
              enabled: true,
            ),
          ],
        ),
      );
    });
  }

  Widget _buildActionButton({
    required VoidCallback? onTap,
    required IconData icon,
    required String label,
    required bool enabled,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: enabled ? Colors.white.withOpacity(0.3) : Colors.grey.withOpacity(0.2),
            width: 1,
          ),
          color: Colors.white.withOpacity(0.05),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 20,
              color: enabled ? Colors.white : Colors.grey,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: enabled ? Colors.white : Colors.grey,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
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
        debugPrint("Cannot open URL: $urlString");
      }
    } catch (e) {
      debugPrint("Error opening URL: $e");
    }
  }

  Future<void> showModel({
    required BuildContext context,
    required PodcastFeedController feedController,
    required String id,
  }) async {
    if (id.isEmpty) return;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
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
  late final TextEditingController commentController;
  bool isAddingComment = false;

  @override
  void initState() {
    super.initState();
    commentController = TextEditingController();
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
    commentController.dispose();
    commentsPagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Padding(
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
                  height: 4,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Comments",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Divider(color: Colors.white.withOpacity(0.1), thickness: 1),
                Expanded(
                  child: PagedListView<int, CommentItem>(
                    scrollController: scrollController,
                    pagingController: commentsPagingController,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    builderDelegate: PagedChildBuilderDelegate<CommentItem>(
                      itemBuilder: (context, item, index) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundImage: CachedNetworkImageProvider(
                                  item.commentorProfileImage ?? AppConstants.defaultCoverImage,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          item.commentorName ?? "",
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          GetTimeAgo.parse(item.updatedAt ?? DateTime.now()),
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.white.withOpacity(0.6),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      item.text ?? "",
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.9),
                                        fontSize: 14,
                                        height: 1.4,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      noItemsFoundIndicatorBuilder: (context) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(48),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.comment_outlined,
                                  size: 48,
                                  color: Colors.white.withOpacity(0.3),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No comments yet',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.7),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Be the first to comment!',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.5),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      firstPageErrorIndicatorBuilder: (context) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(48),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  size: 48,
                                  color: Colors.white.withOpacity(0.3),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Failed to load comments',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.7),
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () => commentsPagingController.refresh(),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.black,
                                  ),
                                  child: const Text('Retry'),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SafeArea(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: Colors.white.withOpacity(0.1),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: TextField(
                              controller: commentController,
                              enabled: !isAddingComment,
                              maxLines: null,
                              minLines: 1,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                              decoration: InputDecoration(
                                hintText: "Write a comment...",
                                hintStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.5),
                                  fontSize: 16,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: isAddingComment ? null : _handleAddComment,
                          child: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: isAddingComment
                                  ? Colors.grey.withOpacity(0.3)
                                  : Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: isAddingComment
                                  ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                                  : const Icon(
                                Icons.send,
                                color: Colors.black,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _handleAddComment() async {
    if (commentController.text.trim().isEmpty || isAddingComment) {
      return;
    }

    setState(() {
      isAddingComment = true;
    });

    try {
      await widget.feedController.addComment(
        id: widget.id,
        commentController: commentController,
        commentsPagingController: commentsPagingController,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Failed to add comment"),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isAddingComment = false;
        });
      }
    }
  }
}