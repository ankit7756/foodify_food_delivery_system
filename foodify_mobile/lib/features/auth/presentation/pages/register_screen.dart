// // // import 'package:flutter/material.dart';
// // // import '../widgets/my_textfield.dart';
// // // import '../widgets/my_button.dart';
// // // import '../../../../app/theme/app_colors.dart';
// // // import 'login_screen.dart';
// // // import '../../domain/entities/user_entity.dart';
// // // import '../../data/datasources/local/auth_local_datasource.dart';
// // // import '../../data/repositories/auth_repository_impl.dart';
// // // import '../../domain/usecases/auth_usecases.dart';

// // // final authLocalDataSource = AuthLocalDataSource(); // NEW
// // // final authRepository = AuthRepositoryImpl(
// // //   localDataSource: authLocalDataSource,
// // // ); // NEW

// // // // final authUseCases = AuthUseCases(repository: authRepository); // NEW

// // // class RegisterScreen extends StatefulWidget {
// // //   const RegisterScreen({super.key});

// // //   @override
// // //   State<RegisterScreen> createState() => _RegisterScreenState();
// // // }

// // // class _RegisterScreenState extends State<RegisterScreen> {
// // //   final name = TextEditingController();
// // //   final email = TextEditingController();
// // //   final password = TextEditingController();

// // //   String? nameError;
// // //   String? emailError;
// // //   String? passwordError;

// // //   bool isLoading = false; // NEW

// // //   bool isValidEmail(String value) {
// // //     return value.contains("@") && value.endsWith(".com");
// // //   }

// // //   void _onRegister() async {
// // //     setState(() {
// // //       nameError = null;
// // //       emailError = null;
// // //       passwordError = null;
// // //       isLoading = true; // NEW: show loading
// // //     });

// // //     // Your original validation
// // //     if (name.text.trim().isEmpty) {
// // //       nameError = "Name cannot be empty";
// // //     }

// // //     if (email.text.trim().isEmpty) {
// // //       emailError = "Email cannot be empty";
// // //     } else if (!isValidEmail(email.text.trim())) {
// // //       emailError = "Enter a valid email ending with .com";
// // //     }

// // //     if (password.text.trim().isEmpty) {
// // //       passwordError = "Password cannot be empty";
// // //     }

// // //     if (nameError != null || emailError != null || passwordError != null) {
// // //       setState(() => isLoading = false); // NEW: stop loading
// // //       return;
// // //     }

// // //     // === NEW: Create entity and save to Hive ===
// // //     final newUser = UserEntity(
// // //       username: name.text.trim(),
// // //       email: email.text.trim(),
// // //       password: password.text.trim(),
// // //       fullName: name.text.trim(),
// // //       phone: '', // Placeholder, add phone field if needed
// // //     );

// // //     try {
// // //       // Save user using clean architecture use case
// // //       final saveUserUseCase = SaveUserUseCase(authRepository);
// // //       await saveUserUseCase(newUser);

// // //       if (mounted) {
// // //         ScaffoldMessenger.of(context).showSnackBar(
// // //           const SnackBar(content: Text("Registration successful!")), // NEW
// // //         );

// // //         Navigator.pushReplacement(
// // //           context,
// // //           MaterialPageRoute(builder: (_) => const LoginScreen()),
// // //         );
// // //       }
// // //     } catch (e) {
// // //       if (mounted) {
// // //         ScaffoldMessenger.of(context).showSnackBar(
// // //           SnackBar(content: Text("Registration failed: $e")), // NEW
// // //         );
// // //       }
// // //     } finally {
// // //       if (mounted) {
// // //         setState(() => isLoading = false); // NEW: stop loading
// // //       }
// // //     }
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       backgroundColor: AppColors.background,
// // //       body: SafeArea(
// // //         child: SingleChildScrollView(
// // //           padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 36),
// // //           child: Column(
// // //             crossAxisAlignment: CrossAxisAlignment.start,
// // //             children: [
// // //               Center(
// // //                 child: Image.asset(
// // //                   "assets/images/foodify_logo.png",
// // //                   height: 110,
// // //                 ),
// // //               ),
// // //               const SizedBox(height: 28),

