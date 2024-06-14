import 'package:equatable/equatable.dart';

abstract class UserEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchUsers extends UserEvent {}

class FetchMoreUsers extends UserEvent {
}

class FetchUserDetail extends UserEvent {
  final String username;

  FetchUserDetail({required this.username});
}