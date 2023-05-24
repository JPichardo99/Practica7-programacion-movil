import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:concentric_transition/concentric_transition.dart';
import 'package:socialtec/Onboarding/card_school.dart';
import 'package:socialtec/Screens/Welcome/welcome_screen.dart';
import 'package:socialtec/constants.dart';

class OnboardinPage extends StatelessWidget {
  OnboardinPage({super.key});

  final data = [
    CardSchoolData(
        title: "Descubre otra forma de comunicarte",
        subtitle:
            "Interactua con la gran comnunidad de alumnos y profesores del instituto tecnologico de celaya",
        image: const AssetImage("assets/onboarding/nueva-publicacion.png"),
        backgroundColor: kPrimaryColor,
        titleColor: Colors.white,
        subtitleColor: Colors.white,
        background: LottieBuilder.asset("assets/animation/bg-1.json")),
    CardSchoolData(
        title: "Desde cualquier parte y en todo momento",
        subtitle:
            "Sin importar la hora, la fecha o el lugar, podras seguir comunicandote y visualizar todo lo que tus amigos y profesores comparten",
        image: const AssetImage("assets/onboarding/publicidad-digital.png"),
        backgroundColor: Colors.white,
        titleColor: kPrimaryColor,
        subtitleColor: kPrimaryColor,
        background: LottieBuilder.asset('assets/animation/bg-1.json')),
    CardSchoolData(
        title: "Tu imaginacion es el unico limite",
        subtitle:
            "Podras compartir cualquir cosa que suceda en tu dia a dia, comentar y reaccionar a lo que tus amigos y profesores comparten",
        image: const AssetImage(
            "assets/onboarding/publicidad-digital-computer.png"),
        backgroundColor: kPrimaryColor,
        titleColor: Colors.white,
        subtitleColor: Colors.white,
        background: LottieBuilder.asset('assets/animation/bg-1.json')),
    CardSchoolData(
        title: "¿Estas listo?",
        subtitle:
            "Unete a esta gran comunidad de alumnos y profesores del instituto tecnologico de celaya y descubre una nueva forma de comunicarte",
        image: const AssetImage("assets/onboarding/correo-de-propaganda.png"),
        backgroundColor: Colors.white,
        titleColor: kPrimaryColor,
        subtitleColor: kPrimaryColor,
        background: LottieBuilder.asset('assets/animation/bg-1.json')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ConcentricPageView(
        colors: data.map((e) => e.backgroundColor).toList(),
        itemCount: data.length,
        onFinish: () {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: ((context) => const WelcomeScreen())));
        },
        itemBuilder: (int index) {
          return CardSchool(data: data[index]);
        },
      ),
    );
  }
}
