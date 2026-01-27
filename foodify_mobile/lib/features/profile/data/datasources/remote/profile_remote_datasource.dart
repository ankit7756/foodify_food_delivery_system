import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../../../core/config/api_config.dart';
import '../../../../../core/api/api_endpoints.dart';
import '../../models/user_profile_model.dart';

class ProfileRemoteDataSource {
  // Get profile
  Future<UserProfileModel> getProfile(String token) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}${ApiEndpoints.getProfile}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return UserProfileModel.fromJson(data['data']);
      } else {
        throw Exception('Failed to get profile: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to get profile: $e');
    }
  }

  // Update profile with image
  // Future<UserProfileModel> updateProfile({
  //   required String token,
  //   required String fullName,
  //   required String username,
  //   required String phone,
  //   File? profileImage,
  // }) async {
  //   try {
  //     var request = http.MultipartRequest(
  //       'PUT',
  //       Uri.parse('${ApiConfig.baseUrl}${ApiEndpoints.updateProfile}'),
  //     );

  //     // Add headers
  //     request.headers['Authorization'] = 'Bearer $token';

  //     // Add text fields
  //     request.fields['fullName'] = fullName;
  //     request.fields['username'] = username;
  //     request.fields['phone'] = phone;

  //     // Add image if provided
  //     if (profileImage != null) {
  //       request.files.add(
  //         await http.MultipartFile.fromPath('profileImage', profileImage.path),
  //       );
  //     }

  //     final streamedResponse = await request.send();
  //     final response = await http.Response.fromStream(streamedResponse);

  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body);
  //       return UserProfileModel.fromJson(data['data']);
  //     } else {
  //       throw Exception('Failed to update profile: ${response.body}');
  //     }
  //   } catch (e) {
  //     throw Exception('Failed to update profile: $e');
  //   }
  // }
  // Update profile with image
  Future<UserProfileModel> updateProfile({
    required String token,
    required String fullName,
    required String username,
    required String phone,
    File? profileImage,
  }) async {
    try {
      var request = http.MultipartRequest(
        'PUT',
        Uri.parse('${ApiConfig.baseUrl}${ApiEndpoints.updateProfile}'),
      );

      // Add headers
      request.headers['Authorization'] = 'Bearer $token';

      // Add text fields
      request.fields['fullName'] = fullName;
      request.fields['username'] = username;
      request.fields['phone'] = phone;

      // Add image if provided
      if (profileImage != null) {
        print('📸 Adding image: ${profileImage.path}'); // ✅ DEBUG

        var multipartFile = await http.MultipartFile.fromPath(
          'profileImage',
          profileImage.path,
        );

        print('📸 Image MIME type: ${multipartFile.contentType}'); // ✅ DEBUG
        request.files.add(multipartFile);
      }

      print('🚀 Sending request to: ${request.url}'); // ✅ DEBUG

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print('📥 Response status: ${response.statusCode}'); // ✅ DEBUG
      print('📥 Response body: ${response.body}'); // ✅ DEBUG

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return UserProfileModel.fromJson(data['data']);
      } else {
        throw Exception('Failed to update profile: ${response.body}');
      }
    } catch (e) {
      print('❌ Error updating profile: $e'); // ✅ DEBUG
      throw Exception('Failed to update profile: $e');
    }
  }
}
