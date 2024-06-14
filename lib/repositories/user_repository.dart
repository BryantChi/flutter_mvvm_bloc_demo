import '../models/user.dart';
import '../services/api_service.dart';

class UserRepository {
  final ApiService apiService;

  UserRepository({required this.apiService});

  Future<List<User>> getUsers({int since = 0, int perPage = 20}) async {
    return await apiService.fetchUsers(since: since, perPage: perPage);
  }

  Future<User> getUserDetail(String username) async {
    return await apiService.fetchUserDetail(username);
  }
}