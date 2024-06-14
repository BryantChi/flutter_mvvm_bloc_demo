import 'package:github_user/blocs/users/user_bloc.dart';
import 'package:github_user/blocs/users/user_event.dart';
import 'package:github_user/repositories/user_repository.dart';
import 'package:github_user/services/api_service.dart';

class UserViewModel {
  final UserBloc userBloc;

  UserViewModel()
      : userBloc = UserBloc(userRepository: UserRepository(apiService: ApiService()));

  void fetchUsers() {
    userBloc.add(FetchUsers());
  }

  void fetchMoreUsers() {
    userBloc.add(FetchMoreUsers());
  }

  void showUser(String username) {
    userBloc.add(FetchUserDetail(username: username));
  }

}