// // //               MyTextField(controller: name, hint: "Full name"),
// // //               if (nameError != null)
// // //                 Padding(
// // //                   padding: const EdgeInsets.only(top: 4, left: 6),
// // //                   child: Text(
// // //                     nameError!,
// // //                     style: const TextStyle(color: Colors.red, fontSize: 13),
// // //                   ),
// // //                 ),
// // //               const SizedBox(height: 14),

// // //               MyTextField(
// // //                 controller: email,
// // //                 hint: "Email",
// // //                 keyboardType: TextInputType.emailAddress,
// // //               ),
// // //               if (emailError != null)
// // //                 Padding(
// // //                   padding: const EdgeInsets.only(top: 4, left: 6),
// // //                   child: Text(
// // //                     emailError!,
// // //                     style: const TextStyle(color: Colors.red, fontSize: 13),
// // //                   ),
// // //                 ),
// // //               const SizedBox(height: 14),

// // //               MyTextField(
// // //                 controller: password,
// // //                 hint: "Password",
// // //                 obscure: true,
// // //               ),
// // //               if (passwordError != null)
// // //                 Padding(
// // //                   padding: const EdgeInsets.only(top: 4, left: 6),
// // //                   child: Text(
// // //                     passwordError!,
// // //                     style: const TextStyle(color: Colors.red, fontSize: 13),
// // //                   ),
// // //                 ),
// // //               const SizedBox(height: 22),

// // //               MyButton(text: "Register", onTap: _onRegister),

// // //               const SizedBox(height: 18),

// // //               Center(
// // //                 child: GestureDetector(
// // //                   onTap: () {
// // //                     Navigator.push(
// // //                       context,
// // //                       MaterialPageRoute(builder: (_) => const LoginScreen()),
// // //                     );
// // //                   },
// // //                   child: const Text(
// // //                     "Already have an account? Login",
// // //                     style: TextStyle(color: AppColors.primary),
// // //                   ),
// // //                 ),
// // //               ),
// // //             ],
// // //           ),
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }

// // import 'package:flutter/material.dart';
// // import '../widgets/my_textfield.dart';
// // import '../widgets/my_button.dart';
// // import '../../../../app/theme/app_colors.dart';
// // import '../../../../core/api/api_client.dart';
// // import 'login_screen.dart';
// // import '../../domain/entities/user_entity.dart';
// // import '../../data/datasources/local/auth_local_datasource.dart';
// // import '../../data/datasources/remote/auth_remote_datasource.dart';
// // import '../../data/repositories/auth_repository_impl.dart';
// // import '../../domain/usecases/auth_usecases.dart';

// // class RegisterScreen extends StatefulWidget {
// //   const RegisterScreen({super.key});

// //   @override
// //   State<RegisterScreen> createState() => _RegisterScreenState();
// // }

// // class _RegisterScreenState extends State<RegisterScreen> {
// //   final username = TextEditingController();
// //   final email = TextEditingController();
// //   final password = TextEditingController();
// //   final fullName = TextEditingController();
// //   final phone = TextEditingController();

// //   String? usernameError;
// //   String? emailError;
// //   String? passwordError;
// //   String? fullNameError;
// //   String? phoneError;

// //   bool isLoading = false;

// //   bool isValidEmail(String value) {
// //     return value.contains("@") && value.endsWith(".com");
// //   }

// //   bool isValidPhone(String value) {
// //     return value.length >= 10 && RegExp(r'^[0-9]+$').hasMatch(value);
// //   }

// //   void _onRegister() async {
// //     setState(() {
// //       usernameError = null;
// //       emailError = null;
// //       passwordError = null;
// //       fullNameError = null;
// //       phoneError = null;
// //       isLoading = true;
// //     });

// //     // Validation
// //     if (username.text.trim().isEmpty) {
// //       usernameError = "Username cannot be empty";
// //     }

// //     if (email.text.trim().isEmpty) {
// //       emailError = "Email cannot be empty";
// //     } else if (!isValidEmail(email.text.trim())) {
// //       emailError = "Enter a valid email ending with .com";
// //     }

// //     if (password.text.trim().isEmpty) {
// //       passwordError = "Password cannot be empty";
// //     } else if (password.text.trim().length < 6) {
// //       passwordError = "Password must be at least 6 characters";
// //     }

