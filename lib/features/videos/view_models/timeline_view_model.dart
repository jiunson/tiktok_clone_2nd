import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone_2nd/features/videos/models/video_model.dart';

// ViewModel 작성
class TimelineViewModel extends AsyncNotifier<List<VideoModel>> {
  List<VideoModel> _list = [];

  // 비즈니스 로직 작성
  Future<void> uploadVideo() async {
    // 시뮬레이션으로 강제 지연 설정
    state = const AsyncValue.loading(); // state를 loading state로 설정한다.
    await Future.delayed(const Duration(seconds: 2)); // 2초 지연.

    final newVideo = VideoModel(
      title: "${DateTime.now()}",
      description: "",
      fileUrl: "",
      thumbnailUrl: "",
      creatorUid: "",
      likes: 0,
      comments: 0,
      createAt: 0,
    );

    // 새 비디오 추가
    // 기존 데이터 + 새로운 데이터를 추가 후 AsyncValue.data()로 state에 새로운 값을 넣어준다.
    _list = [..._list, newVideo];
    state = AsyncValue.data(_list);
  }

  // 화면에 사용할 초기 데이터(Future 또는 VideoModel의 List)를 반환한다.
  @override
  FutureOr<List<VideoModel>> build() async {
    // API를 호출 후 데이터를 반환 처리하는 로직
    await Future.delayed(const Duration(seconds: 5)); // 시뮬레이션을 위한 딜레이 설정.
    return _list;
  }
}

// Provider<ViewModel, Model>(ViewModel을 초기화하는 함수) 작성
final timelineProvider =
    AsyncNotifierProvider<TimelineViewModel, List<VideoModel>>(
  () => TimelineViewModel(),
);
