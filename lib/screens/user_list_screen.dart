import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_user/blocs/users/user_bloc.dart';
import 'package:github_user/blocs/users/user_state.dart';
import 'package:github_user/screens/user_detail_screen.dart';
import 'package:github_user/view_models/user_view_model.dart';


class UserListScreen extends StatelessWidget {
  final UserViewModel userViewModel = UserViewModel();

  UserListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    userViewModel.fetchUsers();
    return BlocProvider(
      create: (_) => userViewModel.userBloc,
      child: Scaffold(
        appBar: AppBar(title: const Text('GitHub Users')),
        body: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            if (state is UserLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is UserError) {
              return Center(child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      userViewModel.fetchUsers();
                    },
                    child: Icon(Icons.refresh),
                  ),
                  SizedBox(height: 16,),
                  Text(state.message)
                ],
              ));
            } else if (state is UserLoaded || state is UserLoadingMore) {
              final users = state is UserLoaded ? state.users : (state as UserLoadingMore).users;
              return NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  if (scrollInfo is ScrollEndNotification &&
                      scrollInfo.metrics.extentAfter == 0) {
                    userViewModel.fetchMoreUsers();
                  }
                  return false;
                },
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: ListView.builder(
                        itemCount: users.length,
                        itemBuilder: (context, index) {

                          final user = users[index];
                          return ListTile(
                            contentPadding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 20.0),
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(24),
                              child: SizedBox.fromSize(
                                size: const Size.fromRadius(24),
                                child: Image.network(
                                  user.avatarUrl,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            title: Text(user.login),
                            trailing: user.siteAdmin ? Icon(Icons.verified) : null,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UserDetailScreen(username: user.login),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                    if (context.watch<UserBloc>().state is UserLoadingMore)
                      const Padding(
                        padding: EdgeInsets.all(15.0),
                        child: CircularProgressIndicator(),
                      ),
                  ],
                ),

              );

            } else {
              return Container();
              // return Center(child: InkWell(
              //   onTap: () {
              //     context.read<UserBloc>().add(FetchUsers());
              //   },
              //   child: const Column(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       Icon(Icons.refresh),
              //       Text('reTry')
              //     ],
              //   ),
              // ));
            }
          },
        ),
      ),
    );

  }

}