// //     if (fullName.text.trim().isEmpty) {
// //       fullNameError = "Full name cannot be empty";
// //     }

// //     if (phone.text.trim().isEmpty) {
// //       phoneError = "Phone cannot be empty";
// //     } else if (!isValidPhone(phone.text.trim())) {
// //       phoneError = "Enter a valid phone number (10+ digits)";
// //     }

// //     if (usernameError != null ||
// //         emailError != null ||
// //         passwordError != null ||
// //         fullNameError != null ||
// //         phoneError != null) {
// //       setState(() => isLoading = false);
// //       return;
// //     }

// //     // Create entity
// //     final newUser = UserEntity(
// //       username: username.text.trim(),
// //       email: email.text.trim(),
// //       password: password.text.trim(),
// //       fullName: fullName.text.trim(),
// //       phone: phone.text.trim(),
// //     );

// //     try {
// //       // Initialize dependencies
// //       final apiClient = ApiClient(
// //         baseUrl: 'http://192.168.16.103:3000',
// //       ); // Replace with your actual backend URL
// //       final authLocalDataSource = AuthLocalDataSource();
// //       final authRemoteDataSource = AuthRemoteDataSource(client: apiClient);
// //       final authRepository = AuthRepositoryImpl(
// //         localDataSource: authLocalDataSource,
// //         remoteDataSource: authRemoteDataSource,
// //       );

// //       // Register using API
// //       final authUseCases = AuthUseCases(repository: authRepository);
// //       final response = await authUseCases.registerUser(newUser);

// //       // Optionally save to local Hive for offline access
// //       final saveUserUseCase = SaveUserUseCase(authRepository);
// //       await saveUserUseCase(newUser);

// //       if (mounted) {
// //         ScaffoldMessenger.of(
// //           context,
// //         ).showSnackBar(SnackBar(content: Text(response.message)));

