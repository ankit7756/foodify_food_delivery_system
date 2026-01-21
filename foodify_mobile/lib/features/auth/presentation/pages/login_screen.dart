// // // import 'package:flutter/material.dart';
// // // import 'package:foodify_food_delivery_system/features/dashboard/presentation/pages/dashboard_screen.dart';
// // // import '../widgets/my_textfield.dart';
// // // import '../widgets/my_button.dart';
// // // import '../../../../app/theme/app_colors.dart';
// // // import 'register_screen.dart';
// // // import '../../domain/entities/user_entity.dart'; // NEW
// // // import '../../data/datasources/local/auth_local_datasource.dart'; // NEW
// // // import '../../data/repositories/auth_repository_impl.dart'; // NEW
// // // import '../../domain/usecases/auth_usecases.dart';

// // // final authLocalDataSource = AuthLocalDataSource(); // NEW
// // // final authRepository = AuthRepositoryImpl(
// // //   localDataSource: authLocalDataSource,
// // // ); // NEW

// // // class LoginScreen extends StatefulWidget {
// // //   const LoginScreen({super.key});

// // //   @override
// // //   State<LoginScreen> createState() => _LoginScreenState();
// // // }

// // // class _LoginScreenState extends State<LoginScreen> {
// // //   final email = TextEditingController();
// // //   final password = TextEditingController();

// // //   String? emailError;
// // //   String? passwordError;

// // //   bool isLoading = false; // NEW
// // //   bool isValidEmail(String value) {
// // //     return value.contains("@") && value.endsWith(".com");
// // //   }

// // //   void _onLogin() async {
// // //     setState(() {
// // //       emailError = null;
// // //       passwordError = null;
// // //       isLoading = true; // NEW: show loading
// // //     });

// // //     // Your original validation
// // //     if (email.text.trim().isEmpty) {
// // //       emailError = "Email cannot be empty";
// // //     } else if (!isValidEmail(email.text.trim())) {
// // //       emailError = "Enter a valid email ending with .com";
// // //     }

// // //     if (password.text.trim().isEmpty) {
// // //       passwordError = "Password cannot be empty";
// // //     }

// // //     if (emailError != null || passwordError != null) {
// // //       setState(() => isLoading = false); // NEW: stop loading
// // //       return;
// // //     }

// // //     // === NEW: Check user from Hive ===
// // //     try {
// // //       // Use GetUserUseCase to get user
// // //       final getUserUseCase = GetUserUseCase(authRepository); // NEW
// // //       final user = getUserUseCase(email.text.trim()); // NEW

// // //       if (user != null && user.password == password.text.trim()) {
// // //         // Success
// // //         if (mounted) {
// // //           ScaffoldMessenger.of(context).showSnackBar(
// // //             const SnackBar(content: Text("Login successful!")), // NEW
// // //           );

// // //           Navigator.pushReplacement(
// // //             context,
// // //             MaterialPageRoute(builder: (_) => const DashboardScreen()),
// // //           );
// // //         }
// // //       } else {
// // //         // Fail
// // //         if (mounted) {
// // //           setState(
// // //             () => passwordError = "Invalid email or password",
// // //           ); // NEW: set error
// // //         }
// // //       }
// // //     } catch (e) {
// // //       if (mounted) {
// // //         ScaffoldMessenger.of(context).showSnackBar(
// // //           SnackBar(content: Text("Login failed: $e")), // NEW
// // //         );
// // //       }
// // //     } finally {
// // //       if (mounted) {
// // //         setState(() => isLoading = false); // NEW: stop loading
// // //       }
// // //     }
// // //   }

// // //   Widget socialTile(String asset) {
// // //     return Container(
// // //       width: 56,
// // //       height: 56,
// // //       decoration: BoxDecoration(
// // //         color: Colors.white,
// // //         shape: BoxShape.circle,
// // //         boxShadow: [
// // //           BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8),
// // //         ],
// // //       ),
// // //       child: Padding(
// // //         padding: const EdgeInsets.all(10),
// // //         child: Image.asset(asset, fit: BoxFit.contain),
// // //       ),
// // //     );
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       backgroundColor: AppColors.background,
// // //       body: SafeArea(
// // //         child: Center(
// // //           child: SingleChildScrollView(
// // //             padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
// // //             child: Column(
// // //               crossAxisAlignment: CrossAxisAlignment.start,
// // //               children: [
// // //                 Center(
// // //                   child: Image.asset(
// // //                     "assets/images/foodify_logo.png",
// // //                     height: 120,
// // //                   ),
// // //                 ),
// // //                 const SizedBox(height: 30),

