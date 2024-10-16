import 'package:chat_app/services/auth/auth_service.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  void logOutUser() {
    final authService = AuthService();
    authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            // logo
            children: [
              const DrawerHeader(
                child: Center(
                  child: Icon(
                    Icons.message,
                    size: 40,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: ListTile(
                  title: const Text(
                    "H O M E",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  leading: const Icon(
                    Icons.home,
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: ListTile(
                  title: const Text(
                    "S E T T I N G S",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  leading: const Icon(
                    Icons.settings,
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.pushNamed(context, "/settings");
                  },
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25, bottom: 25),
            child: ListTile(
                title: const Text(
                  "L O G O U T",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                leading: const Icon(
                  Icons.logout,
                ),
                onTap: () => logOutUser()),
          )
        ],
      ),
    );
  }
}
