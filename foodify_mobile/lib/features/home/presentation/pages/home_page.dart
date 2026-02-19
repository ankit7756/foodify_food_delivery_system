import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../view_model/home_view_model.dart';
import '../state/home_state.dart';
import '../widgets/restaurant_card.dart';
import '../widgets/food_card.dart';
import '../widgets/category_chip.dart';
import '../../../notifications/presentation/pages/notification_page.dart';
import '../../../notifications/presentation/view_model/notification_view_model.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();
    // Load home data when page opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(homeViewModelProvider.notifier).loadHomeData();
    });
  }

  Future<void> _refreshData() async {
    await ref.read(homeViewModelProvider.notifier).loadHomeData();
  }

  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(homeViewModelProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: homeState.status == HomeStatus.loading
            ? const Center(child: CircularProgressIndicator())
            : homeState.status == HomeStatus.error
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 60,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      homeState.errorMessage ?? 'Something went wrong',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _refreshData,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              )
            : RefreshIndicator(
                onRefresh: _refreshData,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Hi, Welcome! 👋',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'What would you like to eat today?',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            // REPLACE the notification bell Container with this:
                            Consumer(
                              builder: (context, ref, child) {
                                final unreadCount = ref
                                    .watch(notificationViewModelProvider)
                                    .unreadCount;
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            const NotificationPage(),
                                      ),
                                    );
                                  },
                                  child: Stack(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(
                                                0.05,
                                              ),
                                              blurRadius: 10,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: const Icon(
                                          Icons.notifications_outlined,
                                          color: Color(0xFFFF6B35),
                                        ),
                                      ),
                                      if (unreadCount > 0)
                                        Positioned(
                                          right: 6,
                                          top: 6,
                                          child: Container(
                                            width: 18,
                                            height: 18,
                                            decoration: const BoxDecoration(
                                              color: Colors.red,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Center(
                                              child: Text(
                                                unreadCount > 9
                                                    ? '9+'
                                                    : '$unreadCount',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Search Bar
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
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
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Search for food or restaurant...',
                              border: InputBorder.none,
                              icon: Icon(Icons.search, color: Colors.grey[400]),
                              hintStyle: TextStyle(color: Colors.grey[400]),
                            ),
                            onTap: () {
                              // TODO: Navigate to search page
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Search feature coming soon!'),
                                ),
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Categories
                        const Text(
                          'Categories',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 16),

                        SizedBox(
                          height: 50,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              CategoryChip(
                                emoji: '🍕',
                                label: 'Pizza',
                                onTap: () {},
                              ),
                              CategoryChip(
                                emoji: '🍔',
                                label: 'Burger',
                                onTap: () {},
                              ),
                              CategoryChip(
                                emoji: '🍜',
                                label: 'Noodles',
                                onTap: () {},
                              ),
                              CategoryChip(
                                emoji: '🍰',
                                label: 'Dessert',
                                onTap: () {},
                              ),
                              CategoryChip(
                                emoji: '☕',
                                label: 'Drinks',
                                onTap: () {},
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Popular Foods
                        if (homeState.popularFoods.isNotEmpty) ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Popular Foods',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              TextButton(
                                onPressed: () {},
                                child: const Text(
                                  'See All',
                                  style: TextStyle(
                                    color: Color(0xFFFF6B35),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          SizedBox(
                            height: 220,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: homeState.popularFoods.length,
                              itemBuilder: (context, index) {
                                return FoodCard(
                                  food: homeState.popularFoods[index],
                                );
                              },
                            ),
                          ),

                          const SizedBox(height: 24),
                        ],

                        // Popular Restaurants
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Popular Restaurants',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: const Text(
                                'See All',
                                style: TextStyle(
                                  color: Color(0xFFFF6B35),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Restaurant List
                        if (homeState.restaurants.isEmpty)
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.all(40),
                              child: Text('No restaurants available'),
                            ),
                          )
                        else
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: homeState.restaurants.length,
                            itemBuilder: (context, index) {
                              return RestaurantCard(
                                restaurant: homeState.restaurants[index],
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
