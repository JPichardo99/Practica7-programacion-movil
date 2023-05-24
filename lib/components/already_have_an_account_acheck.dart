import 'package:flutter/material.dart';
import 'package:socialtec/constants.dart';

class AlreadyHaveAnAccountCheck extends StatelessWidget {
  final bool login;
  final Function? press;
  const AlreadyHaveAnAccountCheck({
    Key? key,
    this.login = true,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          login
              ? "¿Aun no tienes una cuenta? "
              : "¿Ya dispones de una cuenta? ",
        ),
        GestureDetector(
          onTap: press as void Function()?,
          child: Text(
            login ? "Registrate" : "Inicia sesion",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    );
  }
}
