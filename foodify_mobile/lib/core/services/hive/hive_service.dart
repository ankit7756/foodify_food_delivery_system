import 'package:hive_flutter/hive_flutter.dart';
import '../../constants/hive_table_constants.dart';
import '../../../features/auth/data/models/auth_hive_model.dart';
import '../../../features/home/data/models/restaurant_hive_model.dart';
import '../../../features/home/data/models/food_hive_model.dart';
import '../../../features/orders/data/models/order_hive_model.dart';
import '../../../features/profile/data/models/profile_hive_model.dart';
import '../../../features/cart/data/models/cart_item_hive_model.dart';

class HiveService {
  static Future<void> initHive() async {
    await Hive.initFlutter();
    _registerAdapters();
    await _openBoxes();
  }

  static void _registerAdapters() {
    if (!Hive.isAdapterRegistered(HiveTableConstants.userTypeId)) {
      Hive.registerAdapter(AuthHiveModelAdapter());
    }
    if (!Hive.isAdapterRegistered(HiveTableConstants.restaurantTypeId)) {
      Hive.registerAdapter(RestaurantHiveModelAdapter());
    }
    if (!Hive.isAdapterRegistered(HiveTableConstants.foodTypeId)) {
      Hive.registerAdapter(FoodHiveModelAdapter());
    }
    if (!Hive.isAdapterRegistered(HiveTableConstants.orderTypeId)) {
      Hive.registerAdapter(OrderHiveModelAdapter());
    }
    if (!Hive.isAdapterRegistered(HiveTableConstants.profileTypeId)) {
      Hive.registerAdapter(ProfileHiveModelAdapter());
    }
    if (!Hive.isAdapterRegistered(HiveTableConstants.cartTypeId)) {
      Hive.registerAdapter(CartItemHiveModelAdapter());
    }
  }

  static Future<void> _openBoxes() async {
    await Hive.openBox<AuthHiveModel>(HiveTableConstants.userTable);
    await Hive.openBox<RestaurantHiveModel>(HiveTableConstants.restaurantTable);
    await Hive.openBox<FoodHiveModel>(HiveTableConstants.foodTable);
    await Hive.openBox<OrderHiveModel>(HiveTableConstants.orderTable);
    await Hive.openBox<ProfileHiveModel>(HiveTableConstants.profileTable);
    await Hive.openBox<CartItemHiveModel>(HiveTableConstants.cartTable);
  }

  // ===== Auth =====
  static Box<AuthHiveModel> getUserBox() =>
      Hive.box<AuthHiveModel>(HiveTableConstants.userTable);

  // ===== Restaurants =====
  static Box<RestaurantHiveModel> getRestaurantBox() =>
      Hive.box<RestaurantHiveModel>(HiveTableConstants.restaurantTable);

  static Future<void> saveRestaurants(
    List<RestaurantHiveModel> restaurants,
  ) async {
    final box = getRestaurantBox();
    await box.clear();
    for (final r in restaurants) {
      await box.put(r.id, r);
    }
  }

  static List<RestaurantHiveModel> getCachedRestaurants() =>
      getRestaurantBox().values.toList();

  // ===== Foods =====
  static Box<FoodHiveModel> getFoodBox() =>
      Hive.box<FoodHiveModel>(HiveTableConstants.foodTable);

  static Future<void> saveFoods(List<FoodHiveModel> foods) async {
    final box = getFoodBox();
    await box.clear();
    for (final f in foods) {
      await box.put(f.id, f);
    }
  }

  static List<FoodHiveModel> getCachedFoods() => getFoodBox().values.toList();

  // ===== Orders =====
  static Box<OrderHiveModel> getOrderBox() =>
      Hive.box<OrderHiveModel>(HiveTableConstants.orderTable);

  static Future<void> saveOrders(List<OrderHiveModel> orders) async {
    final box = getOrderBox();
    await box.clear();
    for (final o in orders) {
      await box.put(o.id, o);
    }
  }

  static List<OrderHiveModel> getCachedOrders() =>
      getOrderBox().values.toList();

  // ===== Profile =====
  static Box<ProfileHiveModel> getProfileBox() =>
      Hive.box<ProfileHiveModel>(HiveTableConstants.profileTable);

  static Future<void> saveProfile(ProfileHiveModel profile) async {
    final box = getProfileBox();
    await box.clear();
    await box.put(profile.id, profile);
  }

  static ProfileHiveModel? getCachedProfile() =>
      getProfileBox().values.isNotEmpty ? getProfileBox().values.first : null;

  // ===== Cart =====
  static Box<CartItemHiveModel> getCartBox() =>
      Hive.box<CartItemHiveModel>(HiveTableConstants.cartTable);

  static Future<void> saveCartItems(List<CartItemHiveModel> items) async {
    final box = getCartBox();
    await box.clear();
    for (final item in items) {
      await box.put(item.foodId, item);
    }
  }

  static List<CartItemHiveModel> getCachedCartItems() =>
      getCartBox().values.toList();

  static Future<void> clearCart() async {
    await getCartBox().clear();
  }
}
