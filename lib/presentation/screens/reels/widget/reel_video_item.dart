import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:podcast/core/route/route_path.dart';
import 'package:podcast/helper/image/network_image.dart';
import 'package:podcast/presentation/screens/play/controller/podcast_manually_play_controller.dart';
import 'package:podcast/presentation/screens/play/model/play_entity.dart';
import 'package:podcast/presentation/screens/play/widget/stream_comments_bottom_sheet.dart';
import 'package:podcast/presentation/screens/reels/controller/reels_controller.dart';
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';
import 'package:podcast/presentation/widget/loading/loading_widget.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';

class ReelVideoItem extends StatefulWidget {
  final PlayEntity item;
  final bool isActive;
  final VoidCallback? onError;

  const ReelVideoItem({
    super.key,
    required this.item,
    required this.isActive,
    this.onError,
  });

  @override
  State<ReelVideoItem> createState() => _ReelVideoItemState();
}

class _ReelVideoItemState extends State<ReelVideoItem> {
  VideoPlayerController? _videoPlayerController;
  bool _isLoading = true;
  bool _isError = false;
  String _errorMessage = "";
  bool _showIcon = false;
  bool _isLiked = false;
  bool _likeLoading = false;
  bool _isFavorite = false;
  bool _favoriteLoading = false;
  bool _isFollowing = false;

