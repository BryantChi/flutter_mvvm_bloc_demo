import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_user/blocs/users/user_event.dart';
import 'package:github_user/blocs/users/user_state.dart';
import 'package:github_user/models/user.dart';

import '../../repositories/user_repository.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;

  UserBloc({required this.userRepository}) : super(UserInitial()) {
    on<FetchUsers>(_onFetchUsers);
    on<FetchUserDetail>(_onFetchUserDetail);
  }

  void _onFetchUsers(FetchUsers event, Emitter<UserState> emit) async {
    if (state is UserLoading) return;

    final currentState = state;
    var oldUsers = <User>[];
    if (currentState is UserLoaded) {
      oldUsers = currentState.users;
    }

    emit(UserLoading(users: oldUsers, isFirstFetch: oldUsers.isEmpty));
    try {
      final newUsers = await userRepository.getUsers(since: event.since);
      final users = oldUsers + newUsers;
      emit(UserLoaded(users: users, hasReachedMax: newUsers.isEmpty));
    } catch (e) {
      emit(UserError(message: e.toString()));
    }
  }

  void _onFetchUserDetail(FetchUserDetail event, Emitter<UserState> emit) async {
    emit(UserLoading(users: [], isFirstFetch: false));
    try {
      final user = await userRepository.getUserDetail(event.username);
      emit(UserDetailLoaded(user: user));
    } catch (e) {
      emit(UserError(message: e.toString()));
    }
  }
}