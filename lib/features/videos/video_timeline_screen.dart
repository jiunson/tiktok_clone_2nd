import 'package:flutter/material.dart';
import 'package:tiktok_clone_2nd/features/videos/widgets/video_post.dart';

class VideoTimelineScreen extends StatefulWidget {
  const VideoTimelineScreen({super.key});

  @override
  State<VideoTimelineScreen> createState() => _VideoTimelineScreenState();
}

class _VideoTimelineScreenState extends State<VideoTimelineScreen> {
  int _itemCount = 4;

  final PageController _pageController = PageController();
  final Duration _scrollDuration = const Duration(milliseconds: 250);
  final Curve _scrollCurve = Curves.linear;

  void _onPageChanged(int page) {
    _pageController.animateToPage(
      page,
      duration: _scrollDuration,
      curve: _scrollCurve,
    );

    // 현재 페이지가 마지막 페이지-1이면 4 페이지 추가 -> 무한페이지 설정
    if (page == _itemCount - 1) {
      _itemCount = _itemCount + 4;
      setState(() {});
    }
  }

  void _onVideoFinished() {
    _pageController.nextPage(
      duration: _scrollDuration,
      curve: _scrollCurve,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      pageSnapping: true,
      scrollDirection: Axis.vertical,
      onPageChanged: _onPageChanged,
      itemCount: _itemCount,
      itemBuilder: (context, index) => VideoPost(
        onVideoFinished: _onVideoFinished,
        index: index,
      ),
    );
  }
}
