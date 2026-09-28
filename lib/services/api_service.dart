import 'package:dio/dio.dart';
import '../core/constants/api_constants.dart';
import '../models/user_model.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {'x-api-key': ApiConstants.apiKey},
    ),
  );

  Future<UserListResponse> fetchUsers({required int page}) async {
    try {
      final response = await _dio.get(
        ApiConstants.usersEndpoint,
        queryParameters: {'page': page, 'per_page': ApiConstants.perPage},
      );
      return UserListResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.message ?? 'Something went wrong');
    }
  }
}