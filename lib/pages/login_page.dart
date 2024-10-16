import 'package:chat_app/services/auth/auth_service.dart';
import 'package:chat_app/components/my_button.dart';
import 'package:chat_app/components/my_text_field.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  final void Function()? onTap;
  LoginPage({super.key, required this.onTap});

  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  void loginUser(BuildContext context) async {
    // auth service

    final authService = AuthService();

    try {
      await authService.signInWithEmailPassword(
          emailTextController.text, passwordTextController.text);
    } catch (e) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text(e.toString()),
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // logo
            Icon(
              Icons.message,
              size: 60,
              color: Theme.of(context).colorScheme.primary,
            ),

            const SizedBox(height: 50),

            // Welcome back message

            Text(
              "Welcome back , you've been missed !",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.primary, fontSize: 16),
            ),

            const SizedBox(height: 50),
            // email textfield
            MyTextField(
              hintText: "Enter your email address",
              obsecureText: false,
              textController: emailTextController,
            ),
            const SizedBox(height: 25),
            // Password field
            MyTextField(
              hintText: "Provide your password",
              obsecureText: true,
              textController: passwordTextController,
            ),

            const SizedBox(height: 25),
            // login Buttn
            MyButton(
              text: "Login",
              onTap: () => loginUser(context),
            ),

            const SizedBox(height: 25),

            // register now
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Not a member?  ",
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
                GestureDetector(
                  onTap: onTap,
                  child: Text(
                    "Register now",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
