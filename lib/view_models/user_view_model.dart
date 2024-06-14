import 'package:github_user/blocs/users/user_bloc.dart';
import 'package:github_user/blocs/users/user_event.dart';
import 'package:github_user/repositories/user_repository.dart';
import 'package:github_user/services/api_service.dart';

class UserViewModel {
  final UserBloc userBloc;
  int since = 0;
  final int perPage = 20;

  UserViewModel()
      : userBloc = UserBloc(userRepository: UserRepository(apiService: ApiService()));

  void fetchNextPage() {
    userBloc.add(FetchUsers(since: since));
    since += perPage;
  }
}