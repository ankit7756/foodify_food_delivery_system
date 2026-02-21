import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/hive/hive_service.dart';
import '../../data/models/cart_item_hive_model.dart';
import '../../domain/entities/cart_item_entity.dart';
import '../state/cart_state.dart';

final cartViewModelProvider = NotifierProvider<CartViewModel, CartState>(
  CartViewModel.new,
);

class CartViewModel extends Notifier<CartState> {
  @override
  CartState build() {
    try {
      final cached = HiveService.getCachedCartItems();
      if (cached.isNotEmpty) {
        final items = CartItemHiveModel.toEntityList(cached);
        return CartState(items: items);
      }
    } catch (_) {}
    return const CartState();
  }

  Future<void> _saveCartToHive() async {
    try {
      final models = state.items
          .map((item) => CartItemHiveModel.fromEntity(item))
          .toList();
      await HiveService.saveCartItems(models);
    } catch (_) {}
  }

  void addItem(CartItemEntity item) {
    final currentItems = List<CartItemEntity>.from(state.items);
    final existingIndex = currentItems.indexWhere(
      (cartItem) => cartItem.foodId == item.foodId,
    );

    if (existingIndex != -1) {
      currentItems[existingIndex] = currentItems[existingIndex].copyWith(
        quantity: currentItems[existingIndex].quantity + item.quantity,
      );
    } else {
      if (currentItems.isNotEmpty &&
          currentItems.first.restaurantId != item.restaurantId) {
        return;
      }
      currentItems.add(item);
    }

    state = state.copyWith(items: currentItems);
    _saveCartToHive();
  }

  void removeItem(String foodId) {
    final currentItems = List<CartItemEntity>.from(state.items);
    currentItems.removeWhere((item) => item.foodId == foodId);
    state = state.copyWith(items: currentItems);
    _saveCartToHive();
  }

  void increaseQuantity(String foodId) {
    final currentItems = List<CartItemEntity>.from(state.items);
    final index = currentItems.indexWhere((item) => item.foodId == foodId);
    if (index != -1) {
      currentItems[index] = currentItems[index].copyWith(
        quantity: currentItems[index].quantity + 1,
      );
      state = state.copyWith(items: currentItems);
      _saveCartToHive();
    }
  }

  void decreaseQuantity(String foodId) {
    final currentItems = List<CartItemEntity>.from(state.items);
    final index = currentItems.indexWhere((item) => item.foodId == foodId);
    if (index != -1) {
      if (currentItems[index].quantity > 1) {
        currentItems[index] = currentItems[index].copyWith(
          quantity: currentItems[index].quantity - 1,
        );
        state = state.copyWith(items: currentItems);
        _saveCartToHive();
      } else {
        removeItem(foodId);
      }
    }
  }

  void clearCart() {
    state = const CartState();
    HiveService.clearCart();
  }

  bool isInCart(String foodId) =>
      state.items.any((item) => item.foodId == foodId);

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

  void replaceCart(CartItemEntity newItem) {
    state = CartState(items: [newItem]);
    _saveCartToHive();
  }
}