// // //                 MyTextField(
// // //                   controller: email,
// // //                   hint: "Email",
// // //                   keyboardType: TextInputType.emailAddress,
// // //                 ),

// // //                 if (emailError != null)
// // //                   Padding(
// // //                     padding: const EdgeInsets.only(top: 4, left: 6),
// // //                     child: Text(
// // //                       emailError!,
// // //                       style: const TextStyle(color: Colors.red, fontSize: 13),
// // //                     ),
// // //                   ),

// // //                 const SizedBox(height: 14),

// // //                 MyTextField(
// // //                   controller: password,
// // //                   hint: "Password",
// // //                   obscure: true,
// // //                 ),

// // //                 if (passwordError != null)
// // //                   Padding(
// // //                     padding: const EdgeInsets.only(top: 4, left: 6),
// // //                     child: Text(
// // //                       passwordError!,
// // //                       style: const TextStyle(color: Colors.red, fontSize: 13),
// // //                     ),
// // //                   ),

// // //                 const SizedBox(height: 20),

// // //                 MyButton(text: "Login", onTap: _onLogin),

// // //                 const SizedBox(height: 16),

// // //                 Row(
// // //                   children: [
// // //                     Expanded(child: Divider(color: Colors.grey.shade300)),
// // //                     const Padding(
// // //                       padding: EdgeInsets.symmetric(horizontal: 10),
// // //                       child: Text("or continue with"),
// // //                     ),
// // //                     Expanded(child: Divider(color: Colors.grey.shade300)),
// // //                   ],
// // //                 ),

// // //                 const SizedBox(height: 14),

// // //                 Row(
// // //                   mainAxisAlignment: MainAxisAlignment.center,
// // //                   children: [
// // //                     socialTile("assets/images/google_logo.png"),
// // //                     const SizedBox(width: 16),
// // //                     socialTile("assets/images/github_logo.png"),
// // //                   ],
// // //                 ),

// // //                 const SizedBox(height: 18),

// // //                 Center(
// // //                   child: GestureDetector(
// // //                     onTap: () {
// // //                       Navigator.push(
// // //                         context,
// // //                         MaterialPageRoute(
// // //                           builder: (_) => const RegisterScreen(),
// // //                         ),
// // //                       );
// // //                     },
// // //                     child: const Text(
// // //                       "Don't have an account? Register",
// // //                       style: TextStyle(color: AppColors.primary),
// // //                     ),
// // //                   ),
// // //                 ),
// // //               ],
// // //             ),
// // //           ),
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }

// // import 'package:flutter/material.dart';
// // import 'package:foodify_food_delivery_system/features/dashboard/presentation/pages/dashboard_screen.dart';
// // import '../../../../core/api/api_client.dart';
// // import '../../../../core/storage/user_session_service.dart';
// // import '../widgets/my_textfield.dart';
// // import '../widgets/my_button.dart';
// // import '../../../../app/theme/app_colors.dart';
// // import 'register_screen.dart';
// // import '../../data/datasources/local/auth_local_datasource.dart';
// // import '../../data/datasources/remote/auth_remote_datasource.dart';
// // import '../../data/repositories/auth_repository_impl.dart';
// // import '../../domain/usecases/auth_usecases.dart';

// // class LoginScreen extends StatefulWidget {
// //   const LoginScreen({super.key});

// //   @override
// //   State<LoginScreen> createState() => _LoginScreenState();
// // }

// // class _LoginScreenState extends State<LoginScreen> {
// //   final email = TextEditingController();
// //   final password = TextEditingController();

// //   String? emailError;
// //   String? passwordError;

// //   bool isLoading = false;

// //   bool isValidEmail(String value) {
// //     return value.contains("@") && value.endsWith(".com");
// //   }

// //   void _onLogin() async {
// //     setState(() {
// //       emailError = null;
// //       passwordError = null;
// //       isLoading = true;
// //     });

