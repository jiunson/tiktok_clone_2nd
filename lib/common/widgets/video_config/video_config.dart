import 'package:flutter/material.dart';

class VideoConfig extends ChangeNotifier {
  bool isMuted = false;
  bool isAutoplay = false;

  void toggleIsMuted() {
    isMuted = !isMuted;
    // 청취자(데이터 변경사항을 듣고 있는 화면)에게 알린다.
    notifyListeners();
  }

  void toggleIsAutoplay() {
    isAutoplay = !isAutoplay;
    // 청취자(데이터 변경사항을 듣고 있는 화면)에게 알린다.
    notifyListeners();
  }
}
