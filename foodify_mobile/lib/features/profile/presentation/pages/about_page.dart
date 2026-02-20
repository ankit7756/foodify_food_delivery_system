import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        title: const Text(
          'About Foodify',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 40),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFFF6B35), Color(0xFFFF8C42)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text('🍔', style: TextStyle(fontSize: 42)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Foodify',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Delivering Happiness, One Bite at a Time',
                    style: TextStyle(fontSize: 14, color: Colors.white70),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Version 1.0.0',
                      style: TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Our Story
                  _buildSection(
                    '📖 Our Story',
                    'Foodify was born out of a simple frustration — great food was everywhere, but getting it delivered was always a hassle. We set out to build a platform that connects hungry customers with the best local restaurants in the most seamless way possible.\n\nWhat started as a college project quickly grew into a full-featured food delivery system with real backend integration, secure payments, and a smooth user experience that rivals professional applications.',
                  ),

                  const SizedBox(height: 24),

                  // Our Mission
                  _buildSection(
                    '🎯 Our Mission',
                    'To make quality food accessible to everyone, everywhere — with speed, reliability, and a smile. We believe every meal should be an experience worth remembering.',
                  ),

                  const SizedBox(height: 24),

                  // Why Foodify
                  const Text(
                    '✨ Why Choose Foodify?',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildFeatureCard(
                    '🏆',
                    'Only the Best Restaurants',
                    'We partner exclusively with top-rated, quality-verified restaurants. Every restaurant on Foodify meets our strict hygiene and quality standards.',
                  ),
                  const SizedBox(height: 12),
                  _buildFeatureCard(
                    '⚡',
                    'Lightning Fast Delivery',
                    'Our optimized delivery network ensures your food arrives hot and fresh. Average delivery time under 30 minutes.',
                  ),
                  const SizedBox(height: 12),
                  _buildFeatureCard(
                    '🔒',
                    'Secure & Reliable Payments',
                    'We support multiple secure payment methods including Khalti and eSewa. Your payment information is always encrypted.',
                  ),
                  const SizedBox(height: 12),
                  _buildFeatureCard(
                    '📱',
                    'Built for Everyone',
                    'Foodify is designed with simplicity in mind. Easy to browse, easy to order, easy to track — for users of all ages.',
                  ),
                  const SizedBox(height: 12),
                  _buildFeatureCard(
                    '💬',
                    'Real Customer Support',
                    'Got an issue? Our support team is just a call or email away, available 6 days a week to help you.',
                  ),

                  const SizedBox(height: 28),

                  // Stats
                  const Text(
                    '📊 Foodify by Numbers',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(child: _buildStatCard('5+', 'Restaurants')),
                      const SizedBox(width: 12),
                      Expanded(child: _buildStatCard('15+', 'Food Items')),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _buildStatCard('3', 'Payment Options')),
                      const SizedBox(width: 12),
                      Expanded(child: _buildStatCard('24/7', 'App Available')),
                    ],
                  ),

                  const SizedBox(height: 28),

                  // Team
                  const Text(
                    '👨‍💻 The Team',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildTeamCard(
                    'Mobile App Developer',
                    'Flutter • Riverpod • Clean Architecture',
                    '📱',
                  ),
                  const SizedBox(height: 12),
                  _buildTeamCard(
                    'Backend Developer',
                    'Node.js • TypeScript • MongoDB',
                    '⚙️',
                  ),
                  const SizedBox(height: 12),
                  _buildTeamCard(
                    'Web Developer',
                    'React.js • REST API Integration',
                    '🌐',
                  ),

                  const SizedBox(height: 28),

                  // Built with
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Text(
                          '🛠️ Built With',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          alignment: WrapAlignment.center,
                          children:
                              [
                                'Flutter',
                                'Dart',
                                'Node.js',
                                'TypeScript',
                                'MongoDB',
                                'Express.js',
                                'Riverpod',
                                'REST API',
                              ].map((tech) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(
                                      0xFFFF6B35,
                                    ).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    tech,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFFFF6B35),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                );
                              }).toList(),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Footer
                  Center(
                    child: Column(
                      children: [
                        const Text(
                          '🍽️ Foodify',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFF6B35),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Made with ❤️ in Nepal',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[500],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '© 2025 Foodify. All rights reserved.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          content,
          style: TextStyle(fontSize: 14, color: Colors.grey[600], height: 1.6),
        ),
      ],
    );
  }

  Widget _buildFeatureCard(String emoji, String title, String description) {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 28)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String value, String label) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFF6B35),
            ),
          ),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 13, color: Colors.grey[500])),
        ],
      ),
    );
  }

  Widget _buildTeamCard(String role, String tech, String emoji) {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFFF6B35).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(emoji, style: const TextStyle(fontSize: 24)),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  role,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  tech,
                  style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
