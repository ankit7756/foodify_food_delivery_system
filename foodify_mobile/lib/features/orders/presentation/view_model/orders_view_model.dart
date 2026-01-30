import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/storage/user_session_service.dart';
import '../providers/orders_providers.dart';
import '../state/orders_state.dart';

final ordersViewModelProvider = NotifierProvider<OrdersViewModel, OrdersState>(
  OrdersViewModel.new,
);

class OrdersViewModel extends Notifier<OrdersState> {
  @override
  OrdersState build() {
    return const OrdersState();
  }

  // Load current orders
  Future<void> loadCurrentOrders() async {
    state = state.copyWith(status: OrdersStatus.loading, errorMessage: null);

    final token = UserSessionService.getToken();
    if (token == null) {
      state = state.copyWith(
        status: OrdersStatus.error,
        errorMessage: 'No token found',
      );
      return;
    }

    final getCurrentOrdersUseCase = ref.read(getCurrentOrdersUseCaseProvider);
    final result = await getCurrentOrdersUseCase(token);

    result.fold(
      (failure) => state = state.copyWith(
        status: OrdersStatus.error,
        errorMessage: failure.message,
      ),
      (orders) => state = state.copyWith(
        status: OrdersStatus.loaded,
        currentOrders: orders,
        errorMessage: null,
      ),
    );
  }

  // Load order history
  Future<void> loadOrderHistory() async {
    state = state.copyWith(status: OrdersStatus.loading, errorMessage: null);

    final token = UserSessionService.getToken();
    if (token == null) {
      state = state.copyWith(
        status: OrdersStatus.error,
        errorMessage: 'No token found',
      );
      return;
    }

    final getOrderHistoryUseCase = ref.read(getOrderHistoryUseCaseProvider);
    final result = await getOrderHistoryUseCase(token);

    result.fold(
      (failure) => state = state.copyWith(
        status: OrdersStatus.error,
        errorMessage: failure.message,
      ),
      (orders) => state = state.copyWith(
        status: OrdersStatus.loaded,
        orderHistory: orders,
        errorMessage: null,
      ),
    );
  }

  // Load all orders (current + history)
  Future<void> loadAllOrders() async {
    state = state.copyWith(status: OrdersStatus.loading, errorMessage: null);

    final token = UserSessionService.getToken();
    if (token == null) {
      state = state.copyWith(
        status: OrdersStatus.error,
        errorMessage: 'No token found',
      );
      return;
    }

    final getCurrentOrdersUseCase = ref.read(getCurrentOrdersUseCaseProvider);
    final getOrderHistoryUseCase = ref.read(getOrderHistoryUseCaseProvider);

    final currentResult = await getCurrentOrdersUseCase(token);
    final historyResult = await getOrderHistoryUseCase(token);

    currentResult.fold(
      (failure) => state = state.copyWith(
        status: OrdersStatus.error,
        errorMessage: failure.message,
      ),
      (currentOrders) {
        historyResult.fold(
          (failure) => state = state.copyWith(
            status: OrdersStatus.error,
            errorMessage: failure.message,
          ),
          (orderHistory) => state = state.copyWith(
            status: OrdersStatus.loaded,
            currentOrders: currentOrders,
            orderHistory: orderHistory,
            errorMessage: null,
          ),
        );
      },
    );
  }

  // Create order
  Future<bool> createOrder(Map<String, dynamic> orderData) async {
    state = state.copyWith(status: OrdersStatus.creating, errorMessage: null);

    final token = UserSessionService.getToken();
    if (token == null) {
      state = state.copyWith(
        status: OrdersStatus.error,
        errorMessage: 'No token found',
      );
      return false;
    }

    final createOrderUseCase = ref.read(createOrderUseCaseProvider);
    final result = await createOrderUseCase(token: token, orderData: orderData);

    return result.fold(
      (failure) {
        state = state.copyWith(
          status: OrdersStatus.error,
          errorMessage: failure.message,
        );
        return false;
      },
      (order) {
        state = state.copyWith(
          status: OrdersStatus.created,
          errorMessage: null,
        );
        // Reload orders
        loadAllOrders();
        return true;
      },
    );
  }

  void resetState() {
    state = const OrdersState(status: OrdersStatus.initial);
  }
}