// //     // Validation
// //     if (email.text.trim().isEmpty) {
// //       emailError = "Email cannot be empty";
// //     } else if (!isValidEmail(email.text.trim())) {
// //       emailError = "Enter a valid email ending with .com";
// //     }

// //     if (password.text.trim().isEmpty) {
// //       passwordError = "Password cannot be empty";
// //     }

// //     if (emailError != null || passwordError != null) {
// //       setState(() => isLoading = false);
// //       return;
// //     }

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

// //       // Login using API
// //       final authUseCases = AuthUseCases(repository: authRepository);
// //       final response = await authUseCases.loginUser(
// //         email.text.trim(),
// //         password.text.trim(),
// //       );

// //       // Save token and email to session
// //       if (response.token != null) {
// //         await UserSessionService.saveToken(response.token!);
// //         await UserSessionService.saveEmail(email.text.trim());
// //       }

// //       if (mounted) {
// //         ScaffoldMessenger.of(
// //           context,
// //         ).showSnackBar(SnackBar(content: Text(response.message)));

// //         Navigator.pushReplacement(
// //           context,
// //           MaterialPageRoute(builder: (_) => const DashboardScreen()),
// //         );
// //       }
// //     } catch (e) {
// //       if (mounted) {
// //         setState(() => passwordError = "Invalid email or password");
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           SnackBar(content: Text("Login failed: ${e.toString()}")),
// //         );
// //       }
// //     } finally {
// //       if (mounted) {
// //         setState(() => isLoading = false);
// //       }
// //     }
// //   }

// //   Widget socialTile(String asset) {
// //     return Container(
// //       width: 56,
// //       height: 56,
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         shape: BoxShape.circle,
// //         boxShadow: [
// //           BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8),
// //         ],
// //       ),
// //       child: Padding(
// //         padding: const EdgeInsets.all(10),
// //         child: Image.asset(asset, fit: BoxFit.contain),
// //       ),
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: AppColors.background,
// //       body: SafeArea(
// //         child: Center(
// //           child: SingleChildScrollView(
// //             padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Center(
// //                   child: Image.asset(
// //                     "assets/images/foodify_logo.png",
// //                     height: 120,
// //                   ),
// //                 ),
// //                 const SizedBox(height: 30),

// //                 MyTextField(
// //                   controller: email,
// //                   hint: "Email",
// //                   keyboardType: TextInputType.emailAddress,
// //                 ),

// //                 if (emailError != null)
// //                   Padding(
// //                     padding: const EdgeInsets.only(top: 4, left: 6),
// //                     child: Text(
// //                       emailError!,
// //                       style: const TextStyle(color: Colors.red, fontSize: 13),
// //                     ),
// //                   ),

// //                 const SizedBox(height: 14),

// //                 MyTextField(
// //                   controller: password,
// //                   hint: "Password",
// //                   obscure: true,
// //                 ),

// //                 if (passwordError != null)
// //                   Padding(
// //                     padding: const EdgeInsets.only(top: 4, left: 6),
// //                     child: Text(
// //                       passwordError!,
// //                       style: const TextStyle(color: Colors.red, fontSize: 13),
// //                     ),
// //                   ),

// //                 const SizedBox(height: 20),

// //                 isLoading
// //                     ? const Center(child: CircularProgressIndicator())
// //                     : MyButton(text: "Login", onTap: _onLogin),

// //                 const SizedBox(height: 16),

// //                 Row(
// //                   children: [
// //                     Expanded(child: Divider(color: Colors.grey.shade300)),
// //                     const Padding(
// //                       padding: EdgeInsets.symmetric(horizontal: 10),
// //                       child: Text("or continue with"),
// //                     ),
// //                     Expanded(child: Divider(color: Colors.grey.shade300)),
// //                   ],
// //                 ),

// //                 const SizedBox(height: 14),

// //                 Row(
// //                   mainAxisAlignment: MainAxisAlignment.center,
// //                   children: [
// //                     socialTile("assets/images/google_logo.png"),
// //                     const SizedBox(width: 16),
// //                     socialTile("assets/images/github_logo.png"),
// //                   ],
// //                 ),

// //                 const SizedBox(height: 18),

