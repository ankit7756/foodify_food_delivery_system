import 'package:flutter/material.dart';

class HelpSupportPage extends StatefulWidget {
  const HelpSupportPage({super.key});

  @override
  State<HelpSupportPage> createState() => _HelpSupportPageState();
}

class _HelpSupportPageState extends State<HelpSupportPage> {
  final List<Map<String, dynamic>> _faqs = [
    {
      'category': '🔐 Account & Login',
      'items': [
        {
          'q': 'I forgot my password. How do I reset it?',
          'a':
              'On the login screen, tap "Forgot Password?" and enter your registered email address along with your new password. Your password will be updated instantly.',
        },
        {
          'q': 'How do I update my profile information?',
          'a':
              'Go to Profile → Edit Profile. You can update your full name, username, phone number, and profile picture from there.',
        },
        {
          'q': 'Can I change my registered email address?',
          'a':
              'Currently email changes require contacting our support team. Please email us at foodify@gmail.com with your request.',
        },
      ],
    },
    {
      'category': '🛒 Orders & Delivery',
      'items': [
        {
          'q': 'How do I place an order?',
          'a':
              'Browse restaurants or food items on the Home page, add items to your cart, then go to Cart and tap Checkout. Fill in your delivery details and place your order.',
        },
        {
          'q': 'Can I cancel my order after placing it?',
          'a':
              'Yes! You can cancel your order as long as it is still in "Pending" status. Go to My Orders → tap the order → scroll down and tap Cancel Order.',
        },
        {
          'q': 'How do I confirm that my order was delivered?',
          'a':
              'Go to My Orders → tap your current order → scroll to the bottom and tap "Yes" under "Have you received your order?". This moves the order to your history.',
        },
        {
          'q': 'My order is taking too long. What should I do?',
          'a':
              'Delivery times can vary based on distance and restaurant preparation time. If your order has been pending for more than 45 minutes, please contact us at 9861790170.',
        },
        {
          'q': 'Can I order from multiple restaurants at once?',
          'a':
              'Currently Foodify supports one restaurant per order. If you add items from a different restaurant, you will be asked to clear your existing cart first.',
        },
      ],
    },
    {
      'category': '💳 Payments',
      'items': [
        {
          'q': 'What payment methods are accepted?',
          'a':
              'We accept Cash on Delivery, Khalti digital wallet, and eSewa digital wallet. More payment options are coming soon.',
        },
        {
          'q': 'How does Khalti payment work on this app?',
          'a':
              'Select Khalti at checkout, tap Pay with Khalti, enter your phone number and MPIN, then verify the OTP sent to your registered email. Payment is processed instantly.',
        },
        {
          'q': 'I was charged but my order was not placed. What do I do?',
          'a':
              'This is rare but if it happens, please contact us immediately at foodify@gmail.com or call 9861790170 with your payment details and we will resolve it within 24 hours.',
        },
      ],
    },
    {
      'category': '⭐ Reviews & Ratings',
      'items': [
        {
          'q': 'How do I leave a review for my order?',
          'a':
              'Go to My Orders → History tab → tap on a delivered order → scroll down and tap Write a Review. Rate with stars and share your experience.',
        },
        {
          'q': 'Can I edit or delete my review?',
          'a':
              'Currently reviews cannot be edited once submitted. If you need to remove a review, please contact our support team.',
        },
      ],
    },
    {
      'category': '🔔 Notifications',
      'items': [
        {
          'q': 'How do I view my notifications?',
          'a':
              'Tap the bell icon on the top right of the Home page. A badge shows unread notification count.',
        },
        {
          'q': 'How do I delete a notification?',
          'a':
              'On the Notifications page, swipe left on any notification or tap the trash icon on the right side to remove it.',
        },
      ],
    },
  ];

  final Map<String, bool> _expanded = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        title: const Text(
          'Help & Support',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF6B35), Color(0xFFFF8C42)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'How can we help you? 👋',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Find answers to common questions below or contact us directly.',
                    style: TextStyle(fontSize: 13, color: Colors.white70),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            const Text(
              'Frequently Asked Questions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 16),

            // FAQ accordion
            ..._faqs.map((category) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10, top: 8),
                    child: Text(
                      category['category'],
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  ...(category['items'] as List<Map<String, String>>).map((
                    faq,
                  ) {
                    final key = '${category['category']}_${faq['q']}';
                    final isOpen = _expanded[key] ?? false;
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
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: ExpansionTile(
                          initiallyExpanded: false,
                          tilePadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          childrenPadding: const EdgeInsets.only(
                            left: 16,
                            right: 16,
                            bottom: 16,
                          ),
                          iconColor: const Color(0xFFFF6B35),
                          collapsedIconColor: Colors.grey,
                          title: Text(
                            faq['q']!,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          children: [
                            Text(
                              faq['a']!,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              );
            }),

            const SizedBox(height: 32),

            // Contact section
            const Text(
              'Still need help?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),

            _buildContactCard(
              Icons.email_outlined,
              'Email Us',
              'foodify@gmail.com',
              'We respond within 24 hours',
              const Color(0xFFFF6B35),
            ),
            const SizedBox(height: 12),
            _buildContactCard(
              Icons.phone_outlined,
              'Call Us',
              '9861790170',
              'Mon-Sat, 9AM - 6PM',
              Colors.green,
            ),
            const SizedBox(height: 12),
            _buildContactCard(
              Icons.access_time_outlined,
              'Support Hours',
              'Mon - Saturday',
              '9:00 AM to 6:00 PM NPT',
              Colors.blue,
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard(
    IconData icon,
    String title,
    String value,
    String subtitle,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