// //         Navigator.pushReplacement(
// //           context,
// //           MaterialPageRoute(builder: (_) => const LoginScreen()),
// //         );
// //       }
// //     } catch (e) {
// //       if (mounted) {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           SnackBar(content: Text("Registration failed: ${e.toString()}")),
// //         );
// //       }
// //     } finally {
// //       if (mounted) {
// //         setState(() => isLoading = false);
// //       }
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: AppColors.background,
// //       body: SafeArea(
// //         child: SingleChildScrollView(
// //           padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 36),
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               Center(
// //                 child: Image.asset(
// //                   "assets/images/foodify_logo.png",
// //                   height: 110,
// //                 ),
// //               ),
// //               const SizedBox(height: 28),

// //               MyTextField(controller: username, hint: "Username"),
// //               if (usernameError != null)
// //                 Padding(
// //                   padding: const EdgeInsets.only(top: 4, left: 6),
// //                   child: Text(
// //                     usernameError!,
// //                     style: const TextStyle(color: Colors.red, fontSize: 13),
// //                   ),
// //                 ),
// //               const SizedBox(height: 14),

// //               MyTextField(
// //                 controller: email,
// //                 hint: "Email",
// //                 keyboardType: TextInputType.emailAddress,
// //               ),
// //               if (emailError != null)
// //                 Padding(
// //                   padding: const EdgeInsets.only(top: 4, left: 6),
// //                   child: Text(
// //                     emailError!,
// //                     style: const TextStyle(color: Colors.red, fontSize: 13),
// //                   ),
// //                 ),
// //               const SizedBox(height: 14),

// //               MyTextField(
// //                 controller: password,
// //                 hint: "Password",
// //                 obscure: true,
// //               ),
// //               if (passwordError != null)
// //                 Padding(
// //                   padding: const EdgeInsets.only(top: 4, left: 6),
// //                   child: Text(
// //                     passwordError!,
// //                     style: const TextStyle(color: Colors.red, fontSize: 13),
// //                   ),
// //                 ),
// //               const SizedBox(height: 14),

// //               MyTextField(controller: fullName, hint: "Full Name"),
// //               if (fullNameError != null)
// //                 Padding(
// //                   padding: const EdgeInsets.only(top: 4, left: 6),
// //                   child: Text(
// //                     fullNameError!,
// //                     style: const TextStyle(color: Colors.red, fontSize: 13),
// //                   ),
// //                 ),
// //               const SizedBox(height: 14),

// //               MyTextField(
// //                 controller: phone,
// //                 hint: "Phone Number",
// //                 keyboardType: TextInputType.phone,
// //               ),
// //               if (phoneError != null)
// //                 Padding(
// //                   padding: const EdgeInsets.only(top: 4, left: 6),
// //                   child: Text(
// //                     phoneError!,
// //                     style: const TextStyle(color: Colors.red, fontSize: 13),
// //                   ),
// //                 ),
// //               const SizedBox(height: 22),

// //               isLoading
// //                   ? const Center(child: CircularProgressIndicator())
// //                   : MyButton(text: "Register", onTap: _onRegister),

// //               const SizedBox(height: 18),

// //               Center(
// //                 child: GestureDetector(
// //                   onTap: () {
// //                     Navigator.push(
// //                       context,
// //                       MaterialPageRoute(builder: (_) => const LoginScreen()),
// //                     );
// //                   },
// //                   child: const Text(
// //                     "Already have an account? Login",
// //                     style: TextStyle(color: AppColors.primary),
// //                   ),
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   @override
// //   void dispose() {
// //     username.dispose();
// //     email.dispose();
// //     password.dispose();
// //     fullName.dispose();
// //     phone.dispose();
// //     super.dispose();
// //   }
// // }

// import 'package:flutter/material.dart';
// import '../widgets/my_textfield.dart';
// import '../widgets/my_button.dart';
// import '../../../../app/theme/app_colors.dart';
// import '../../../../core/api/api_client.dart';
// import 'login_screen.dart';
// import '../../domain/entities/user_entity.dart';
// import '../../data/datasources/local/auth_local_datasource.dart';
// import '../../data/datasources/remote/auth_remote_datasource.dart';
// import '../../data/repositories/auth_repository_impl.dart';
// import '../../domain/usecases/auth_usecases.dart';

// class RegisterScreen extends StatefulWidget {
//   const RegisterScreen({super.key});

//   @override
//   State<RegisterScreen> createState() => _RegisterScreenState();
// }

// class _RegisterScreenState extends State<RegisterScreen> {
//   final username = TextEditingController();
//   final email = TextEditingController();
//   final password = TextEditingController();
//   final fullName = TextEditingController();
//   final phone = TextEditingController();

//   String? usernameError;
//   String? emailError;
//   String? passwordError;
//   String? fullNameError;
//   String? phoneError;

//   bool isLoading = false;
//   bool isPasswordVisible = false; // ADD THIS

//   bool isValidEmail(String value) {
//     return value.contains("@") && value.endsWith(".com");
//   }

//   bool isValidPhone(String value) {
//     return value.length >= 10 && RegExp(r'^[0-9]+$').hasMatch(value);
//   }

//   void _onRegister() async {
//     setState(() {
//       usernameError = null;
//       emailError = null;
//       passwordError = null;
//       fullNameError = null;
//       phoneError = null;
//       isLoading = true;
//     });

//     // Validation
//     if (username.text.trim().isEmpty) {
//       usernameError = "Username cannot be empty";
//     }

//     if (email.text.trim().isEmpty) {
//       emailError = "Email cannot be empty";
//     } else if (!isValidEmail(email.text.trim())) {
//       emailError = "Enter a valid email ending with .com";
//     }

//     if (password.text.trim().isEmpty) {
//       passwordError = "Password cannot be empty";
//     } else if (password.text.trim().length < 6) {
//       passwordError = "Password must be at least 6 characters";
//     }

//     if (fullName.text.trim().isEmpty) {
//       fullNameError = "Full name cannot be empty";
//     }

//     if (phone.text.trim().isEmpty) {
//       phoneError = "Phone cannot be empty";
//     } else if (!isValidPhone(phone.text.trim())) {
//       phoneError = "Enter a valid phone number (10+ digits)";
//     }

//     if (usernameError != null ||
//         emailError != null ||
//         passwordError != null ||
//         fullNameError != null ||
//         phoneError != null) {
//       setState(() => isLoading = false);
//       return;
//     }

//     // Create entity
//     final newUser = UserEntity(
//       username: username.text.trim(),
//       email: email.text.trim(),
//       password: password.text.trim(),
//       fullName: fullName.text.trim(),
//       phone: phone.text.trim(),
//     );

//     try {
//       // Initialize dependencies
//       final apiClient = ApiClient(baseUrl: 'http://192.168.16.103:3000');
//       final authLocalDataSource = AuthLocalDataSource();
//       final authRemoteDataSource = AuthRemoteDataSource(client: apiClient);
//       final authRepository = AuthRepositoryImpl(
//         localDataSource: authLocalDataSource,
//         remoteDataSource: authRemoteDataSource,
//       );

//       // Register using API ONLY
//       final authUseCases = AuthUseCases(repository: authRepository);
//       final response = await authUseCases.registerUser(newUser);

//       // REMOVED: Hive save - not needed for API-based registration
//       // final saveUserUseCase = SaveUserUseCase(authRepository);
//       // await saveUserUseCase(newUser);

//       if (mounted) {
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text(response.message)));

