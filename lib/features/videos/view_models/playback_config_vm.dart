import 'package:flutter/material.dart';
import 'package:tiktok_clone_2nd/features/videos/models/playback_config_model.dart';
import 'package:tiktok_clone_2nd/features/videos/repos/playback_config_repo.dart';

class PlaybackConfigViewModel extends ChangeNotifier {
  final PlaybackConfigrepository _repository;

  // Repository로 Model을 초기화한다.
  late final PlaybackConfigModel _model = PlaybackConfigModel(
    muted: _repository.isMuted(),
    autoplay: _repository.isAutoplay(),
  );

  PlaybackConfigViewModel(this._repository);

  bool get muted => _model.muted;

  bool get autoplay => _model.autoplay;

  void setMuted(bool value) {
    _repository.setMuted(value);
    _model.muted = value;
    // 청취자에 변경사항을 알린다.
    notifyListeners();
  }

  void setAutoplay(bool value) {
    _repository.setAutoplay(value);
    _model.autoplay = value;
    // 청취자에 변경사항을 알린다.
    notifyListeners();
  }
}
