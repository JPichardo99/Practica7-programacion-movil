import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socialtec/models/user_model.dart';

class ProfileUserScreen extends StatefulWidget {
  const ProfileUserScreen({super.key});

  @override
  State<ProfileUserScreen> createState() => _ProfileUserScreenState();
}

class _ProfileUserScreenState extends State<ProfileUserScreen> {
  UserModel? user;

  @override
  Widget build(BuildContext context) {
    if (ModalRoute.of(context)!.settings.arguments != null) {
      user = ModalRoute.of(context)!.settings.arguments as UserModel;
    }
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Perfil')),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 50),
            CircleAvatar(
              radius: 120,
              backgroundImage: NetworkImage(user!.photoUrl.toString()),
            ),
            const SizedBox(height: 50.0),
            Column(
              children: [
                const Text(
                  'Nombre de usuario: ',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  user!.name.toString(),
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Column(
              children: [
                const Text(
                  'Correo electronico: ',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  user!.email.toString(),
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
