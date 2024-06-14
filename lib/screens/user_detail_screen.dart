import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_user/blocs/users/user_bloc.dart';
import 'package:github_user/blocs/users/user_event.dart';
import 'package:github_user/blocs/users/user_state.dart';
import '../view_models/user_view_model.dart';

class UserDetailScreen extends StatelessWidget {
  final UserViewModel userViewModel = UserViewModel();
  final String username;

  UserDetailScreen({super.key, required this.username});


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => userViewModel.userBloc..add(FetchUserDetail(username: username)),
      child: Scaffold(
        appBar: AppBar(
          title: Text(username),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            if (state is UserLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is UserError) {
              return Center(child: Text(state.message));
            } else if (state is UserDetailLoaded) {
              final user = state.user;
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Image.network(user.avatarUrl, height: 100, width: 100),
                    SizedBox(height: 16),
                    Text(user.login, style: TextStyle(fontSize: 24)),
                    SizedBox(height: 8),
                    Text(user.bio ?? 'No bio available'),
                    // ... display other user details as needed ...
                  ],
                ),
              );
            } else {
              return Container();
            }
            // return Container();
          },
        ),
      ),
    );
  }
}