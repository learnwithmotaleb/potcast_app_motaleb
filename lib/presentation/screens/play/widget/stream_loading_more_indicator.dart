import 'package:flutter/material.dart';
import 'package:podcast/presentation/screens/play/controller/podcast_manually_play_controller.dart';

/// Visual indicator showing when more podcasts are being loaded
class StreamLoadingMoreIndicator extends StatelessWidget {
  const StreamLoadingMoreIndicator({
    super.key,
    required this.controller,
  });

  final PodcastManuallyPlayController controller;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<dynamic>>(
      stream: controller.itemsStream,
      initialData: controller.items,
      builder: (context, snapshot) {
        final isLoading = controller.isLoadingMore;
        final totalItems = controller.items.length;

        if (!isLoading) return const SizedBox.shrink();

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.7),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(
                    Colors.white.withOpacity(0.9),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'Loading more... ($totalItems podcasts)',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Extended version with more details
class StreamLoadingMoreIndicatorDetailed extends StatelessWidget {
  const StreamLoadingMoreIndicatorDetailed({
    super.key,
    required this.controller,
    this.showItemCount = true,
    this.position = LoadingIndicatorPosition.bottom,
  });

  final PodcastManuallyPlayController controller;
  final bool showItemCount;
  final LoadingIndicatorPosition position;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<dynamic>>(
      stream: controller.itemsStream,
      initialData: controller.items,
      builder: (context, snapshot) {
        final isLoading = controller.isLoadingMore;
        final totalItems = controller.items.length;
        final currentIndex = controller.audioPlayer.currentIndex ?? 0;
        final remainingItems = totalItems - currentIndex;

        if (!isLoading) return const SizedBox.shrink();

        return AnimatedOpacity(
          opacity: isLoading ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 300),
          child: Container(
            margin: EdgeInsets.only(
              top: position == LoadingIndicatorPosition.top ? 8 : 0,
              bottom: position == LoadingIndicatorPosition.bottom ? 8 : 0,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blue.withOpacity(0.15),
                  Colors.purple.withOpacity(0.15),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation(
                          Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Loading more podcasts...',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.95),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (showItemCount) ...[
                          const SizedBox(height: 2),
                          Text(
                            '$remainingItems remaining • $totalItems total',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

enum LoadingIndicatorPosition { top, bottom }

/// Floating indicator that appears at the bottom of screen
class StreamLoadingMoreFloatingIndicator extends StatelessWidget {
  const StreamLoadingMoreFloatingIndicator({
    super.key,
    required this.controller,
  });

  final PodcastManuallyPlayController controller;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<dynamic>>(
      stream: controller.itemsStream,
      initialData: controller.items,
      builder: (context, snapshot) {
        final isLoading = controller.isLoadingMore;

        if (!isLoading) return const SizedBox.shrink();

        return Positioned(
          bottom: 100, // Above player controls
          left: 0,
          right: 0,
          child: Center(
            child: AnimatedSlide(
              offset: isLoading ? Offset.zero : const Offset(0, 2),
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.15),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 12,
                      spreadRadius: 2,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(
                          Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Loading more...',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.95),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
