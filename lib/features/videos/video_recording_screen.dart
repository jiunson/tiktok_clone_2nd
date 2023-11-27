import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tiktok_clone_2nd/constants/gaps.dart';
import 'package:tiktok_clone_2nd/constants/sizes.dart';
import 'package:tiktok_clone_2nd/features/videos/video_preview_screen.dart';

class VideoRecordingScreen extends StatefulWidget {
  const VideoRecordingScreen({super.key});

  @override
  State<VideoRecordingScreen> createState() => _VideoRecordingScreenState();
}

class _VideoRecordingScreenState extends State<VideoRecordingScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  bool _hasPermission = false;
  bool _isSelfieMode = false;
  bool _appActivated = true; // App 활성화 유무

  late final bool _noCamera =
      kDebugMode && Platform.isIOS; // 디버그모드와 iOS플랫폼이면 카메라가 없다.
  late FlashMode _flashMode;
  late CameraController _cameraController;

  late final AnimationController _buttonAnimationController =
      AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 200),
  );
  late final Animation<double> _buttonAnimation =
      Tween(begin: 1.0, end: 1.3).animate(_buttonAnimationController);

  late final AnimationController _progressAnimationController =
      AnimationController(
    vsync: this,
    duration: const Duration(seconds: 10),
    lowerBound: 0.0,
    upperBound: 1.0,
  );

  @override
  void initState() {
    super.initState();
    if (!_noCamera) {
      // 카메라가 있으면
      initPermissions();
    } else {
      _hasPermission = true; // 카메라가 없기 때문에 오류방지를 위핸 true설정.
      setState(() {});
    }

    // 지정된 객체를 바인딩 관찰자로 등록하여 이벤트 발생 시 바인딩 관찰자에게 알림이 전달된다.
    WidgetsBinding.instance.addObserver(this);

    // 프로그래스 애니메이션 이벤트 리스너
    _progressAnimationController.addListener(() {
      setState(() {});
    });
    _progressAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _stopRecording();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _cameraController.dispose();
    _buttonAnimationController.dispose();
    _progressAnimationController.dispose();
  }

  // 앱의 lifecyle을 시스템으로부터 알림을 받아 camera위젯을 handle한다.
  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    debugPrint('$state');
    if (!_hasPermission) return;
    if (!_cameraController.value.isInitialized) return;

    if (state == AppLifecycleState.paused) {
      _cameraController.dispose();
      _appActivated = false; // dispose된 위젯을 랜더트리에서 해당 위젯의 호출을 방지한다.
    } else if (state == AppLifecycleState.resumed) {
      await initCamera();
      _appActivated = true; // App 활성화
    }
    setState(() {});
  }

  Future<void> initCamera() async {
    // 사용 가능한 카메라 얻기
    final cameras = await availableCameras();

    if (cameras.isEmpty) return;

    // 카메라 컨트롤러 생성, 0-후방카메라, 1-전방카메라
    _cameraController = CameraController(
      cameras[_isSelfieMode ? 1 : 0],
      ResolutionPreset.ultraHigh,
      // 애뮬레이터에서는 소리가 활성화 된 채로 영상을 녹화하면 제대로 작동하니 않기 때문에 false 설정.
      enableAudio: false,
    );

    await _cameraController.initialize(); // 컨트롤러 초기화

    // iOS에서 비디오 녹화 시 약간의 영상 지연이 발생을 방지하기 위해 성능상의 이유로 메서드를 호출한다.
    // Android 및 Web에서는 작동하지 않는다.
    await _cameraController.prepareForVideoRecording();

    _flashMode = _cameraController.value.flashMode; // flashMode 변수 초기화
  }

  Future<void> initPermissions() async {
    final cameraPermission = await Permission.camera.request();
    final micPermission = await Permission.microphone.request();

    // 카메라 권한 체크
    final cameraDenied =
        cameraPermission.isDenied || cameraPermission.isPermanentlyDenied;

    // 마이크 권한 체크
    final micDenied =
        micPermission.isDenied || micPermission.isPermanentlyDenied;

    if (!cameraDenied && !micDenied) {
      _hasPermission = true;
      await initCamera();
      setState(() {});
    } else {
      // 권한오류 메시지 출력
    }
  }

  Future<void> _toggleSelfieMode() async {
    _isSelfieMode = !_isSelfieMode;
    await initCamera();
    setState(() {});
  }

  Future<void> _setFlashMode(FlashMode newFlashMode) async {
    await _cameraController.setFlashMode(newFlashMode);
    _flashMode = newFlashMode;
    setState(() {});
  }

  Future<void> _startRecording(TapDownDetails _) async {
    if (_cameraController.value.isRecordingVideo) return;
    await _cameraController.startVideoRecording();

    _buttonAnimationController.forward();
    _progressAnimationController.forward();
  }

  Future<void> _stopRecording() async {
    if (!_cameraController.value.isRecordingVideo) return;

    _buttonAnimationController.reverse();
    _progressAnimationController.reset();

    final video = await _cameraController.stopVideoRecording();

    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoPreviewScreen(
          video: video,
          isPicked: false,
        ),
      ),
    );
  }

  Future<void> _onPickVideoPressed() async {
    final video = await ImagePicker().pickVideo(
      source: ImageSource.gallery,
    );
    if (video == null) return;

    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoPreviewScreen(video: video, isPicked: true),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: !_hasPermission
            ? const Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Initializing...",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: Sizes.size20,
                    ),
                  ),
                  Gaps.v20,
                  CircularProgressIndicator.adaptive(
                    backgroundColor: Colors.white,
                  ),
                ],
              )
            : Stack(
                alignment: Alignment.center,
                children: [
                  if (!_noCamera && _cameraController.value.isInitialized)
                    if (_appActivated)
                      // 카메라 미리보기
                      CameraPreview(_cameraController),
                  if (!_noCamera)
                    // 카메라설정 버튼
                    Positioned(
                      top: Sizes.size20,
                      left: Sizes.size20,
                      child: Column(
                        children: [
                          IconButton(
                            color: Colors.white,
                            onPressed: _toggleSelfieMode,
                            icon: const Icon(Icons.cameraswitch),
                          ),
                          Gaps.v10,
                          IconButton(
                            color: _flashMode == FlashMode.off
                                ? Colors.amber.shade200
                                : Colors.white,
                            onPressed: () => _setFlashMode(FlashMode.off),
                            icon: const Icon(
                              Icons.flash_off_rounded,
                            ),
                          ),
                          Gaps.v10,
                          IconButton(
                            color: _flashMode == FlashMode.always
                                ? Colors.amber.shade200
                                : Colors.white,
                            onPressed: () => _setFlashMode(FlashMode.always),
                            icon: const Icon(
                              Icons.flash_on_rounded,
                            ),
                          ),
                          Gaps.v10,
                          IconButton(
                            color: _flashMode == FlashMode.auto
                                ? Colors.amber.shade200
                                : Colors.white,
                            onPressed: () => _setFlashMode(FlashMode.auto),
                            icon: const Icon(
                              Icons.flash_auto_rounded,
                            ),
                          ),
                          Gaps.v10,
                          IconButton(
                            color: _flashMode == FlashMode.torch
                                ? Colors.amber.shade200
                                : Colors.white,
                            onPressed: () => _setFlashMode(FlashMode.torch),
                            icon: const Icon(
                              Icons.flashlight_on_rounded,
                            ),
                          ),
                        ],
                      ),
                    ),
                  Positioned(
                    bottom: Sizes.size40,
                    width: MediaQuery.of(context)
                        .size
                        .width, // 오류방지를 위해 자식 Expanede위젯의 사이즈 지정.
                    child: Row(
                      children: [
                        // 녹화버튼의 가운데 정렬을 위해 빈 공간 위젯을 넣어준다.
                        const Spacer(),
                        // 녹화버튼
                        GestureDetector(
                          onTapDown: _startRecording,
                          onTapUp: (details) => _stopRecording(),
                          child: ScaleTransition(
                            scale: _buttonAnimation,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // 프로그래스
                                SizedBox(
                                  width: Sizes.size80 + Sizes.size14,
                                  height: Sizes.size80 + Sizes.size14,
                                  child: CircularProgressIndicator(
                                    color: Colors.red.shade400,
                                    strokeWidth: Sizes.size6,
                                    value: _progressAnimationController.value,
                                  ),
                                ),
                                // 버튼
                                Container(
                                  width: Sizes.size80,
                                  height: Sizes.size80,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.red.shade400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // 이미지 버튼
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            child: IconButton(
                              onPressed: _onPickVideoPressed,
                              icon: const FaIcon(
                                FontAwesomeIcons.image,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
