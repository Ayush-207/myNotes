import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/enums/menu_actions.dart';
import 'package:mynotes/services/auth/auth_service.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Main UI'),
          actions: [
            PopupMenuButton<MenuAction>(
              onSelected: (value) async {
                switch (value) {
                  case MenuAction.logout:
                    final shoudlLogout = await showLogOutDialog(context);
                    if (shoudlLogout) {
                      await AuthService.firebase().logOut();
                      Navigator.of(context)
                          .pushNamedAndRemoveUntil(loginRoute, (_) => false);
                    }
                    // devtools.log(shoudlLogout.toString());
                    break;
                }
              },
              itemBuilder: (context) {
                return const [
                  PopupMenuItem<MenuAction>(
                    value: MenuAction.logout,
                    child: Text('Log out'),
                  )
                ];
              },
            )
          ],
          backgroundColor: Colors.blue,
        ),
        body: const Text('Home screen'));
  }
}

Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            title: const Text('Sign out'),
            content: const Text('Are you sure you want to sign out?'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: const Text('Cancel')),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: const Text('Log out'))
            ]);
      }).then((value) => value ?? false);
}
