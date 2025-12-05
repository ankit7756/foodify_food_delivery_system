import 'package:flutter/material.dart';
import '../widgets/my_textfield.dart';
import '../widgets/my_button.dart';
import '../theme/app_colors.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();

  String? nameError;
  String? emailError;
  String? passwordError;

  bool isValidEmail(String value) {
    return value.contains("@") && value.endsWith(".com");
  }

  void _onRegister() {
    setState(() {
      nameError = null;
      emailError = null;
      passwordError = null;

      if (name.text.trim().isEmpty) nameError = "Name cannot be empty";

      if (email.text.trim().isEmpty) {
        emailError = "Email cannot be empty";
      } else if (!isValidEmail(email.text.trim())) {
        emailError = "Enter a valid email ending with .com";
      }

      if (password.text.trim().isEmpty) {
        passwordError = "Password cannot be empty";
      }

      if (nameError != null || emailError != null || passwordError != null) {
        return;
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 36),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  "assets/images/foodify_logo.png",
                  height: 110,
                ),
              ),
              const SizedBox(height: 28),

              MyTextField(controller: name, hint: "Full name"),
              if (nameError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4, left: 6),
                  child: Text(
                    nameError!,
                    style: const TextStyle(color: Colors.red, fontSize: 13),
                  ),
                ),
              const SizedBox(height: 14),

              MyTextField(
                controller: email,
                hint: "Email",
                keyboardType: TextInputType.emailAddress,
              ),
              if (emailError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4, left: 6),
                  child: Text(
                    emailError!,
                    style: const TextStyle(color: Colors.red, fontSize: 13),
                  ),
                ),
              const SizedBox(height: 14),

              MyTextField(
                controller: password,
                hint: "Password",
                obscure: true,
              ),
              if (passwordError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4, left: 6),
                  child: Text(
                    passwordError!,
                    style: const TextStyle(color: Colors.red, fontSize: 13),
                  ),
                ),
              const SizedBox(height: 22),

              MyButton(text: "Register", onTap: _onRegister),

              const SizedBox(height: 18),

              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    );
                  },
                  child: const Text(
                    "Already have an account? Login",
                    style: TextStyle(color: AppColors.primary),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
