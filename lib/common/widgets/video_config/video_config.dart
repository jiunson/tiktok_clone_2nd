import 'package:flutter/material.dart';

//------------------------------------------------------------------------------
// InheritedWidget을 이용한 State 관리법
//------------------------------------------------------------------------------

// Config 데이터를 앱 전체에 공유하는 클래스
class VideoConfigData extends InheritedWidget {
  const VideoConfigData({
    super.key,
    required this.autoMute,
    required this.toggleMuted,
    required super.child,
  });

  // custom code
  final bool autoMute;
  final void Function() toggleMuted;

  // BuildContext에서 주어진 T유형의 가장 가까운 인스턴스를 리턴한다.
  static VideoConfigData of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<VideoConfigData>()!;
  }

  // 프레임워크가 이 위젯을 rebuild 할지 말지를 정할 수 있게 해준다.
  // 이 위젯이 보유한 데이터가 oldWidget이 보유한 데이터와 동일하다면 oldWidget이 보유한 데이터를 상속한 위젯을 다시 build할 필요가 없다.
  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }
}

// Config 데이터 및 수정메서드를 지원하는 클래스
class VideoConfigForInheritedWidget extends StatefulWidget {
  final Widget child;

  const VideoConfigForInheritedWidget({
    super.key,
    required this.child,
  });

  @override
  State<VideoConfigForInheritedWidget> createState() =>
      _VideoConfigForInheritedWidgetState();
}

class _VideoConfigForInheritedWidgetState
    extends State<VideoConfigForInheritedWidget> {
  bool autoMute = true;

  // 함수호출 시 rebulid되어 VideoConfigData를 새로운 데이터로 빌드된다.
  void toggleMuted() {
    setState(() {
      autoMute = !autoMute;
    });
  }

  @override
  Widget build(BuildContext context) {
    return VideoConfigData(
      autoMute: autoMute,
      toggleMuted: toggleMuted,
      child: widget.child,
    );
  }
}

// -----------------------------------------------------------------------------
// ChangeNotifier를 이용한 State 관리법 (여러값)
// -----------------------------------------------------------------------------
class VideoConfig extends ChangeNotifier {
  bool autoMute = false;
  void toggleAutoMute() {
    autoMute = !autoMute;

    // 청취자(데이터 변경 사항을 듣고 있는 화면)에게 알린다.
    // 청취자는 해당UI 부분만 rebuild된다.
    notifyListeners();
  }
}

// 전연 변수
final videoConfigFoChangeNotifier = VideoConfig();

// -----------------------------------------------------------------------------
// ValueNotifier를 이용한 State 관리법 (단일값)
// -----------------------------------------------------------------------------
final videoConfig = ValueNotifier(false);
