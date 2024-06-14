import 'package:equatable/equatable.dart';

abstract class UserEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchUsers extends UserEvent {
  final int since;

  FetchUsers({this.since = 0});

  @override
  List<Object> get props => [since];
}

class FetchUserDetail extends UserEvent {
  final String username;

  FetchUserDetail({required this.username});
}