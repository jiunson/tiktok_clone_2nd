import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone_2nd/features/videos/view_models/%08timeline_view_model.dart';
import 'package:tiktok_clone_2nd/features/videos/views/widgets/video_post.dart';

class VideoTimelineScreen extends ConsumerStatefulWidget {
  const VideoTimelineScreen({super.key});

  @override
  VideoTimelineScreenState createState() => VideoTimelineScreenState();
}

class VideoTimelineScreenState extends ConsumerState<VideoTimelineScreen> {
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
    /* _pageController.nextPage(
      duration: _scrollDuration,
      curve: _scrollCurve,
    ); */
  }

  Future<void> _onRefresh() {
    return Future.delayed(
      const Duration(seconds: 5),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(timelineProvider).when(
          // 로딩중일때
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          // 에러가 발생했을 때
          error: (error, stackTrace) => Center(
            child: Text(
              'Could not laod videos: $error',
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          // 데이타를 가졌을 때
          data: (videos) => RefreshIndicator(
            onRefresh: _onRefresh,
            displacement: 50,
            edgeOffset: 20,
            color: Theme.of(context).primaryColor,
            child: PageView.builder(
              controller: _pageController,
              pageSnapping: true,
              scrollDirection: Axis.vertical,
              onPageChanged: _onPageChanged,
              itemCount: videos.length,
              itemBuilder: (context, index) => VideoPost(
                onVideoFinished: _onVideoFinished,
                index: index,
              ),
            ),
          ),
        );
  }
}
