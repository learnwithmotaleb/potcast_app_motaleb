// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:iconsax_flutter/iconsax_flutter.dart';
// import 'package:podcast/presentation/widget/loading/loading_widget.dart';
// import 'package:podcast/presentation/widget/no_internet/no_internet_card.dart';
// import 'package:video_player/video_player.dart';
// import 'controller/podcast_play_controller.dart';
// import 'widget/buffer_animation_widget.dart';

// class RecordPlayScreen extends StatefulWidget {
//   const RecordPlayScreen({
//     super.key,
//     required this.url,
//     this.startPosition = Duration.zero,
//   });

//   final String url;
//   final Duration startPosition;

//   @override
//   State<RecordPlayScreen> createState() => _RecordPlayScreenState();
// }

// class _RecordPlayScreenState extends State<RecordPlayScreen> {
//   VideoPlayerController? _videoPlayerController;
//   final ValueNotifier<bool> _isLoading = ValueNotifier(true);
//   final ValueNotifier<bool> _isError = ValueNotifier(false);
//   final ValueNotifier<bool> _isPlay = ValueNotifier(false);
//   final ValueNotifier<bool> _showIcon = ValueNotifier(false);

//   @override
//   void initState() {
//     super.initState();
    
//     // Stop audio playback first
//     final feedController = Get.find<PodcastFeedController>();
//     feedController.stopAudioIfPlaying();
    
//     _initializeVideo(widget.url);
//   }

//   Future<void> _initializeVideo(String videoUrl) async {
//     try {
//       if (kDebugMode) {
//         print(videoUrl);
//       }
//       final Uri uri = Uri.parse(videoUrl);
//       _videoPlayerController = VideoPlayerController.networkUrl(uri);
      
//       await _videoPlayerController!.initialize();
      
//       if (mounted) {
//         _isLoading.value = false;
        
//         // Seek to start position if provided
//         await _seekToStartPosition();
        
//         // Auto play
//         _videoPlayerController!.play();
//         _isPlay.value = true;
//       }
//     } catch (e) {
//       if (mounted) {
//         _isLoading.value = false;
//         _isError.value = true;
//       }
//       if (kDebugMode) {
//         print('Error initializing video: $e');
//       }
//     }
//   }

//   void _handleBackNavigation() {
//     try {
//       final currentPosition = _videoPlayerController?.value.position ?? Duration.zero;
//       final feedController = Get.find<PodcastFeedController>();

//       if (currentPosition > Duration.zero) {
//         feedController.seek(currentPosition).then((_) {
//           feedController.togglePlayPause();
//         });
//       }

//       debugPrint('🎵 Resuming audio at: $currentPosition');
//     } catch (e) {
//       debugPrint('Error resuming audio: $e');
//     }
//   }

//   Future<void> _seekToStartPosition() async {
//     if (widget.startPosition > Duration.zero && _videoPlayerController != null) {
//       await _videoPlayerController!.seekTo(widget.startPosition);
//       debugPrint('🎬 Seeked to: ${widget.startPosition}');
//     }
//   }

//   Future<void> togglePlayPause() async {
//     try {
//       final controller = _videoPlayerController;
//       if (controller != null && controller.value.isInitialized) {
//         if (controller.value.isPlaying) {
//           controller.pause();
//           _isPlay.value = false;
//         } else {
//           controller.play();
//           _isPlay.value = true;
//         }

//         _showIcon.value = true;
//         Future.delayed(const Duration(seconds: 2), () {
//           if (mounted) {
//             _showIcon.value = false;
//           }
//         });
//       }
//     } catch (e) {
//       if (kDebugMode) {
//         print(e.toString());
//       }
//     }
//   }

//   @override
//   void dispose() {
//     _videoPlayerController?.dispose();
//     _isLoading.dispose();
//     _isError.dispose();
//     _isPlay.dispose();
//     _showIcon.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return PopScope(
//       onPopInvoked: (didPop) {
//         if (didPop) {
//           _handleBackNavigation();
//         }
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text("play_video".tr),
//           leading: IconButton(
//             icon: const Icon(Icons.arrow_back),
//             onPressed: () {
//               _handleBackNavigation();
//               Navigator.of(context).pop();
//             },
//           ),
//         ),
//         body: SafeArea(
//           top: false,
//           child: ValueListenableBuilder<bool>(
//             valueListenable: _isLoading,
//             builder: (context, isLoading, child) {
//               if (isLoading) {
//                 return const LoadingWidget();
//               }
//               return ValueListenableBuilder<bool>(
//                 valueListenable: _isError,
//                 builder: (context, isError, child) {
//                   if (isError) {
//                     return Center(
//                       child: NoInternetCard(onTap: () {
//                         _initializeVideo(widget.url);
//                       }),
//                     );
//                   }

//                   return _videoPlayerController != null &&
//                           _videoPlayerController!.value.isInitialized
//                       ? Stack(
//                           alignment: Alignment.center,
//                           children: [
//                             // Video player
//                             Positioned.fill(
//                               child: GestureDetector(
//                                 onTap: () => togglePlayPause(),
//                                 child: AspectRatio(
//                                   aspectRatio: _videoPlayerController!.value.aspectRatio,
//                                   child: VideoPlayer(_videoPlayerController!),
//                                 ),
//                               ),
//                             ),

//                             // Fade animated play/pause icon
//                             ValueListenableBuilder<bool>(
//                               valueListenable: _showIcon,
//                               builder: (context, showIcon, child) {
//                                 return AnimatedOpacity(
//                                   opacity: showIcon ? 1.0 : 0.0,
//                                   duration: const Duration(milliseconds: 300),
//                                   child: ValueListenableBuilder<bool>(
//                                     valueListenable: _isPlay,
//                                     builder: (context, isPlay, _) {
//                                       return Center(
//                                         child: Container(
//                                           height: 45,
//                                           width: 45,
//                                           decoration: BoxDecoration(
//                                             color: Colors.black.withOpacity(0.4),
//                                             shape: BoxShape.circle,
//                                           ),
//                                           child: Icon(
//                                             isPlay ? Iconsax.pause : Iconsax.play,
//                                             size: 20,
//                                             color: Colors.white,
//                                           ),
//                                         ),
//                                       );
//                                     },
//                                   ),
//                                 );
//                               },
//                             ),

//                             // Buffer animation
//                             if (_videoPlayerController?.value.isBuffering ?? false)
//                               const Positioned(
//                                 bottom: 0,
//                                 left: 0,
//                                 right: 0,
//                                 child: CenterOutBufferBar(),
//                               ),
//                           ],
//                         )
//                       : Center(child: Text("no_items_found".tr));
//                 },
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