//         // Navigate to login screen
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (_) => const LoginScreen()),
//         );
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Registration failed: ${e.toString()}")),
//         );
//       }
//     } finally {
//       if (mounted) {
//         setState(() => isLoading = false);
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.background,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 36),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Center(
//                 child: Image.asset(
//                   "assets/images/foodify_logo.png",
//                   height: 110,
//                 ),
//               ),
//               const SizedBox(height: 28),

//               MyTextField(controller: username, hint: "Username"),
//               if (usernameError != null)
//                 Padding(
//                   padding: const EdgeInsets.only(top: 4, left: 6),
//                   child: Text(
//                     usernameError!,
//                     style: const TextStyle(color: Colors.red, fontSize: 13),
//                   ),
//                 ),
//               const SizedBox(height: 14),

//               MyTextField(
//                 controller: email,
//                 hint: "Email",
//                 keyboardType: TextInputType.emailAddress,
//               ),
//               if (emailError != null)
//                 Padding(
//                   padding: const EdgeInsets.only(top: 4, left: 6),
//                   child: Text(
//                     emailError!,
//                     style: const TextStyle(color: Colors.red, fontSize: 13),
//                   ),
//                 ),
//               const SizedBox(height: 14),

//               MyTextField(
//                 controller: password,
//                 hint: "Password",
//                 obscure: true,
//               ),
//               if (passwordError != null)
//                 Padding(
//                   padding: const EdgeInsets.only(top: 4, left: 6),
//                   child: Text(
//                     passwordError!,
//                     style: const TextStyle(color: Colors.red, fontSize: 13),
//                   ),
//                 ),
//               const SizedBox(height: 14),

//               MyTextField(controller: fullName, hint: "Full Name"),
//               if (fullNameError != null)
//                 Padding(
//                   padding: const EdgeInsets.only(top: 4, left: 6),
//                   child: Text(
//                     fullNameError!,
//                     style: const TextStyle(color: Colors.red, fontSize: 13),
//                   ),
//                 ),
//               const SizedBox(height: 14),

//               MyTextField(
//                 controller: phone,
//                 hint: "Phone Number",
//                 keyboardType: TextInputType.phone,
//               ),
//               if (phoneError != null)
//                 Padding(
//                   padding: const EdgeInsets.only(top: 4, left: 6),
//                   child: Text(
//                     phoneError!,
//                     style: const TextStyle(color: Colors.red, fontSize: 13),
//                   ),
//                 ),
//               const SizedBox(height: 22),

//               isLoading
//                   ? const Center(child: CircularProgressIndicator())
//                   : MyButton(text: "Register", onTap: _onRegister),

//               const SizedBox(height: 18),

//               Center(
//                 child: GestureDetector(
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (_) => const LoginScreen()),
//                     );
//                   },
//                   child: const Text(
//                     "Already have an account? Login",
//                     style: TextStyle(color: AppColors.primary),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     username.dispose();
//     email.dispose();
//     password.dispose();
//     fullName.dispose();
//     phone.dispose();
//     super.dispose();
//   }
// }

