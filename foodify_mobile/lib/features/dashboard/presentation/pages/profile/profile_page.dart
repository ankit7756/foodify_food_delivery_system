import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../app/theme/app_colors.dart';
import '../../../../auth/presentation/pages/login_screen.dart';
import '../../../../auth/presentation/view_model/auth_view_model.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  Future<void> _logout(BuildContext context, WidgetRef ref) async {
    // Call logout use case
    await ref.read(authViewModelProvider.notifier).logoutUser();

    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings_outlined, color: Colors.black87),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Center(
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 50,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Ankit Sharma',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'ankit@gmail.com',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _buildMenuItem(Icons.person_outline, 'Edit Profile', () {}),
                  _buildMenuItem(
                    Icons.location_on_outlined,
                    'Delivery Address',
                    () {},
                  ),
                  _buildMenuItem(
                    Icons.payment_outlined,
                    'Payment Methods',
                    () {},
                  ),
                  _buildMenuItem(
                    Icons.notifications_outlined,
                    'Notifications',
                    () {},
                  ),
                  _buildMenuItem(Icons.help_outline, 'Help & Support', () {}),
                  _buildMenuItem(Icons.info_outline, 'About', () {}),
                  const SizedBox(height: 20),
                  _buildMenuItem(Icons.logout, 'Logout', () {
                    showDialog(
                      context: context,
                      builder: (dialogContext) => AlertDialog(
                        title: const Text('Logout'),
                        content: const Text('Are you sure you want to logout?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(dialogContext),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(dialogContext);
                              _logout(context, ref);
                            },
                            child: const Text(
                              'Logout',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    );
                  }, isLogout: true),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    IconData icon,
    String title,
    VoidCallback onTap, {
    bool isLogout = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: isLogout ? Colors.red : AppColors.primary),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: isLogout ? Colors.red : Colors.black87,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey[400],
        ),
      ),
    );
  }
}
