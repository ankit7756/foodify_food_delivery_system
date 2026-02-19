import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../auth/presentation/pages/login_screen.dart';
import '../../../auth/presentation/view_model/auth_view_model.dart';
import 'edit_profile_page.dart';
import '../view_model/profile_view_model.dart';
import '../state/profile_state.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  @override
  void initState() {
    super.initState();
    // Load profile when page opens
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

  // ✅ ADD: Manual refresh method
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
                physics:
                    const AlwaysScrollableScrollPhysics(), // ✅ For pull to refresh
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

                          // Name
                          Text(
                            profileState.profile?.fullName ?? 'User Name',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 4),

                          // Username
                          Text(
                            '@${profileState.profile?.username ?? 'username'}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),

                          const SizedBox(height: 4),

                          // Email
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
                              // ✅ FIXED: Navigate and refresh on return
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const EditProfilePage(),
                                ),
                              );
                              // Refresh profile after returning from edit page
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
                        children: [
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
                          _buildMenuItem(
                            Icons.help_outline,
                            'Help & Support',
                            () {},
                          ),
                          _buildMenuItem(Icons.info_outline, 'About', () {}),
                          const SizedBox(height: 20),
                          _buildMenuItem(Icons.logout, 'Logout', () {
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
                          }, isLogout: true),
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
        leading: Icon(
          icon,
          color: isLogout ? Colors.red : const Color(0xFFFF6B35),
        ),
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
