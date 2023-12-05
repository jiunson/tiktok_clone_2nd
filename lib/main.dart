import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tiktok_clone_2nd/constants/sizes.dart';
import 'package:tiktok_clone_2nd/generated/l10n.dart';
import 'package:tiktok_clone_2nd/router.dart';

void main() async {
  // Flutter framework를 이용해서 앱이 시작하기 전에 state를 어떤 식으로든 바꾸고 싶다면
  // engine 자체와 engine과 widget의 연결을 확실하게 초기화 해야 한다.
  // runApp() 호출하기 전에 메서드를 호출해야 한다.
  WidgetsFlutterBinding.ensureInitialized();

  // 방향 고정
  // await SystemChrome.setPreferredOrientations(
  //   [
  //     DeviceOrientation.portraitUp,
  //   ],
  // );

  // 모든 화면에 적용
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle.dark,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // S.load(const Locale("en"));  // Locale 언어 강제 설정
    return MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      localizationsDelegates: const [
        S.delegate, // UI에 대한 번역 파일 설정
        GlobalMaterialLocalizations.delegate, // Material 위젯에 대한 번역 파일 설정
        GlobalCupertinoLocalizations.delegate, // Cupertino 위젯에 대한 번역 파일 설정
        GlobalWidgetsLocalizations.delegate, // 일반 위젯에 대한 번역 파일 설정
      ],
      supportedLocales: const [
        Locale("en"), // 영어 설정
        Locale("ko"), // 한국어 설정
      ],
      themeMode: ThemeMode.system,
      theme: ThemeData(
        useMaterial3: false,
        textTheme: Typography.blackMountainView,
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        primaryColor: const Color(0xFFE9435A),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Color(0xFFE9435A),
        ),
        splashColor: Colors.transparent,
        appBarTheme: const AppBarTheme(
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: Sizes.size16 + Sizes.size2,
            fontWeight: FontWeight.w600,
          ),
        ),
        tabBarTheme: TabBarTheme(
          indicatorColor: Colors.black,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey.shade500,
        ),
        listTileTheme: const ListTileThemeData(
          iconColor: Colors.black,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: false,
        textTheme: Typography.whiteMountainView,
        brightness: Brightness.dark,
        primaryColor: const Color(0xFFE9435A),
        scaffoldBackgroundColor: Colors.black,
        bottomAppBarTheme: BottomAppBarTheme(
          color: Colors.grey.shade900,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey.shade900,
        ),
        tabBarTheme: const TabBarTheme(
          indicatorColor: Colors.white,
        ),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Color(0xFFE9435A),
        ),
      ),
    );
  }
}