  @override
  void initState() {
    super.initState();
    _isLiked = widget.item.isLike ?? false;
    _isFavorite = widget.item.isBookmark ?? false;
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      final url = widget.item.podcastUrl;
      if (url.isEmpty) {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _isError = true;
            _errorMessage = "Media URL is empty";
          });
        }
        return;
      }

      _videoPlayerController?.dispose();
      _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(url));
      await _videoPlayerController!.initialize();

      if (!mounted) return;

      if (_videoPlayerController!.value.hasError) {
        setState(() {
          _isLoading = false;
          _isError = true;
          _errorMessage = "This media format is not supported or link is broken.";
        });
        widget.onError?.call();
        return;
      }

      _videoPlayerController!.setLooping(true);

      if (widget.isActive) {
        _videoPlayerController!.play();
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("❌ Video init error: $e");
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isError = true;
          _errorMessage = "This media format is not supported or link is broken.";
        });
      }
      widget.onError?.call();
    }
  }

  void _togglePlayPause() {
    if (_videoPlayerController == null ||
        !_videoPlayerController!.value.isInitialized) {
      return;
    }

    setState(() {
      _showIcon = true;
      if (_videoPlayerController!.value.isPlaying) {
        _videoPlayerController!.pause();
      } else {
        _videoPlayerController!.play();
      }
    });

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _showIcon = false;
        });
      }
    });
  }

  Future<void> _toggleLike() async {
    if (_likeLoading) return;

    setState(() {
      _likeLoading = true;
    });

    try {
      final podcastController = Get.find<PodcastManuallyPlayController>();
      final newState = await podcastController.likePodcast(
        id: widget.item.id,
        currentState: _isLiked,
      );

      if (mounted) {
        setState(() {
          _isLiked = newState;
        });
      }
    } catch (e) {
      debugPrint("Error toggling like: $e");
    } finally {
      if (mounted) {
        setState(() {
          _likeLoading = false;
        });
      }
    }
  }

  Future<void> _toggleFavorite() async {
    if (_favoriteLoading) return;

    setState(() {
      _favoriteLoading = true;
    });

    try {
      final podcastController = Get.find<PodcastManuallyPlayController>();
      final newState = await podcastController.favoritePodcast(
        id: widget.item.id,
        currentState: _isFavorite,
      );

      if (mounted) {
        setState(() {
          _isFavorite = newState;
        });
      }
    } catch (e) {
      debugPrint("Error toggling favorite: $e");
    } finally {
      if (mounted) {
        setState(() {
          _favoriteLoading = false;
        });
      }
    }
  }

  void _toggleFollow() {
    setState(() {
      _isFollowing = !_isFollowing;
    });
  }

  void _shareReel() {
    final String title = widget.item.title;
    final String deepLink =
        "https://preachradio.com/podcast/${widget.item.id}";
    final String shareText =
        "Check out this reel: $title\n\nWatch here: $deepLink";
    Share.share(shareText, subject: title);
  }

  void _showComments() {
    try {
      final podcastController = Get.find<PodcastManuallyPlayController>();
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => StreamCommentsBottomSheet(
          controller: podcastController,
          podcastId: widget.item.id,
        ),
      );
    } catch (e) {
      debugPrint("❌ Cannot open comments: $e");
    }
  }

  void _showMoreOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1C1D22),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Gap(12),
            Container(
              height: 4,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const Gap(16),
            ListTile(
              leading: const Icon(Icons.link, color: Colors.white70),
              title: const CustomText(
                text: "Copy link",
                color: Colors.white,
                textAlign: TextAlign.start,
              ),
              onTap: () {
                Navigator.pop(context);
                final link =
                    "https://preachradio.com/podcast/${widget.item.id}";
                Clipboard.setData(ClipboardData(text: link));
              },
            ),
            ListTile(
              leading: const Icon(Icons.flag_outlined, color: Colors.white70),
              title: const CustomText(
                text: "Report",
                color: Colors.white,
                textAlign: TextAlign.start,
              ),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.close, color: Colors.white70),
              title: const CustomText(
                text: "Cancel",
                color: Colors.white,
                textAlign: TextAlign.start,
              ),
              onTap: () => Navigator.pop(context),
            ),
            const Gap(8),
          ],
        ),
      ),
    );
  }

  void _navigateToStationProfile() {
    try {
      final reelsController = Get.find<ReelsController>();
      final stationId = reelsController.stationId;
      if (stationId != null && stationId.isNotEmpty) {
        context.pushNamed(
          RoutePath.stationProfileScreen,
          extra: stationId,
        );
      }
    } catch (e) {
      debugPrint("❌ Cannot navigate to station profile: $e");
    }
  }

  @override
  void didUpdateWidget(covariant ReelVideoItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_videoPlayerController != null &&
        _videoPlayerController!.value.isInitialized) {
      if (widget.isActive && !oldWidget.isActive) {
        _videoPlayerController!.play();
      } else if (!widget.isActive && oldWidget.isActive) {
        _videoPlayerController!.pause();
        _videoPlayerController!.seekTo(Duration.zero);
      }
    }
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        color: Colors.black,
        child: const Center(child: LoadingWidget()),
      );
    }

    if (_isError ||
        _videoPlayerController == null ||
        _videoPlayerController!.value.hasError) {
      return Container(
        color: Colors.black,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline,
                    color: Colors.white54, size: 48),
                const SizedBox(height: 16),
                Text(
                  _errorMessage.isNotEmpty
                      ? _errorMessage
                      : "Error playing media",
                  style: const TextStyle(color: Colors.white54),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _isLoading = true;
                      _isError = false;
                      _errorMessage = "";
                    });
                    _initializeVideo();
                  },
                  icon: const Icon(Icons.refresh, size: 18),
                  label: const Text("Retry"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white24,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final isPlaying = _videoPlayerController!.value.isPlaying;
    final isAudioOnly = _videoPlayerController!.value.size.width == 0 ||
        _videoPlayerController!.value.size.height == 0;

    return GestureDetector(
      onTap: _togglePlayPause,
      child: Container(
        color: Colors.black,
        child: Stack(
          alignment: Alignment.center,
          fit: StackFit.expand,
          children: [
            // Video or cover image
            if (isAudioOnly)
              CustomNetworkImage(
                imageUrl: widget.item.coverImage,
                width: double.infinity,
                height: double.infinity,
                backgroundColor: Colors.grey.shade900,
              )
            else
              FittedBox(
                fit: BoxFit.contain,
                child: SizedBox(
                  width: _videoPlayerController!.value.size.width,
                  height: _videoPlayerController!.value.size.height,
                  child: VideoPlayer(_videoPlayerController!),
                ),
              ),

            // Bottom gradient overlay
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: 200,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.8),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            // Reel info (title + creator name)
            Positioned(
              bottom: 40,
              left: 16,
              right: 80,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.item.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Gap(8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: GestureDetector(
                          onTap: _navigateToStationProfile,
                          child: Text(
                            widget.item.creatorName ?? "",
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                              decoration: TextDecoration.underline,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      const Gap(10),
                      GestureDetector(
                        onTap: _toggleFollow,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: _isFollowing
                                ? Colors.white24
                                : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            _isFollowing ? "Following" : "Follow",
                            style: TextStyle(
                              color: _isFollowing
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Right side action buttons (Profile, Like, Comment, Favorite, Share, More)
            Positioned(
              right: 12,
              bottom: 100,
              child: Column(
                children: [
                  // Profile avatar
                  GestureDetector(
                    onTap: _navigateToStationProfile,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: const BoxDecoration(
                          color: Colors.grey,
                          shape: BoxShape.circle,
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: CustomNetworkImage(
                          imageUrl: widget.item.creatorImage ?? widget.item.coverImage,
                        ),
                      ),
                    ),
                  ),
                  const Gap(20),

                  // Like button
                  GestureDetector(
                    onTap: _toggleLike,
                    child: Column(
                      children: [
                        _likeLoading
                            ? const SizedBox(
                                height: 30,
                                width: 30,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Icon(
                                _isLiked ? Icons.favorite : Icons.favorite_border,
                                color: _isLiked ? Colors.red : Colors.white,
                                size: 30,
                              ),
                        const Gap(4),
                        CustomText(
                          text: _isLiked ? "Liked" : "Like",
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ],
                    ),
                  ),
                  const Gap(16),

                  // Comment button
                  GestureDetector(
                    onTap: _showComments,
                    child: const Column(
                      children: [
                        Icon(Iconsax.message, color: Colors.white, size: 28),
                        Gap(4),
                        CustomText(
                            text: "Comm.", color: Colors.white, fontSize: 12),
                      ],
                    ),
                  ),
                  const Gap(16),

                  // Favorite / bookmark button
                  GestureDetector(
                    onTap: _toggleFavorite,
                    child: Column(
                      children: [
                        _favoriteLoading
                            ? const SizedBox(
                                height: 28,
                                width: 28,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Icon(
                                _isFavorite
                                    ? Icons.bookmark
                                    : Icons.bookmark_border,
                                color:
                                    _isFavorite ? Colors.amber : Colors.white,
                                size: 28,
                              ),
                        const Gap(4),
                        CustomText(
                          text: _isFavorite ? "Saved" : "Save",
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ],
                    ),
                  ),
                  const Gap(16),

                  // Share button
                  GestureDetector(
                    onTap: _shareReel,
                    child: const Column(
                      children: [
                        Icon(Icons.share, color: Colors.white, size: 26),
                        Gap(4),
                        CustomText(
                            text: "Share", color: Colors.white, fontSize: 12),
                      ],
                    ),
                  ),
                  const Gap(16),

                  // More options button
                  GestureDetector(
                    onTap: _showMoreOptions,
                    child: const Icon(Icons.more_horiz,
                        color: Colors.white, size: 28),
                  ),
                ],
              ),
            ),

            // Play/Pause icon overlay
            if (_showIcon)
              Center(
                child: Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isPlaying ? Icons.play_arrow : Icons.pause,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
