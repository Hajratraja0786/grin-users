import '../models/user_model.dart';
import '../services/api_service.dart';

class UserRepository {
  final ApiService _api;
  UserRepository(this._api);

  Future<UserListResponse> getUsers({required int page}) =>
      _api.fetchUsers(page: page);
}