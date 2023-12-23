import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone_2nd/constants/gaps.dart';
import 'package:tiktok_clone_2nd/constants/sizes.dart';
import 'package:tiktok_clone_2nd/features/discover/discover_screen.dart';
import 'package:tiktok_clone_2nd/features/inbox/inbox_screen.dart';
import 'package:tiktok_clone_2nd/common/widgets/main_navigation/widgets/nav_tab.dart';
import 'package:tiktok_clone_2nd/common/widgets/main_navigation/widgets/post_video_button.dart';
import 'package:tiktok_clone_2nd/features/videos/views/video_recording_screen.dart';
import 'package:tiktok_clone_2nd/features/videos/views/video_timeline_screen.dart';
import 'package:tiktok_clone_2nd/features/users/user_profile_screen.dart';
import 'package:tiktok_clone_2nd/utils.dart';

class MainNavgationScreen extends StatefulWidget {
  static const String routeName = "mainNavigation";

  final String tab;

  const MainNavgationScreen({
    super.key,
    required this.tab,
  });

  @override
  State<MainNavgationScreen> createState() => _MainNavgationScreenState();
}

class _MainNavgationScreenState extends State<MainNavgationScreen> {
  final List<String> _tabs = [
    "home",
    "discover",
    "xxxx",
    "inbox",
    "profile",
  ];

  late int _selectedIndex = _tabs.indexOf(widget.tab); // 선택된 Tab 인덱스.

  void _onTap(int index) {
    context.go("/${_tabs[index]}");

    setState(() {
      _selectedIndex = index;
    });
  }

  void _onPostVideoButtonTap() {
    /* Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('Record video'),
          ),
        ),
        fullscreenDialog: true,
      ),
    ); */
    context.pushNamed(VideoRecordingScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = isDarkMode(context);
    return Scaffold(
      resizeToAvoidBottomInset: false, // 화면 키보드를 피하기 위해 자체 크기를 조정 설정
      backgroundColor:
          _selectedIndex == 0 || isDark ? Colors.black : Colors.white,
      body: Stack(children: [
        Offstage(
          offstage: _selectedIndex != 0,
          child: const VideoTimelineScreen(),
        ),
        Offstage(
          offstage: _selectedIndex != 1,
          child: const DiscoverScreen(),
        ),
        Container(),
        Offstage(
          offstage: _selectedIndex != 3,
          child: const InboxScreen(),
        ),
        Offstage(
          offstage: _selectedIndex != 4,
          child: const UserProfileScreen(
            username: "니꼬", // 에러방지 임시처리
            tab: "",
          ),
        ),
      ]),
      bottomNavigationBar: BottomAppBar(
        color: _selectedIndex == 0 || isDark ? Colors.black : Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(Sizes.size12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              NavTab(
                text: "Home",
                isSelected: _selectedIndex == 0,
                icon: FontAwesomeIcons.house,
                selectedIcon: FontAwesomeIcons.house,
                onTap: () => _onTap(0),
                selectedIndex: _selectedIndex,
              ),
              NavTab(
                text: "Discover",
                isSelected: _selectedIndex == 1,
                icon: FontAwesomeIcons.compass,
                selectedIcon: FontAwesomeIcons.solidCompass,
                onTap: () => _onTap(1),
                selectedIndex: _selectedIndex,
              ),
              Gaps.h24,
              GestureDetector(
                onTap: _onPostVideoButtonTap,
                child: PostVideoButton(
                  inverted: _selectedIndex != 0,
                ),
              ),
              Gaps.h24,
              NavTab(
                text: "Inbox",
                isSelected: _selectedIndex == 3,
                icon: FontAwesomeIcons.message,
                selectedIcon: FontAwesomeIcons.solidMessage,
                onTap: () => _onTap(3),
                selectedIndex: _selectedIndex,
              ),
              NavTab(
                text: "Profile",
                isSelected: _selectedIndex == 4,
                icon: FontAwesomeIcons.user,
                selectedIcon: FontAwesomeIcons.solidUser,
                onTap: () => _onTap(4),
                selectedIndex: _selectedIndex,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
