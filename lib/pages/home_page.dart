import 'package:chat_app/components/my_drawer.dart';
import 'package:chat_app/components/user_tile.dart';
import 'package:chat_app/pages/chat_page.dart';
import 'package:chat_app/services/auth/auth_service.dart';
import 'package:chat_app/services/chat/chat_services.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final AuthService _authService = AuthService();
  final ChatServices _chatServices = ChatServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
        title: const Text(
          "Home",
        ),
      ),
      drawer: const MyDrawer(),
      body: _builduserList(),
    );
  }

  // build a list of users except for the current logged in user

  Widget _builduserList() {
    return StreamBuilder(
        stream: _chatServices.getUsersStreamExceptBlocked(),
        builder: (context, snapshot) {
          // errors

          if (snapshot.hasError) {
            return const Text("Error");
          }

          // loading

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading ......");
          }

          // return List view
          return ListView(
            children: snapshot.data!
                .map<Widget>(
                    (userData) => _builduserListItem(userData, context))
                .toList(),
          );
        });
  }

  Widget _builduserListItem(
      Map<String, dynamic> userData, BuildContext context) {
    // display all users

    if (userData["email"] != _authService.getCurrentUser()!.email) {
      return UserTile(
          text: userData["email"],
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatPage(
                    receiverEmail: userData["email"],
                    receiverID: userData["uid"],
                  ),
                ));
          });
    } else {
      return Container();
    }
  }
}
