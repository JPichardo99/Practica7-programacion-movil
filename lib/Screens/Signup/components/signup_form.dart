import 'dart:developer';
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socialtec/Screens/Login/login_screen.dart';
import 'package:socialtec/components/already_have_an_account_acheck.dart';
import 'package:socialtec/constants.dart';
import 'package:socialtec/models/user_model.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({Key? key}) : super(key: key);
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _emailController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _image;
  final _picker = ImagePicker();
  User? userCredential;

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

  // validar nombre
  String? _validateFirstName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, ingresa tu nombre.';
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

  void _imageGalery() async {
    final ImagePicker picker = ImagePicker();
    final image =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (image != null) {
      log('image path: ${image.path}');
      setState(() {
        _image = image.path;
      });
    }
  }

  void _imageCamera() async {
    final image =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 90);
    if (image != null) {
      log('image path: ${image.path}');
      setState(() {
        _image = image.path;
      });
    }
  }

  void _selectImage() {
    AwesomeDialog(
        context: context,
        dialogType: DialogType.info,
        desc: 'Selecciona el origen',
        headerAnimationLoop: false,
        animType: AnimType.topSlide,
        title: 'Imagen de perfil',
        btnCancelText: 'Camara',
        btnCancelColor: kPrimaryColor,
        btnOkText: 'Galeria',
        btnOkColor: kPrimaryColor,
        btnCancelOnPress: () {
          _imageCamera();
        },
        btnOkOnPress: () {
          _imageGalery();
        }).show();
  }

  // registrar usuario
  Future<void> _registerUser() async {
    if (_formKey.currentState!.validate() && _image != null) {
      final String email = _emailController.text.trim();
      final String password = _passwordController.text.trim();
      final String name = _firstNameController.text.trim();
      try {
        final UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: _emailController.text,
                password: _passwordController.text);

        if (userCredential.user != null) {
          final userDocRef = FirebaseFirestore.instance
              .collection('users')
              .doc(userCredential.user!.uid);
          final File imageFile = File(_image!.toString());
          final String photoUrl = await uploadPhotoToFirebaseStorage(
              imageFile, userCredential.user!.uid);

          // Guardar el nombre y la URL de la imagen en Firestore
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userCredential.user!.uid)
              .set({
            'name': name,
            'photoUrl': photoUrl,
            'email': email,
          });

          final UserModel userModel = UserModel(
            name: name,
            photoUrl: photoUrl,
            email: email,
          );

          Navigator.pushNamedAndRemoveUntil(
            context,
            '/dash',
            (route) => false,
            arguments: userModel,
          );
        }
      } catch (e) {
        log('Error: $e');
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.bottomSlide,
          title: 'Error',
          desc: 'Ocurrio un error al registrar el usuario',
          btnOkOnPress: () {},
        ).show();
      }
    }
  }

  Future<String> uploadPhotoToFirebaseStorage(File photo, String userId) async {
    try {
      final Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child('$userId.jpg');

      final UploadTask uploadTask = storageRef.putFile(photo);
      final TaskSnapshot taskSnapshot = await uploadTask;

      final String downloadUrl = await taskSnapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      print('Error uploading photo to Firebase Storage: $e');
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          SizedBox(
            height: 100,
            child: Stack(
              alignment: Alignment.center,
              children: [
                _image != null
                    ? CircleAvatar(
                        radius: 50,
                        backgroundImage: FileImage(File(_image!.toString())),
                      )
                    : CircleAvatar(
                        radius: 50,
                        child: Icon(Icons.person, size: 50),
                      ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: SizedBox(
                    height: 35,
                    width: 35,
                    child: ElevatedButton(
                      onPressed: () {
                        _selectImage();
                      },
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                        padding: EdgeInsets.zero,
                        elevation: 5,
                      ),
                      child: Icon(Icons.camera_alt, size: 20),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            onSaved: (firstname) {},
            controller: _firstNameController,
            validator: _validateFirstName,
            decoration: const InputDecoration(
              hintText: "Ingresa tu nombre",
              prefixIcon: Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: Icon(
                  Icons.person,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
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
                  child: Icon(Icons.lock),
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // Si el formulario es válido, continuar con el envío
                _registerUser();
              }
            },
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(kPrimaryLightColor),
            ),
            child: Text("Registrase".toUpperCase()),
          ),
          const SizedBox(height: defaultPadding),
          AlreadyHaveAnAccountCheck(
            login: false,
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return LoginScreen();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
