import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tiktok_clone_2nd/common/widgets/video_config/video_config.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notifications = false;

  void _onNotificationsChanged(bool? newValue) {
    if (newValue == null) return;
    setState(() {
      _notifications = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 기본 지원 언어를 하위 위젯에 강제 설정
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          SwitchListTile.adaptive(
            value: context.watch<VideoConfig>().isMuted,
            onChanged: (value) => context.read<VideoConfig>().toggleIsMuted(),
            title: const Text("Aute Mute"),
            subtitle: const Text("Video muted by default."),
          ),
          SwitchListTile(
            value: _notifications,
            onChanged: _onNotificationsChanged,
            title: const Text("Enable notifications"),
            subtitle: const Text("They will be cute."),
          ),
          CheckboxListTile(
            value: _notifications,
            onChanged: _onNotificationsChanged,
            title: const Text("marketing emails"),
            subtitle: const Text("We won't span you."),
          ),
          ListTile(
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1980),
                lastDate: DateTime(2030),
              );
              debugPrint('$date');

              if (!context.mounted) {
                return; // buildcotexts across async gaps 오류 해결.
              }
              final time = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              debugPrint('$time');

              if (!context.mounted) {
                return; // buildcontexts across async gaps 오류 해결.
              }
              final booking = await showDateRangePicker(
                context: context,
                firstDate: DateTime(1980),
                lastDate: DateTime(2030),
                builder: (context, child) {
                  return Theme(
                    data: ThemeData(
                      appBarTheme: const AppBarTheme(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.black),
                    ),
                    child: child!,
                  );
                },
              );
              debugPrint('$booking');
            },
            title: const Text("What is your birthday?"),
            subtitle: const Text("I need to know!"),
          ),
          ListTile(
            title: const Text("Log out (iOS)"),
            textColor: Colors.red,
            onTap: () {
              showCupertinoDialog(
                context: context,
                builder: (context) => CupertinoAlertDialog(
                  title: const Text("Are you sure?"),
                  content: const Text("Plx dont go"),
                  actions: [
                    CupertinoDialogAction(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text("No"),
                    ),
                    CupertinoDialogAction(
                      onPressed: () => Navigator.of(context).pop(),
                      isDestructiveAction: true,
                      child: const Text("Yes"),
                    ),
                  ],
                ),
              );
            },
          ),
          ListTile(
            title: const Text("Log out (Android)"),
            textColor: Colors.red,
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  icon: const FaIcon(FontAwesomeIcons.skull),
                  title: const Text("Are you sure?"),
                  content: const Text("Plx dont go"),
                  actions: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const FaIcon(FontAwesomeIcons.car),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text("Yes"),
                    ),
                  ],
                ),
              );
            },
          ),
          ListTile(
            title: const Text("Log out (iOS / Bottom)"),
            textColor: Colors.red,
            onTap: () {
              showCupertinoModalPopup(
                context: context,
                builder: (context) => CupertinoActionSheet(
                  title: const Text("Are you sure?"),
                  message: const Text("Please doooont goooooo"),
                  actions: [
                    CupertinoActionSheetAction(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text("Not log out"),
                    ),
                    CupertinoActionSheetAction(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text("Yes plz."),
                    ),
                  ],
                ),
              );
            },
          ),
          ListTile(
            onTap: () => showAboutDialog(
                context: context,
                applicationVersion: "1.0",
                applicationLegalese:
                    "All rights reseverd. Please dont copy me."),
            title: const Text(
              "About",
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: const Text("About this app....."),
          ),
          const AboutListTile(
            applicationVersion: "1.0",
            applicationLegalese: "Don't copy me.",
          ),
        ],
      ),
    );
  }
}
