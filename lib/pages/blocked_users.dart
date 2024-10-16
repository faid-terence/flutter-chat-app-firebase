import 'package:chat_app/services/auth/auth_service.dart';
import 'package:chat_app/services/chat/chat_services.dart';
import 'package:flutter/material.dart';

class BlockedUsers extends StatelessWidget {
  BlockedUsers({super.key});

  final ChatServices _chatServices = ChatServices();
  final AuthService _authService = AuthService();

  // show confirm unblock dialog
  void _showUnBlockBox(BuildContext context, String userID) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Unblock user"),
            content: const Text("Are you sure you want to unblock this user?"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  _chatServices.unblockUser(userID);
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();

                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("User unblocked")));
                },
                child: const Text("Unblock"),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    // get current users Id
    String userId = _authService.getCurrentUser()!.uid;
    return Scaffold(
      appBar: AppBar(
        title: const Text("BLOCKED USERS"),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
      ),
      body: StreamBuilder(
          stream: _chatServices.getBlockedUsersStream(userId),
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
                  .map<Widget>((userData) =>
                      _buildBlockedUserListItem(userData, context))
                  .toList(),
            );
          }),
    );
  }

  Widget _buildBlockedUserListItem(
      Map<String, dynamic> userData, BuildContext context) {
    return ListTile(
      title: Text(userData["email"]),
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () {
          _showUnBlockBox(context, userData["uid"]);
        },
      ),
    );
  }
}
