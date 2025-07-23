import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_user/blocs/users/user_event.dart';
import 'package:github_user/blocs/users/user_state.dart';
import '../../repositories/user_repository.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;
  int since = 0;
  final int perPage = 20;
  bool isLoadingMore = false;
  bool hasMoreData = true;

  UserBloc({required this.userRepository}) : super(UserInitial()) {

    on<FetchUsers>((event, emit) async {
      emit(UserLoading());
      try {
        final users = await userRepository.getUsers(since: since, perPage: perPage);
        if (users.length < perPage) {
          hasMoreData = false;  // 最後一次加載不足20筆
        }
        if (users.isNotEmpty) {
          since += users.length;
          emit(UserLoaded(users: users));
        } else {
          emit(UserLoaded(users: const []));
        }
      } catch (e) {
        emit(UserError(message: e.toString()));
      }
    });

    on<FetchMoreUsers>((event, emit) async {
      if (isLoadingMore || !hasMoreData) return;
      isLoadingMore = true;
      final currentState = state;
      if (currentState is UserLoaded) {
        emit(UserLoadingMore(users: currentState.users));
      }
      try {
        final users = await userRepository.getUsers(since: since, perPage: perPage);
        if (users.length < perPage) {
          hasMoreData = false;  // 最後一次加載不足20筆
        }
        if (users.isNotEmpty) {
          since += users.length;
          if (currentState is UserLoaded) {
            emit(UserLoaded(users: currentState.users + users));
          }
        }
      } catch (e) {
        emit(UserError(message: e.toString()));
      } finally {
        isLoadingMore = false;
      }
    });

    on<FetchUserDetail>((event, emit) async {
      emit(UserLoading());
      try {
        final user = await userRepository.getUserDetail(event.username);
        emit(UserDetailLoaded(user: user));
      } catch (e) {
        emit(UserError(message: e.toString()));
      }
    });
  }
}