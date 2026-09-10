import 'package:flutter/material.dart';
import 'package:podcast/presentation/screens/play/model/play_entity.dart';
import 'package:podcast/presentation/screens/reels/widget/reel_video_item.dart';

/// Lightweight reels-style viewer for the Home "Praise Clips" preview
/// (mock) items — plays straight from a local list instead of calling
/// the reels API, since these preview items don't exist on the backend
/// yet. Safe to delete once real Clip data is uploaded (see the mock
/// data block in user_home_screen.dart) — real clips already open the
/// full ReelsScreen via the API as usual.
class MockReelsPreviewScreen extends StatefulWidget {
  const MockReelsPreviewScreen({
    super.key,
    required this.items,
    this.initialIndex = 0,
  });

  final List<PlayEntity> items;
  final int initialIndex;

  @override
  State<MockReelsPreviewScreen> createState() =>
      _MockReelsPreviewScreenState();
}

class _MockReelsPreviewScreenState extends State<MockReelsPreviewScreen> {
  late final PageController _pageController;
  late int _activePage;

  @override
  void initState() {
    super.initState();
    _activePage = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        itemCount: widget.items.length,
        onPageChanged: (index) => setState(() => _activePage = index),
        itemBuilder: (context, index) {
          final item = widget.items[index];
          return ReelVideoItem(
            key: ValueKey(item.id),
            item: item,
            isActive: index == _activePage,
          );
        },
      ),
    );
  }
}
