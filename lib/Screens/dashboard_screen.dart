import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:socialtec/Screens/Post/list_post.dart';
import 'package:socialtec/models/user_model.dart';

class DashboardScreen extends StatefulWidget {
  DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  UserModel? user;
  @override
  Widget build(BuildContext context) {
    if (ModalRoute.of(context)!.settings.arguments != null) {
      user = ModalRoute.of(context)!.settings.arguments as UserModel;
    }
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('SOCIALTEC')),
      ),
      body: const ListPost(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/add').then((value) {
            setState(() {});
          });
        },
        label: Text('Add post'),
        icon: const Icon(Icons.add_comment),
      ),
      //body: ,-
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(user!.name.toString()),
              accountEmail: Text(user!.email.toString()),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(user!.photoUrl.toString()),
              ),
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                          'assets/fondos/pexels-simon-berger-1323550.jpg'),
                      fit: BoxFit.cover)),
            ),
            const SizedBox(height: 12),
            ListTile(
              onTap: () {},
              title: const Text('Inicio'),
              leading: const Icon(Icons.home),
            ),
            const SizedBox(height: 16),
            ListTile(
              onTap: () {
                Future.delayed(const Duration(milliseconds: 500)).then((value) {
                  Navigator.pushNamed(context, '/profile', arguments: user);
                });
              },
              title: const Text('Perfil'),
              leading: const Icon(Icons.account_circle),
            ),
            const SizedBox(height: 16),
            ListTile(
              onTap: () {
                Future.delayed(const Duration(milliseconds: 500)).then((value) {
                  Navigator.pushNamed(context, '/events');
                });
              },
              title: const Text('Eventos'),
              leading: const Icon(Icons.calendar_month),
            ),
            const SizedBox(height: 16),
            ListTile(
              onTap: () {
                Future.delayed(const Duration(milliseconds: 500)).then((value) {
                  Navigator.pushNamed(context, '/popular');
                });
              },
              title: const Text('Popular Movies'),
              leading: const Icon(Icons.movie),
            ),
            const SizedBox(height: 16),
            ListTile(
              onTap: () {
                Future.delayed(const Duration(milliseconds: 500)).then((value) {
                  Navigator.pushNamed(context, '/preferences');
                });
              },
              title: const Text('Configuracion'),
              leading: const Icon(Icons.settings),
            ),
            const SizedBox(height: 16),
            ListTile(
              onTap: () {
                Future.delayed(const Duration(milliseconds: 500)).then((value) {
                  Navigator.pushNamed(context, '/maps');
                });
              },
              title: const Text('Maps'),
              leading: const Icon(Icons.map),
            ),
            const SizedBox(height: 5),
            const Divider(),
            const SizedBox(height: 5),
            ListTile(
              onTap: () {
                AwesomeDialog(
                    context: context,
                    dialogType: DialogType.warning,
                    headerAnimationLoop: false,
                    animType: AnimType.topSlide,
                    title: 'Cerrar sesion',
                    desc: '¿Estas seguro que deseas cerrar sesion?',
                    btnCancelOnPress: () {},
                    btnOkOnPress: () async {
                      await FirebaseAuth.instance.signOut().then((value) async {
                        await GoogleSignIn().signOut().then((value) {
                          Navigator.pushNamedAndRemoveUntil(
                              context, '/welcome', (route) => false);
                        });
                      });
                    }).show();
              },
              title: const Text('Cerrar sesion'),
              leading: const Icon(Icons.logout),
            )
          ],
        ),
      ),
    );
  }
}
