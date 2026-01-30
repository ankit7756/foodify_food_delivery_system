import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/cart_item_entity.dart';
import '../state/cart_state.dart';

final cartViewModelProvider = NotifierProvider<CartViewModel, CartState>(
  CartViewModel.new,
);

class CartViewModel extends Notifier<CartState> {
  @override
  CartState build() {
    return const CartState();
  }

  // Add item to cart
  void addItem(CartItemEntity item) {
    final currentItems = List<CartItemEntity>.from(state.items);

    // Check if item already exists
    final existingIndex = currentItems.indexWhere(
      (cartItem) => cartItem.foodId == item.foodId,
    );

    if (existingIndex != -1) {
      // Item exists, increase quantity
      currentItems[existingIndex] = currentItems[existingIndex].copyWith(
        quantity: currentItems[existingIndex].quantity + item.quantity,
      );
    } else {
      // Check if adding from different restaurant
      if (currentItems.isNotEmpty &&
          currentItems.first.restaurantId != item.restaurantId) {
        // Different restaurant - will handle in UI
        return;
      }
      // New item, add to cart
      currentItems.add(item);
    }

    state = state.copyWith(items: currentItems);
  }

  // Remove item from cart
  void removeItem(String foodId) {
    final currentItems = List<CartItemEntity>.from(state.items);
    currentItems.removeWhere((item) => item.foodId == foodId);
    state = state.copyWith(items: currentItems);
  }

  // Increase item quantity
  void increaseQuantity(String foodId) {
    final currentItems = List<CartItemEntity>.from(state.items);
    final index = currentItems.indexWhere((item) => item.foodId == foodId);

    if (index != -1) {
      currentItems[index] = currentItems[index].copyWith(
        quantity: currentItems[index].quantity + 1,
      );
      state = state.copyWith(items: currentItems);
    }
  }

  // Decrease item quantity
  void decreaseQuantity(String foodId) {
    final currentItems = List<CartItemEntity>.from(state.items);
    final index = currentItems.indexWhere((item) => item.foodId == foodId);

    if (index != -1) {
      if (currentItems[index].quantity > 1) {
        currentItems[index] = currentItems[index].copyWith(
          quantity: currentItems[index].quantity - 1,
        );
        state = state.copyWith(items: currentItems);
      } else {
        // If quantity is 1, remove item
        removeItem(foodId);
      }
    }
  }

  // Clear entire cart
  void clearCart() {
    state = const CartState();
  }

  // Check if item is in cart
  bool isInCart(String foodId) {
    return state.items.any((item) => item.foodId == foodId);
  }

  // Get item quantity
  int getItemQuantity(String foodId) {
    final item = state.items.firstWhere(
      (item) => item.foodId == foodId,
      orElse: () => CartItemEntity(
        foodId: '',
        name: '',
        image: '',
        price: 0,
        quantity: 0,
        restaurantId: '',
        restaurantName: '',
      ),
    );
    return item.quantity;
  }

  // Replace cart with items from different restaurant
  void replaceCart(CartItemEntity newItem) {
    state = CartState(items: [newItem]);
  }
}
