import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/home_providers.dart';
import '../state/home_state.dart';

final homeViewModelProvider = NotifierProvider<HomeViewModel, HomeState>(
  HomeViewModel.new,
);

class HomeViewModel extends Notifier<HomeState> {
  @override
  HomeState build() {
    return const HomeState();
  }

  Future<void> loadHomeData() async {
    state = state.copyWith(status: HomeStatus.loading, errorMessage: null);

    final getRestaurantsUseCase = ref.read(getRestaurantsUseCaseProvider);
    final getPopularFoodsUseCase = ref.read(getPopularFoodsUseCaseProvider);

    // Load both restaurants and popular foods
    final restaurantsResult = await getRestaurantsUseCase();
    final popularFoodsResult = await getPopularFoodsUseCase();

    // Handle results
    restaurantsResult.fold(
      (failure) => state = state.copyWith(
        status: HomeStatus.error,
        errorMessage: failure.message,
      ),
      (restaurants) {
        popularFoodsResult.fold(
          (failure) => state = state.copyWith(
            status: HomeStatus.error,
            errorMessage: failure.message,
          ),
          (popularFoods) => state = state.copyWith(
            status: HomeStatus.loaded,
            restaurants: restaurants,
            popularFoods: popularFoods,
            errorMessage: null,
          ),
        );
      },
    );
  }

  void resetState() {
    state = const HomeState(status: HomeStatus.initial);
  }
}
