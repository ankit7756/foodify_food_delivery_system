import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme/app_colors.dart';
import 'login_screen.dart';
import '../../domain/entities/user_entity.dart';
import '../state/auth_state.dart';
import '../view_model/auth_view_model.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final username = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final fullName = TextEditingController();
  final phone = TextEditingController();

  String? usernameError;
  String? emailError;
  String? passwordError;
  String? fullNameError;
  String? phoneError;

  bool isPasswordVisible = false;

  bool isValidEmail(String value) {
    return value.contains("@") && value.endsWith(".com");
  }

  bool isValidPhone(String value) {
    return value.length >= 10 && RegExp(r'^[0-9]+$').hasMatch(value);
  }

  void _onRegister() async {
    setState(() {
      usernameError = null;
      emailError = null;
      passwordError = null;
      fullNameError = null;
      phoneError = null;
    });

    if (username.text.trim().isEmpty) {
      setState(() => usernameError = "Username cannot be empty");
      return;
    }

    if (email.text.trim().isEmpty) {
      setState(() => emailError = "Email cannot be empty");
      return;
    } else if (!isValidEmail(email.text.trim())) {
      setState(() => emailError = "Enter a valid email ending with .com");
      return;
    }

    if (password.text.trim().isEmpty) {
      setState(() => passwordError = "Password cannot be empty");
      return;
    } else if (password.text.trim().length < 6) {
      setState(() => passwordError = "Password must be at least 6 characters");
      return;
    }

    if (fullName.text.trim().isEmpty) {
      setState(() => fullNameError = "Full name cannot be empty");
      return;
    }

    if (phone.text.trim().isEmpty) {
      setState(() => phoneError = "Phone cannot be empty");
      return;
    } else if (!isValidPhone(phone.text.trim())) {
      setState(() => phoneError = "Enter a valid phone number (10+ digits)");
      return;
    }

    final newUser = UserEntity(
      username: username.text.trim(),
      email: email.text.trim(),
      password: password.text.trim(),
      fullName: fullName.text.trim(),
      phone: phone.text.trim(),
    );

    await ref.read(authViewModelProvider.notifier).registerUser(newUser);
  }

  @override
  void dispose() {
    username.dispose();
    email.dispose();
    password.dispose();
    fullName.dispose();
    phone.dispose();
    super.dispose();
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscure = false,
    TextInputType? keyboardType,
    Widget? suffix,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        keyboardType: keyboardType,
        style: const TextStyle(fontSize: 16),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey.shade600),
          prefixIcon: Icon(icon, color: const Color(0xFFFF6B35)),
          suffixIcon: suffix,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFFFF6B35), width: 2),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);

    ref.listen<AuthState>(authViewModelProvider, (previous, next) {
      if (next.status == previous?.status) return;

      if (next.status == AuthStatus.registered) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("Registration successful!"),
            backgroundColor: Colors.green.shade400,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
        ref.read(authViewModelProvider.notifier).resetState();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      } else if (next.status == AuthStatus.error && next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: Colors.red.shade400,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
        ref.read(authViewModelProvider.notifier).resetState();
      }
    });

    final isLoading = authState.status == AuthStatus.loading;

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo at top
              Center(
                child: Image.asset(
                  "assets/images/foodify_logo.png",
                  height: 100,
                ),
              ),
              const SizedBox(height: 30),

              // Create Account text
              const Text(
                "Create Account",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Sign up to get started",
                style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
              ),

              const SizedBox(height: 30),

              // Username field
              _buildTextField(
                controller: username,
                label: "Username",
                icon: Icons.person_outline,
              ),
              if (usernameError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 6, left: 4),
                  child: Text(
                    usernameError!,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              const SizedBox(height: 16),

              // Email field
              _buildTextField(
                controller: email,
                label: "Email",
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              if (emailError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 6, left: 4),
                  child: Text(
                    emailError!,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              const SizedBox(height: 16),

              // Password field
              _buildTextField(
                controller: password,
                label: "Password",
                icon: Icons.lock_outline,
                obscure: !isPasswordVisible,
                suffix: IconButton(
                  icon: Icon(
                    isPasswordVisible
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: Colors.grey.shade600,
                  ),
                  onPressed: () {
                    setState(() => isPasswordVisible = !isPasswordVisible);
                  },
                ),
              ),
              if (passwordError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 6, left: 4),
                  child: Text(
                    passwordError!,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              const SizedBox(height: 16),

              // Full Name field
              _buildTextField(
                controller: fullName,
                label: "Full Name",
                icon: Icons.badge_outlined,
              ),
              if (fullNameError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 6, left: 4),
                  child: Text(
                    fullNameError!,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              const SizedBox(height: 16),

              // Phone field
              _buildTextField(
                controller: phone,
                label: "Phone Number",
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
              ),
              if (phoneError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 6, left: 4),
                  child: Text(
                    phoneError!,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

              const SizedBox(height: 30),

              // Register button
              isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFFF6B35),
                      ),
                    )
                  : SizedBox(
                      width: double.infinity,
                      height: 58,
                      child: ElevatedButton(
                        onPressed: _onRegister,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF6B35),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          shadowColor: const Color(0xFFFF6B35).withOpacity(0.4),
                        ),
                        child: const Text(
                          "Register",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),

              const SizedBox(height: 24),

              // Login link
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account? ",
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 15,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LoginScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          color: Color(0xFFFF6B35),
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
