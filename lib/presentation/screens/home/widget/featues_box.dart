import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:podcast/core/route/route_path.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/helper/image/network_image.dart';
import 'package:podcast/presentation/screens/home/controller/user_home_controller.dart';
import 'package:podcast/presentation/screens/home/model/home_model.dart';
import 'package:podcast/presentation/widget/custom_text/custom_text.dart';

class FeatureBox extends StatelessWidget {
  const FeatureBox({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<UserHomeController>();

    return Obx(() {
      final List<HomeAlbumItem> albums;

      if (ctrl.model.value.data?.albums != null &&
          ctrl.model.value.data!.albums!.isNotEmpty) {
        albums = ctrl.model.value.data!.albums!;
      } else {
        // Fallback dynamic dummy data so the UI is visible during development
        albums = [
          HomeAlbumItem(
            id: '1',
            name: 'Mr. Sexy Man: The Album',
            description: 'Nellie Tiger Travis',
            coverImage:
                'https://i.scdn.co/image/ab67616d0000b273b5b1574a7b7484a919f2d1e0',
          ),
          HomeAlbumItem(
            id: '2',
            name: 'Changes',
            description: 'Christopher Williams',
            coverImage:
                'https://i.scdn.co/image/ab67616d0000b273dbd32c58963cb5f23d463db8',
          ),
          HomeAlbumItem(
            id: '3',
            name: 'So So Def Bass All-Stars Vol. II',
            description: 'Various Artists',
            coverImage:
                'https://i.scdn.co/image/ab67616d0000b273dc7bb0ab7d079ebcb802058f',
          ),
          HomeAlbumItem(
            id: '4',
            name: 'Greatest Hits',
            description: '2Pac',
            coverImage:
                'https://i.scdn.co/image/ab67616d0000b27387cc8e7d7a17ddf0fb01b44c',
          ),
        ];
      }

      if (albums.isEmpty) return const SizedBox.shrink();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: CustomText(
                    text: "Albums featuring songs",
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    textAlign: TextAlign.start,
                    maxLines: 1,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    AppRouter.route.pushNamed(RoutePath.albumSeeAllScreen);
                  },
                  child: Text("see_all".tr,
                      style: const TextStyle(color: Colors.white70)),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 220,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              scrollDirection: Axis.horizontal,
              itemCount: albums.length,
              itemBuilder: (context, index) {
                final album = albums[index];
                return _FeatureAlbumCard(album: album);
              },
            ),
          ),
        ],
      );
    });
  }
}

class _FeatureAlbumCard extends StatelessWidget {
  final HomeAlbumItem album;
  const _FeatureAlbumCard({required this.album});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AppRouter.route.pushNamed(
          RoutePath.albumPodcastScreen,
          extra: {
            'id': album.id,
            'title': album.name ?? '',
          },
        );
      },
      child: Container(
        width: 140,
        margin: const EdgeInsets.only(right: 14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: CustomNetworkImage(
                imageUrl:
                    album.coverImage != null && album.coverImage!.isNotEmpty
                        ? (album.coverImage!.startsWith('http')
                            ? album.coverImage!
                            : 'https://api.preachradio.com${album.coverImage!}')
                        : '',
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const Gap(10),
            CustomText(
              text: album.name ?? '',
              fontSize: 14,
              fontWeight: FontWeight.w700,
              maxLines: 1,
              textAlign: TextAlign.start,
              overflow: TextOverflow.ellipsis,
              color: Colors.white,
            ),
            const Gap(4),
            CustomText(
              text: album.description ?? 'Various Artists',
              fontSize: 12,
              color: Colors.white54,
              maxLines: 2,
              textAlign: TextAlign.start,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
