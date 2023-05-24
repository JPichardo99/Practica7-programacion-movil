import 'dart:developer';
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:socialtec/Screens/Signup/signup_screen.dart';
import 'package:socialtec/components/already_have_an_account_acheck.dart';
import 'package:socialtec/constants.dart';
import 'package:socialtec/firebase/email_auth.dart';
import 'package:socialtec/firebase/google_auth.dart';
import 'package:socialtec/models/user_model.dart';

final RoundedLoadingButtonController googleController =
    RoundedLoadingButtonController();
final RoundedLoadingButtonController githubController =
    RoundedLoadingButtonController();

class LoginForm extends StatefulWidget {
  const LoginForm({
    Key? key,
  }) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

// google
class _LoginFormState extends State<LoginForm> {
  User? userCredential;
  // github
  _handleGithubBntClick() {
    _signInWithGithub().then((user) async {
      if (user != null) {
        log('\nUser: ${user.user}');
        log('\nUserAdditionalUserInfo: ${user.additionalUserInfo}');
        googleController.success();
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/dash',
          arguments: UserModel.fromFirebaseUser(user.user!),
          (Route<dynamic> route) => false,
        );
      } else {
        githubController.reset();
      }
    });
  }

  Future<UserCredential?> _signInWithGithub() async {
    try {
      await InternetAddress.lookup('Github.com');
      // Create a new provider
      GithubAuthProvider githubProvider = GithubAuthProvider();
      return await FirebaseAuth.instance.signInWithProvider(githubProvider);
    } catch (e) {
      log('Error al iniciar sesión con Github: $e');
      AwesomeDialog(
              context: context,
              dialogType: DialogType.error,
              headerAnimationLoop: false,
              animType: AnimType.topSlide,
              title: 'Error',
              desc: 'Error al iniciar sesión con Github',
              btnOkOnPress: () {})
          .show();
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final _emailController = TextEditingController();
    final _passwordController = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    GoogleAuth googleAuth = GoogleAuth();
    EmailAuth emailAuth = EmailAuth();

    // validar correo
    String? _validateEmail(String? value) {
      if (value == null || value.isEmpty) {
        return 'Por favor, ingresa un correo electrónico.';
      }
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegex.hasMatch(value)) {
        return 'Por favor, ingrese un correo electrónico válido.';
      }
      return null;
    }

    // validar password
    String? _validatePassword(String? value) {
      if (value == null || value.isEmpty) {
        return 'Por favor, ingresa una contraseña.';
      }
      return null;
    }

    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            onSaved: (email) {},
            controller: _emailController,
            validator: _validateEmail,
            decoration: const InputDecoration(
              hintText: "Ingresa un email",
              prefixIcon: Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: Icon(
                  Icons.account_circle,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              keyboardType: TextInputType.text,
              obscureText: true,
              textInputAction: TextInputAction.next,
              onSaved: (password) {},
              controller: _passwordController,
              validator: _validatePassword,
              decoration: const InputDecoration(
                hintText: "Ingresa una contraseña",
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Icon(
                    Icons.lock,
                  ),
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                // Si el formulario es válido, continuar con el envío
                try {
                  final UserCredential userCredential =
                      await FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: _emailController.text,
                    password: _passwordController.text,
                  );
                  final userDoc = await FirebaseFirestore.instance
                      .collection('users')
                      .doc(userCredential.user!.uid)
                      .get();
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/dash', (route) => false,
                      arguments: UserModel(
                          email: userDoc['email'],
                          name: userDoc['name'],
                          photoUrl: userDoc['photoUrl']));
                } catch (e) {
                  log('Error al iniciar sesión con email: $e');
                  AwesomeDialog(
                          context: context,
                          dialogType: DialogType.error,
                          headerAnimationLoop: false,
                          animType: AnimType.topSlide,
                          title: 'Error',
                          desc: 'Error al iniciar sesión con email',
                          btnOkOnPress: () {})
                      .show();
                }
              }
            },
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(kPrimaryLightColor),
            ),
            child: Text("Iniciar sesion".toUpperCase()),
          ),
          const SizedBox(height: defaultPadding),
          AlreadyHaveAnAccountCheck(
            login: true,
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return SignUpScreen();
                  },
                ),
              );
            },
          ),
          SizedBox(height: 16),
          RoundedLoadingButton(
            onPressed: () async {
              setState(() {});
              await googleAuth.signInWithGoogle().then((value) {
                if (value != null) {
                  googleController.success();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/dash',
                    arguments: value,
                    (Route<dynamic> route) => false,
                  );
                } else {
                  setState(() {});
                  AwesomeDialog(
                          context: context,
                          dialogType: DialogType.error,
                          headerAnimationLoop: false,
                          animType: AnimType.topSlide,
                          title: 'Error',
                          desc: 'Error al iniciar sesión con Google',
                          btnOkOnPress: () {})
                      .show();
                  googleController.reset();
                }
              });
            },
            controller: googleController,
            successColor: Colors.red,
            width: MediaQuery.of(context).size.width * 0.80,
            elevation: 0,
            borderRadius: 25,
            color: Colors.red,
            child: Wrap(
              children: const [
                Icon(
                  FontAwesomeIcons.google,
                  size: 16,
                  color: Colors.white,
                ),
                SizedBox(
                  width: 14,
                ),
                Text("Iniciar sesión con Google",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Poppins')),
              ],
            ),
          ),
          SizedBox(height: 16),
          RoundedLoadingButton(
            onPressed: () {
              _handleGithubBntClick();
            },
            controller: githubController,
            successColor: Color.fromARGB(137, 82, 82, 82),
            width: MediaQuery.of(context).size.width * 0.80,
            elevation: 0,
            borderRadius: 25,
            color: Color.fromARGB(137, 82, 82, 82),
            child: Wrap(
              children: const [
                Icon(
                  FontAwesomeIcons.github,
                  size: 16,
                  color: Colors.white,
                ),
                SizedBox(
                  width: 14,
                ),
                Text("Iniciar sesión con Github",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Poppins')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
