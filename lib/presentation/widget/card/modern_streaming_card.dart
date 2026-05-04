import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:podcast/helper/image/network_image.dart';
import 'package:podcast/model/route/audio_player_model.dart';
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';

class ModernStreamingCard extends StatelessWidget {
  const ModernStreamingCard({
    super.key,
    required this.data,
    required this.onTap,
    this.onLongPress,
    this.isLive = false,
  });

  final AudioPlayerModel data;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final bool isLive;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(right: 12.0),
      child: GestureDetector(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Container(
          width: (width / 2) - 30,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                theme.colorScheme.surface,
                theme.colorScheme.surface.withOpacity(0.8),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: theme.shadowColor.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
            border: Border.all(
              color: theme.colorScheme.outline.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                        ),
                      ),
                      child: ClipRRect(

                        child: CustomNetworkImage(
                          imageUrl: data.image,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    // Live Badge
                    if (isLive)
                      Positioned(
                        top: 12,
                        right: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.red.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const Gap(4),
                              const Text(
                                'LIVE',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    // Gradient Overlay at bottom of image
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.3),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              CustomText(
                text: data.title,
                fontSize: 16,
                left: 4,
                right: 4,
                bottom: 12,
                textAlign: TextAlign.start,
                fontWeight: FontWeight.w700,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Updated Sliver Section for Modern UI
Widget buildModernStreamingSection({
  required List<dynamic>? albumItem,
  required BuildContext context,
}) {
  return SliverList(
    delegate: SliverChildListDelegate([
      const Gap(8),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomText(
                  text: "Live Streaming",
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
                const Gap(4),
                Text(
                  "Discover trending live shows",
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextButton.icon(
                onPressed: () {
                  // AppRouter.route.pushNamed(RoutePath.albumSeeAllScreen);
                },
                icon: Icon(
                  Icons.arrow_forward,
                  size: 16,
                  color: Theme.of(context).colorScheme.primary,
                ),
                label: Text(
                  "See All",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      const Gap(16),
      SizedBox(
        height: 280,
        child: ListView.builder(
          padding: const EdgeInsets.only(left: 16, right: 4),
          itemCount: albumItem?.length ?? 0,
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, int index) {
            return ModernStreamingCard(
              data: AudioPlayerModel(
                id: albumItem?[index].id ?? "",
                title: albumItem?[index].name ?? "",
                categories: albumItem?[index].description,
                image: albumItem?[index].coverImage ?? "",
                duration: "LIVE", // or formatDuration(0) for recorded content
                url: "",
              ),
              isLive: true, // Set to true for live streams
              onTap: () {
                // AppRouter.route.pushNamed(
                //   RoutePath.albumPodcastScreen,
                //   extra: {
                //     "title": albumItem?[index].name,
                //     "id": albumItem?[index].id,
                //   },
                // );
              },
            );
          },
        ),
      ),
      const Gap(24),
    ]),
  );
}