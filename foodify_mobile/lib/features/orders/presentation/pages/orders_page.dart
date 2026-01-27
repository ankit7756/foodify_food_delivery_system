import 'package:flutter/material.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFFAFAFA),
        appBar: AppBar(
          title: const Text(
            'My Orders',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          bottom: TabBar(
            labelColor: const Color(0xFFFF6B35),
            unselectedLabelColor: Colors.grey,
            indicatorColor: const Color(0xFFFF6B35),
            tabs: const [
              Tab(text: 'Current'),
              Tab(text: 'History'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Current Orders Tab
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    size: 100,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'No active orders',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Place your first order!',
                    style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                  ),
                ],
              ),
            ),

            // Order History Tab
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 100, color: Colors.grey[300]),
                  const SizedBox(height: 24),
                  Text(
                    'No order history',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your past orders will appear here',
                    style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
