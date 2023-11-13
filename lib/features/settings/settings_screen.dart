import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
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
          const AboutListTile(),
        ],
      ),
    );
  }
}
