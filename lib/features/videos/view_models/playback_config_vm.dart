import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone_2nd/features/videos/models/playback_config_model.dart';
import 'package:tiktok_clone_2nd/features/videos/repos/playback_config_repo.dart';

// Notifier<Model> : Model은 화면에서 사용할 데이터 형식이다.
class PlaybackConfigViewModel extends Notifier<PlaybackConfigModel> {
  final PlaybackConfigrepository _repository;

  PlaybackConfigViewModel(this._repository);

  // 비즈니스 로직 작성.

  void setMuted(bool value) {
    _repository.setMuted(value);
    // Notifier에서는 state를 통해 데이터에 접근할 수 있다.
    // state는 바꿀(mutate) 수 없기 때문에 새 State로 대체해야 한다.
    // state가 대체되면 이때 모든 화면들이 새로고침하는 시점이다.
    state = PlaybackConfigModel(muted: value, autoplay: state.autoplay);
  }

  void setAutoplay(bool value) {
    _repository.setAutoplay(value);
    state = PlaybackConfigModel(muted: state.muted, autoplay: value);
  }

  // 화면에 사용할 초기의 데이터를 반환한다.
  @override
  build() {
    return PlaybackConfigModel(
      muted: _repository.isMuted(),
      autoplay: _repository.isAutoplay(),
    );
  }
}

// 특별한 케이스로 중요한 개념 설명 주석.
// NotifierProvider<ViewModel, Model>는 ViewModel을 반환한다.
// 하지만 NotifierProvider가 반환하는 ViewModel에게 전달해야 할 repository 매개변수가 main.dart에서 객체생성되기 때문에
// PlaybackConfigViewModel() 대신 throw UnimplementedError()로 대체한다.
// main.dart에서 앱이 시작하기 전, repository인 SharedPreferences를 생성 후 인수로 전달한 ViewModel를
// ProviderScpoe에서 override 설정하여 NotifierProvider를 초기화한다.
final playbackConfigProvider =
    NotifierProvider<PlaybackConfigViewModel, PlaybackConfigModel>(
  () => throw UnimplementedError(),
);
