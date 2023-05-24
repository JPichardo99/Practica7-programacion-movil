import 'package:flutter/material.dart';
import 'package:socialtec/constants.dart';

class UserPreferencesImage extends StatelessWidget {
  const UserPreferencesImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: defaultPadding * 2),
        Row(
          children: [
            Spacer(),
            Expanded(
              flex: 8,
              child: Image.asset('assets/images/dibujo.png'),
            ),
            Spacer(),
          ],
        ),
        SizedBox(height: defaultPadding * 2),
      ],
    );
  }
}
