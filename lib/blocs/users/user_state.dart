import 'package:equatable/equatable.dart';
import 'package:github_user/models/user.dart';

abstract class UserState extends Equatable {
  @override
  List<Object> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final List<User> users;

  UserLoaded({required this.users});

  @override
  List<Object> get props => [users];
}

class UserError extends UserState {
  final String message;

  UserError({required this.message});

  @override
  List<Object> get props => [message];
}

class UserLoadingMore extends UserState {
  final List<User> users;

  UserLoadingMore({required this.users});

  @override
  List<Object> get props => [users];
}

class UserDetailLoaded extends UserState {
  final User user;

  UserDetailLoaded({required this.user});

  @override
  List<Object> get props => [user];
}
