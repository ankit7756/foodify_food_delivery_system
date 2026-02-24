import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/pages/login_screen.dart';
import '../../../auth/presentation/view_model/auth_view_model.dart';
import '../../../notifications/presentation/pages/notification_page.dart';
import 'edit_profile_page.dart';
import 'delivery_address_page.dart';
import 'payment_methods_page.dart';
import 'help_support_page.dart';
import 'about_page.dart';
import '../view_model/profile_view_model.dart';
import '../state/profile_state.dart';
import 'my_reviews_page.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(profileViewModelProvider.notifier).loadProfile();
    });
  }

  Future<void> _logout(BuildContext context, WidgetRef ref) async {
    await ref.read(authViewModelProvider.notifier).logoutUser();
    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  Future<void> _refreshProfile() async {
    await ref.read(profileViewModelProvider.notifier).loadProfile();
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileViewModelProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshProfile,
        child: profileState.status == ProfileStatus.loading
            ? const Center(child: CircularProgressIndicator())
            : profileState.status == ProfileStatus.error
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(profileState.errorMessage ?? 'Error loading profile'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _refreshProfile,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              )
            : SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    const SizedBox(height: 20),

                    // Profile Picture & Info
                    Center(
                      child: Column(
                        children: [
                          // Profile Image
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF6B35).withOpacity(0.1),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFFFF6B35),
                                width: 3,
                              ),
                            ),
                            child: profileState.profile?.profileImage != null
                                ? ClipOval(
                                    child: Image.network(
                                      profileState.profile!.profileImage!,
                                      fit: BoxFit.cover,
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                            if (loadingProgress == null)
                                              return child;
                                            return const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          },
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return const Icon(
                                              Icons.person,
                                              size: 60,
                                              color: Color(0xFFFF6B35),
                                            );
                                          },
                                    ),
                                  )
                                : const Icon(
                                    Icons.person,
                                    size: 60,
                                    color: Color(0xFFFF6B35),
                                  ),
                          ),

                          const SizedBox(height: 16),

                          Text(
                            profileState.profile?.fullName ?? 'User Name',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 4),

                          Text(
                            '@${profileState.profile?.username ?? 'username'}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),

                          const SizedBox(height: 4),

                          Text(
                            profileState.profile?.email ?? 'email@example.com',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Edit Profile Button
                          ElevatedButton.icon(
                            onPressed: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const EditProfilePage(),
                                ),
                              );
                              _refreshProfile();
                            },
                            icon: const Icon(Icons.edit),
                            label: const Text('Edit Profile'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFF6B35),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Menu Items
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Account section
                          const Padding(
                            padding: EdgeInsets.only(left: 4, bottom: 12),
                            child: Text(
                              'Account',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          _buildMenuItem(
                            Icons.location_on_outlined,
                            'Delivery Addresses',
                            'Manage your saved addresses',
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const DeliveryAddressPage(),
                              ),
                            ),
                          ),
                          _buildMenuItem(
                            Icons.payment_outlined,
                            'Payment Methods',
                            'Manage your payment options',
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const PaymentMethodsPage(),
                              ),
                            ),
                          ),
                          _buildMenuItem(
                            Icons.rate_review_outlined,
                            'My Reviews',
                            'See all your food reviews',
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const MyReviewsPage(),
                              ),
                            ),
                          ),
                          _buildMenuItem(
                            Icons.notifications_outlined,
                            'Notifications',
                            'View your notifications',
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const NotificationPage(),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Support section
                          const Padding(
                            padding: EdgeInsets.only(left: 4, bottom: 12),
                            child: Text(
                              'Support',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          _buildMenuItem(
                            Icons.help_outline,
                            'Help & Support',
                            'FAQs and contact us',
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const HelpSupportPage(),
                              ),
                            ),
                          ),
                          _buildMenuItem(
                            Icons.info_outline,
                            'About Foodify',
                            'Our story and mission',
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const AboutPage(),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Logout
                          const Padding(
                            padding: EdgeInsets.only(left: 4, bottom: 12),
                            child: Text(
                              'Session',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          _buildMenuItem(
                            Icons.logout,
                            'Logout',
                            'Sign out of your account',
                            () {
                              showDialog(
                                context: context,
                                builder: (dialogContext) => AlertDialog(
                                  title: const Text('Logout'),
                                  content: const Text(
                                    'Are you sure you want to logout?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(dialogContext),
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
                            },
                            isLogout: true,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // App version footer
                    Text(
                      'Foodify v1.0.0',
                      style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildMenuItem(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap, {
    bool isLogout = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isLogout
                ? Colors.red.withOpacity(0.1)
                : const Color(0xFFFF6B35).withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: isLogout ? Colors.red : const Color(0xFFFF6B35),
            size: 22,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
            color: isLogout ? Colors.red : Colors.black87,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(fontSize: 12, color: Colors.grey[400]),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 14,
          color: Colors.grey[300],
        ),
      ),
    );
  }
}