// //                 Center(
// //                   child: GestureDetector(
// //                     onTap: () {
// //                       Navigator.push(
// //                         context,
// //                         MaterialPageRoute(
// //                           builder: (_) => const RegisterScreen(),
// //                         ),
// //                       );
// //                     },
// //                     child: const Text(
// //                       "Don't have an account? Register",
// //                       style: TextStyle(color: AppColors.primary),
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   @override
// //   void dispose() {
// //     email.dispose();
// //     password.dispose();
// //     super.dispose();
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'package:foodify_food_delivery_system/features/dashboard/presentation/pages/dashboard_screen.dart';
// import '../../../../core/api/api_client.dart';
// import '../../../../core/storage/user_session_service.dart';
// import '../widgets/my_textfield.dart';
// import '../widgets/my_button.dart';
// import '../../../../app/theme/app_colors.dart';
// import 'register_screen.dart';
// import '../../data/datasources/local/auth_local_datasource.dart';
// import '../../data/datasources/remote/auth_remote_datasource.dart';
// import '../../data/repositories/auth_repository_impl.dart';
// import '../../domain/usecases/auth_usecases.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final email = TextEditingController();
//   final password = TextEditingController();

//   String? emailError;
//   String? passwordError;

//   bool isLoading = false;
//   bool isPasswordVisible = false; // ADD THIS

//   bool isValidEmail(String value) {
//     return value.contains("@") && value.endsWith(".com");
//   }

//   void _onLogin() async {
//     setState(() {
//       emailError = null;
//       passwordError = null;
//       isLoading = true;
//     });

//     // Validation
//     if (email.text.trim().isEmpty) {
//       emailError = "Email cannot be empty";
//     } else if (!isValidEmail(email.text.trim())) {
//       emailError = "Enter a valid email ending with .com";
//     }

//     if (password.text.trim().isEmpty) {
//       passwordError = "Password cannot be empty";
//     }

//     if (emailError != null || passwordError != null) {
//       setState(() => isLoading = false);
//       return;
//     }

//     try {
//       // Initialize dependencies
//       final apiClient = ApiClient(
//         baseUrl: 'http://your-backend-url.com',
//       ); // Replace with your actual backend URL
//       final authLocalDataSource = AuthLocalDataSource();
//       final authRemoteDataSource = AuthRemoteDataSource(client: apiClient);
//       final authRepository = AuthRepositoryImpl(
//         localDataSource: authLocalDataSource,
//         remoteDataSource: authRemoteDataSource,
//       );

//       // Login using API
//       final authUseCases = AuthUseCases(repository: authRepository);
//       final response = await authUseCases.loginUser(
//         email.text.trim(),
//         password.text.trim(),
//       );

//       // Save token and email to session
//       if (response.token != null) {
//         await UserSessionService.saveToken(response.token!);
//         await UserSessionService.saveEmail(email.text.trim());
//       }

//       if (mounted) {
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text(response.message)));

//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (_) => const DashboardScreen()),
//         );
//       }
//     } catch (e) {
//       if (mounted) {
//         setState(() => passwordError = "Invalid email or password");
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Login failed: ${e.toString()}")),
//         );
//       }
//     } finally {
//       if (mounted) {
//         setState(() => isLoading = false);
//       }
//     }
//   }