import 'package:flutter/material.dart';
import '../widgets/my_textfield.dart';
import '../widgets/my_button.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/api/api_client.dart';
import 'login_screen.dart';
import '../../domain/entities/user_entity.dart';
import '../../data/datasources/local/auth_local_datasource.dart';
import '../../data/datasources/remote/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/usecases/auth_usecases.dart';
import '../../../../core/config/api_config.dart'; // Add this import at top

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
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

  bool isLoading = false;
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
      isLoading = true;
    });

    // Validation
    if (username.text.trim().isEmpty) {
      usernameError = "Username cannot be empty";
    }

    if (email.text.trim().isEmpty) {
      emailError = "Email cannot be empty";
    } else if (!isValidEmail(email.text.trim())) {
      emailError = "Enter a valid email ending with .com";
    }

    if (password.text.trim().isEmpty) {
      passwordError = "Password cannot be empty";
    } else if (password.text.trim().length < 6) {
      passwordError = "Password must be at least 6 characters";
    }

    if (fullName.text.trim().isEmpty) {
      fullNameError = "Full name cannot be empty";
    }

    if (phone.text.trim().isEmpty) {
      phoneError = "Phone cannot be empty";
    } else if (!isValidPhone(phone.text.trim())) {
      phoneError = "Enter a valid phone number (10+ digits)";
    }

    if (usernameError != null ||
        emailError != null ||
        passwordError != null ||
        fullNameError != null ||
        phoneError != null) {
      setState(() => isLoading = false);
      return;
    }

    // Create entity
    final newUser = UserEntity(
      username: username.text.trim(),
      email: email.text.trim(),
      password: password.text.trim(),
      fullName: fullName.text.trim(),
      phone: phone.text.trim(),
    );

    try {
      // Initialize dependencies
      // final apiClient = ApiClient(baseUrl: 'http://192.168.16.104:3000');
      final apiClient = ApiClient(baseUrl: ApiConfig.baseUrl);

      final authLocalDataSource = AuthLocalDataSource();
      final authRemoteDataSource = AuthRemoteDataSource(client: apiClient);
      final authRepository = AuthRepositoryImpl(
        localDataSource: authLocalDataSource,
        remoteDataSource: authRemoteDataSource,
      );

      // Register using API
      final authUseCases = AuthUseCases(repository: authRepository);
      final response = await authUseCases.registerUser(newUser);

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(response.message)));

        // Navigate to login screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Registration failed: ${e.toString()}")),
        );
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
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

              MyTextField(controller: username, hint: "Username"),
              if (usernameError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4, left: 6),
                  child: Text(
                    usernameError!,
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

              // Password field with toggle icon
              Stack(
                alignment: Alignment.centerRight,
                children: [
                  MyTextField(
                    controller: password,
                    hint: "Password",
                    obscure: !isPasswordVisible,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: IconButton(
                      icon: Icon(
                        isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.grey.shade600,
                        size: 22,
                      ),
                      onPressed: () {
                        setState(() {
                          isPasswordVisible = !isPasswordVisible;
                        });
                      },
                    ),
                  ),
                ],
              ),

              if (passwordError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4, left: 6),
                  child: Text(
                    passwordError!,
                    style: const TextStyle(color: Colors.red, fontSize: 13),
                  ),
                ),
              const SizedBox(height: 14),

              MyTextField(controller: fullName, hint: "Full Name"),
              if (fullNameError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4, left: 6),
                  child: Text(
                    fullNameError!,
                    style: const TextStyle(color: Colors.red, fontSize: 13),
                  ),
                ),
              const SizedBox(height: 14),

              MyTextField(
                controller: phone,
                hint: "Phone Number",
                keyboardType: TextInputType.phone,
              ),
              if (phoneError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4, left: 6),
                  child: Text(
                    phoneError!,
                    style: const TextStyle(color: Colors.red, fontSize: 13),
                  ),
                ),
              const SizedBox(height: 22),

              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : MyButton(text: "Register", onTap: _onRegister),

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

  @override
  void dispose() {
    username.dispose();
    email.dispose();
    password.dispose();
    fullName.dispose();
    phone.dispose();
    super.dispose();
  }
}
