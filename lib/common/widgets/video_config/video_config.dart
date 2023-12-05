import 'package:flutter/material.dart';

class VideoConfig extends InheritedWidget {
  const VideoConfig({
    super.key,
    required super.child,
  });

  // custom code
  final bool autoMute = false;

  // BuildContext에서 주어진 T유형의 가장 가까운 인스턴스를 리턴한다.
  static VideoConfig of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<VideoConfig>()!;
  }

  // 프레임워크가 이 위젯을 rebuild 할지 말지를 정할 수 있게 해준다.
  // 이 위젯이 보유한 데이터가 oldWidget이 보유한 데이터와 동일하다면 oldWidget이 보유한 데이터를 상속한 위젯을 다시 build할 필요가 없다.
  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }
}
