import 'package:flutter/material.dart';
import 'package:podcast/presentation/screens/play/widget/web_view.dart';

import 'package:share_plus/share_plus.dart';
import 'package:podcast/core/custom_assets/assets.gen.dart';
import 'package:podcast/presentation/screens/play/controller/podcast_manually_play_controller.dart';
import 'package:podcast/presentation/screens/play/model/play_entity.dart';
import 'package:podcast/presentation/screens/play/widget/stream_comments_bottom_sheet.dart';

class StreamAudioPlayBottom extends StatelessWidget {
  const StreamAudioPlayBottom({
    super.key,
    required this.controller,
  });

  final PodcastManuallyPlayController controller;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: controller.currentItemStream,
      initialData: controller.currentItem,
      builder: (context, snapshot) {
        final currentItem = snapshot.data;
        final hasCurrentItem = currentItem != null;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildCommentButton(
                  hasCurrentItem, currentItem?.id ?? "", context),
              _buildShareButton(hasCurrentItem, currentItem),
              _buildDonateButton(hasCurrentItem, currentItem, context),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCommentButton(
      bool hasCurrentItem, String id, BuildContext context) {
    return _buildActionButton(
      onPressed: hasCurrentItem ? () => _showComments(id, context) : null,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Assets.icons.comments.svg(
            height: 24,
            width: 24,
            colorFilter: ColorFilter.mode(
              hasCurrentItem ? Colors.white70 : Colors.white38,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Comments',
            style: TextStyle(
              color: hasCurrentItem ? Colors.white70 : Colors.white38,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShareButton(bool hasCurrentItem, PlayEntity? item) {
    return _buildActionButton(
      onPressed: hasCurrentItem ? () => _handleShare(item) : null,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.share,
            size: 24,
            color: hasCurrentItem ? Colors.white70 : Colors.white38,
          ),
          const SizedBox(height: 4),
          Text(
            'Share',
            style: TextStyle(
              color: hasCurrentItem ? Colors.white70 : Colors.white38,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDonateButton(
      bool hasCurrentItem, PlayEntity? item, BuildContext context) {
    return _buildActionButton(
      onPressed: hasCurrentItem
          ? () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const WebViewScreen(
                    url: 'https://rakibx.webflow.io/',
                    title: 'Donate',
                  ),
                ),
              )
          : null,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.diamond,
            size: 24,
            color: hasCurrentItem ? Colors.white70 : Colors.white38,
          ),
          const SizedBox(height: 4),
          Text(
            'Support',
            style: TextStyle(
              color: hasCurrentItem ? Colors.white70 : Colors.white38,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required VoidCallback? onPressed,
    required Widget child,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 150),
        opacity: onPressed != null ? 1.0 : 0.5,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: child,
        ),
      ),
    );
  }

  void _showComments(String id, BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StreamCommentsBottomSheet(
        controller: controller,
        podcastId: id,
      ),
    );
  }

  void _handleShare(PlayEntity? item) {
    if (item == null) return;

    final String title = item.title;
    // TODO: Replace with your actual domain/deep link URL
    final String deepLink = "https://preachradio.com/podcast/${item.id}";
    final String shareText =
        "Check out this podcast: $title\n\nListen here: $deepLink";

    Share.share(shareText, subject: title);
  }
}
