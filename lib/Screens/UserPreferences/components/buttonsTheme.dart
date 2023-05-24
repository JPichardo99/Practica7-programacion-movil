import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socialtec/constants.dart';
import 'package:socialtec/provider/provider_theme.dart';

class ButtonsTheme extends StatelessWidget {
  const ButtonsTheme({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Selecciona un tema:"),
        SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            Provider.of<ThemeNotifier>(context, listen: false)
                .setTheme("light");
          },
          style: ElevatedButton.styleFrom(
              primary: suLightButtonColor, elevation: 0),
          child: Text("Tema de dia", style: TextStyle(color: Colors.white)),
        ),
        SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            Provider.of<ThemeNotifier>(context, listen: false).setTheme("dark");
          },
          style: ElevatedButton.styleFrom(
              primary: suDarkButtonColor, elevation: 0),
          child: Text("Tema de noche", style: TextStyle(color: Colors.white)),
        ),
        SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            Provider.of<ThemeNotifier>(context, listen: false)
                .setTheme("custom");
          },
          child: Text("Tema personalizado"),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
