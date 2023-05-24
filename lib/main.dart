import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:socialtec/Onboarding/onboarding_page.dart';
import 'package:socialtec/provider/flags_provider.dart';
import 'package:socialtec/provider/provider_theme.dart';
import 'package:socialtec/routes.dart';
//import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ChangeNotifierProvider(
    create: (BuildContext context) => ThemeNotifier(),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => ThemeNotifier()),
          ChangeNotifierProvider(create: (_) => FlagsProvider()),
        ],
        child: PMSNApp(),
      );
    });
  }
}

class PMSNApp extends StatelessWidget {
  const PMSNApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SOCIALTEC',
      theme: Provider.of<ThemeNotifier>(context).getTheme(),
      home: OnboardinPage(),
      routes: getApplicactionRoutes(),
    );
  }
}
