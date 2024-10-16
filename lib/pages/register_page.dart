import 'package:chat_app/services/auth/auth_service.dart';
import 'package:chat_app/components/my_button.dart';
import 'package:chat_app/components/my_text_field.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  final void Function()? onTap;
  RegisterPage({super.key, required this.onTap});

  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final comfirmPasswordTextController = TextEditingController();

  void registerUser(BuildContext context) async {
    final authSerive = AuthService();

    if (comfirmPasswordTextController.text != passwordTextController.text) {
      showDialog(
          context: context,
          builder: (context) =>
              const AlertDialog(title: Text("Password must match !!!")));
    } else {
      await authSerive.signUpWithEmailPassword(
          emailTextController.text, passwordTextController.text);
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
              "Let's create an account for you !",
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
            MyTextField(
              hintText: " Comfirm your password",
              obsecureText: true,
              textController: comfirmPasswordTextController,
            ),

            const SizedBox(height: 25),
            // login Button
            MyButton(
              text: "Register",
              onTap: () => registerUser(context),
            ),

            const SizedBox(height: 25),

            // register now
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already a member?  ",
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
                GestureDetector(
                  onTap: onTap,
                  child: Text(
                    "Login now",
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
