import 'package:equatable/equatable.dart';
import 'package:github_user/models/user.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {
  final List<User> users;
  final bool isFirstFetch;

  const UserLoading({required this.users, required this.isFirstFetch});

  @override
  List<Object?> get props => [users, isFirstFetch];
}

class UserLoaded extends UserState {
  final List<User> users;
  final bool hasReachedMax;

  const UserLoaded({required this.users, this.hasReachedMax = false});

  UserLoaded copyWith({
    List<User>? users,
    bool? hasReachedMax,
  }) {
    return UserLoaded(
      users: users ?? this.users,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object?> get props => [users, hasReachedMax];
}

class UserError extends UserState {
  final String message;

  const UserError({required this.message});

  @override
  List<Object?> get props => [message];
}

class UserDetailLoaded extends UserState {
  final User user;

  const UserDetailLoaded({required this.user});

  @override
  List<Object?> get props => [user];
}