//   Widget socialTile(String asset) {
//     return Container(
//       width: 56,
//       height: 56,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         shape: BoxShape.circle,
//         boxShadow: [
//           BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8),
//         ],
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(10),
//         child: Image.asset(asset, fit: BoxFit.contain),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.background,
//       body: SafeArea(
//         child: Center(
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Center(
//                   child: Image.asset(
//                     "assets/images/foodify_logo.png",
//                     height: 120,
//                   ),
//                 ),
//                 const SizedBox(height: 30),

//                 MyTextField(
//                   controller: email,
//                   hint: "Email",
//                   keyboardType: TextInputType.emailAddress,
//                 ),

//                 if (emailError != null)
//                   Padding(
//                     padding: const EdgeInsets.only(top: 4, left: 6),
//                     child: Text(
//                       emailError!,
//                       style: const TextStyle(color: Colors.red, fontSize: 13),
//                     ),
//                   ),

//                 const SizedBox(height: 14),

//                 MyTextField(
//                   controller: password,
//                   hint: "Password",
//                   obscure: true,
//                 ),

//                 if (passwordError != null)
//                   Padding(
//                     padding: const EdgeInsets.only(top: 4, left: 6),
//                     child: Text(
//                       passwordError!,
//                       style: const TextStyle(color: Colors.red, fontSize: 13),
//                     ),
//                   ),

//                 const SizedBox(height: 20),

//                 isLoading
//                     ? const Center(child: CircularProgressIndicator())
//                     : MyButton(text: "Login", onTap: _onLogin),

//                 const SizedBox(height: 16),

//                 Row(
//                   children: [
//                     Expanded(child: Divider(color: Colors.grey.shade300)),
//                     const Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 10),
//                       child: Text("or continue with"),
//                     ),
//                     Expanded(child: Divider(color: Colors.grey.shade300)),
//                   ],
//                 ),

//                 const SizedBox(height: 14),

//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     socialTile("assets/images/google_logo.png"),
//                     const SizedBox(width: 16),
//                     socialTile("assets/images/github_logo.png"),
//                   ],
//                 ),

//                 const SizedBox(height: 18),

//                 Center(
//                   child: GestureDetector(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (_) => const RegisterScreen(),
//                         ),
//                       );
//                     },
//                     child: const Text(
//                       "Don't have an account? Register",
//                       style: TextStyle(color: AppColors.primary),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     email.dispose();
//     password.dispose();
//     super.dispose();
//   }
// }

import 'package:flutter/material.dart';
import 'package:foodify_food_delivery_system/features/dashboard/presentation/pages/dashboard_screen.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/storage/user_session_service.dart';
import '../widgets/my_textfield.dart';
import '../widgets/my_button.dart';
import '../../../../app/theme/app_colors.dart';
import 'register_screen.dart';
import '../../data/datasources/local/auth_local_datasource.dart';
import '../../data/datasources/remote/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/usecases/auth_usecases.dart';
import '../../../../core/config/api_config.dart'; // Add this import at top

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final email = TextEditingController();
  final password = TextEditingController();

  String? emailError;
  String? passwordError;

  bool isLoading = false;
  bool isPasswordVisible = false;

  bool isValidEmail(String value) {
    return value.contains("@") && value.endsWith(".com");
  }

  void _onLogin() async {
    setState(() {
      emailError = null;
      passwordError = null;
      isLoading = true;
    });

    // Validation
    if (email.text.trim().isEmpty) {
      emailError = "Email cannot be empty";
    } else if (!isValidEmail(email.text.trim())) {
      emailError = "Enter a valid email ending with .com";
    }

    if (password.text.trim().isEmpty) {
      passwordError = "Password cannot be empty";
    }

    if (emailError != null || passwordError != null) {
      setState(() => isLoading = false);
      return;
    }

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

      // Login using API
      final authUseCases = AuthUseCases(repository: authRepository);
      final response = await authUseCases.loginUser(
        email.text.trim(),
        password.text.trim(),
      );

      // Save token and email to session
      if (response.token != null) {
        await UserSessionService.saveToken(response.token!);
        await UserSessionService.saveEmail(email.text.trim());
      }

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(response.message)));

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const DashboardScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => passwordError = "Invalid email or password");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Login failed: ${e.toString()}")),
        );
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Widget socialTile(String asset) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Image.asset(asset, fit: BoxFit.contain),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.asset(
                    "assets/images/foodify_logo.png",
                    height: 120,
                  ),
                ),
                const SizedBox(height: 30),

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

                const SizedBox(height: 20),

                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : MyButton(text: "Login", onTap: _onLogin),

                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(child: Divider(color: Colors.grey.shade300)),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text("or continue with"),
                    ),
                    Expanded(child: Divider(color: Colors.grey.shade300)),
                  ],
                ),

                const SizedBox(height: 14),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    socialTile("assets/images/google_logo.png"),
                    const SizedBox(width: 16),
                    socialTile("assets/images/github_logo.png"),
                  ],
                ),

                const SizedBox(height: 18),

                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const RegisterScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      "Don't have an account? Register",
                      style: TextStyle(color: AppColors.primary),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }
}
