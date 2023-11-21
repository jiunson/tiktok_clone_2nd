import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone_2nd/constants/gaps.dart';
import 'package:tiktok_clone_2nd/constants/sizes.dart';
import 'package:tiktok_clone_2nd/features/authentication/login_screen.dart';
import 'package:tiktok_clone_2nd/features/authentication/username_screen.dart';
import 'package:tiktok_clone_2nd/features/authentication/widgets/auth_button.dart';
import 'package:tiktok_clone_2nd/generated/l10n.dart';
import 'package:tiktok_clone_2nd/utils.dart';

class SignUpScreen extends StatelessWidget {
  static const routeName = "/";

  const SignUpScreen({super.key});

  void _onLoginTab(BuildContext context) async {
    /* final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    ); */

    // final result = await Navigator.of(context).pushNamed(LoginScreen.routeName);

    // Navigator2
    context.push(LoginScreen.routeName);
  }

  void _onEmailTap(BuildContext context) {
    /* Navigator.of(context).push(
      // MaterialPageRoute(
      //   builder: (context) => const UsernameScreen(),
      // ),

      // 화면전환 애니메이션 변경하기
      PageRouteBuilder(
        transitionDuration: const Duration(seconds: 1),
        reverseTransitionDuration: const Duration(seconds: 1),
        pageBuilder: (context, animation, secondaryAnimation) =>
            const UsernameScreen(), // 이동할 화면 설정
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // 애니메이션 설정
          final offsetAnimation = Tween(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(animation);
          final opacityAnimation = Tween(
            begin: 0.5,
            end: 1.0,
          ).animate(animation);

          return SlideTransition(
            position: offsetAnimation,
            child: FadeTransition(
              opacity: opacityAnimation,
              child: child,
            ),
          );
        },
      ),
    ); */

    // Navigator.of(context).pushNamed(UsernameScreen.routeName);

    // Navigator2
    context.push(UsernameScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    // debugPrint(Localizations.localeOf(context).toString());
    return OrientationBuilder(
      builder: (context, orientation) {
        debugPrint("$orientation");
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Sizes.size40,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Gaps.v80,
                  Text(
                    S.of(context).signUpTitle("TickTok", DateTime.now()),
                    style: const TextStyle(
                      fontSize: Sizes.size24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Gaps.v20,
                  Opacity(
                    opacity: 0.7,
                    child: Text(
                      S.of(context).signUpSubtitle(0),
                      style: const TextStyle(
                        fontSize: Sizes.size16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Gaps.v40,
                  // 세로 방향일 경우 UI
                  if (orientation == Orientation.portrait) ...[
                    GestureDetector(
                      onTap: () => _onEmailTap(context),
                      child: AuthButton(
                        icon: const FaIcon(FontAwesomeIcons.user),
                        text: S.of(context).emailPasswordButton,
                      ),
                    ),
                    Gaps.v16,
                    AuthButton(
                      icon: const FaIcon(FontAwesomeIcons.apple),
                      text: S.of(context).appleButton,
                    ),
                  ],
                  // 가로 방향일 경우 UI
                  if (orientation == Orientation.landscape)
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _onEmailTap(context),
                            child: AuthButton(
                              icon: const FaIcon(FontAwesomeIcons.user),
                              text: S.of(context).emailPasswordButton,
                            ),
                          ),
                        ),
                        Gaps.h16,
                        Expanded(
                          child: AuthButton(
                            icon: const FaIcon(FontAwesomeIcons.apple),
                            text: S.of(context).appleButton,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: BottomAppBar(
            // dark 모드이면, darkThemeData에 설정된 값을 사용하도록 null 설정한다.
            color: isDarkMode(context) ? null : Colors.grey.shade50,
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: Sizes.size32,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    S.of(context).alreadyHaveAnAccount,
                    style: const TextStyle(
                      fontSize: Sizes.size16,
                    ),
                  ),
                  Gaps.h5,
                  GestureDetector(
                    onTap: () => _onLoginTab(context),
                    child: Text(
                      S.of(context).logIn("female"),
                      style: TextStyle(
                        fontSize: Sizes.size16,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
