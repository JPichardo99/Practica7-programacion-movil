import 'package:flutter/material.dart';
import 'package:socialtec/Screens/UserPreferences/components/buttonsTheme.dart';
import 'package:socialtec/Screens/UserPreferences/components/user_preferences_image.dart';
import 'package:socialtec/components/background.dart';
import 'package:socialtec/responsive.dart';

class UserPreferenceScreen extends StatelessWidget {
  const UserPreferenceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Background(
      child: SingleChildScrollView(
        child: SafeArea(
          child: Responsive(
            desktop: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Expanded(
                  child: UserPreferencesImage(),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      SizedBox(
                        width: 450,
                        child: ButtonsTheme(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            mobile: const MobileUserPrefece(),
          ),
        ),
      ),
    );
  }
}

class MobileUserPrefece extends StatelessWidget {
  const MobileUserPrefece({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const UserPreferencesImage(),
        Row(
          children: const [
            Spacer(),
            Expanded(
              flex: 8,
              child: ButtonsTheme(),
            ),
            Spacer(),
          ],
        ),
      ],
    );
  }
}
