import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/storage/user_session_service.dart';
import '../providers/profile_providers.dart';
import '../state/profile_state.dart';

final profileViewModelProvider =
    NotifierProvider<ProfileViewModel, ProfileState>(ProfileViewModel.new);

class ProfileViewModel extends Notifier<ProfileState> {
  @override
  ProfileState build() {
    return const ProfileState();
  }

  Future<void> loadProfile() async {
    state = state.copyWith(status: ProfileStatus.loading, errorMessage: null);

    final token = UserSessionService.getToken();
    if (token == null) {
      state = state.copyWith(
        status: ProfileStatus.error,
        errorMessage: 'No token found',
      );
      return;
    }

    final getProfileUseCase = ref.read(getProfileUseCaseProvider);
    final result = await getProfileUseCase(token);

    result.fold(
      (failure) => state = state.copyWith(
        status: ProfileStatus.error,
        errorMessage: failure.message,
      ),
      (profile) => state = state.copyWith(
        status: ProfileStatus.loaded,
        profile: profile,
        errorMessage: null,
      ),
    );
  }

  // Future<void> updateProfile({
  //   required String fullName,
  //   required String username,
  //   required String phone,
  //   File? profileImage,
  // }) async {
  //   state = state.copyWith(status: ProfileStatus.updating, errorMessage: null);

  //   final token = UserSessionService.getToken();
  //   if (token == null) {
  //     state = state.copyWith(
  //       status: ProfileStatus.error,
  //       errorMessage: 'No token found',
  //     );
  //     return;
  //   }

  //   final updateProfileUseCase = ref.read(updateProfileUseCaseProvider);
  //   final result = await updateProfileUseCase(
  //     token: token,
  //     fullName: fullName,
  //     username: username,
  //     phone: phone,
  //     profileImage: profileImage,
  //   );

  //   result.fold(
  //     (failure) => state = state.copyWith(
  //       status: ProfileStatus.error,
  //       errorMessage: failure.message,
  //     ),
  //     (profile) => state = state.copyWith(
  //       status: ProfileStatus.updated,
  //       profile: profile,
  //       errorMessage: null,
  //     ),
  //   );
  // }
  Future<void> updateProfile({
    required String fullName,
    required String username,
    required String phone,
    File? profileImage,
  }) async {
    state = state.copyWith(status: ProfileStatus.updating, errorMessage: null);

    final token = UserSessionService.getToken();
    if (token == null) {
      state = state.copyWith(
        status: ProfileStatus.error,
        errorMessage: 'No token found',
      );
      return;
    }

    final updateProfileUseCase = ref.read(updateProfileUseCaseProvider);
    final result = await updateProfileUseCase(
      token: token,
      fullName: fullName,
      username: username,
      phone: phone,
      profileImage: profileImage,
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: ProfileStatus.error,
        errorMessage: failure.message,
      ),
      (profile) {
        // ✅ FIXED: Update state with new profile data
        state = state.copyWith(
          status: ProfileStatus.updated,
          profile: profile, // This updates the UI with fresh data
          errorMessage: null,
        );
      },
    );
  }

  void resetState() {
    state = const ProfileState(status: ProfileStatus.initial);
  }
}
