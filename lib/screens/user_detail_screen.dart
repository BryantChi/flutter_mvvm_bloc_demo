import 'dart:io';

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
    userViewModel.showUser(username);
    return BlocProvider(
      create: (_) => userViewModel.userBloc,
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
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
                      // Image.network(user.avatarUrl, height: 200, width: 200),
                      Container(
                        height: 200,
                        width: 200,
                        decoration: BoxDecoration(
                            borderRadius:
                            BorderRadius.circular(100),
                            image: DecorationImage(
                                image: NetworkImage(
                                    user.avatarUrl))),
                      ),
                      SizedBox(height: 16),
                      Text(user.name, style: TextStyle(fontSize: 24)),
                      SizedBox(height: 8),
                      Text(user.bio),
                      SizedBox(height: 24),
                      Divider(height: 1,),
                      SizedBox(height: 36),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(width: 24,),
                          Icon(Icons.person,size: 42,),
                          SizedBox(width: 48,),
                          Text(user.login, style: TextStyle(fontSize: 18),),
                          SizedBox(width: 24,),
                          Icon(user.siteAdmin ? Icons.verified : null)
                        ],
                      ),
                      SizedBox(height: 36),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(width: 24,),
                          Icon(Icons.location_on_outlined,size: 42,),
                          SizedBox(width: 48,),
                          Text(user.location, style: TextStyle(fontSize: 18),),
                        ],
                      ),
                      SizedBox(height: 36),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(width: 24,),
                          Icon(Icons.link,size: 42,),
                          SizedBox(width: 48,),
                          Expanded(
                            child: InkWell(
                              child: Text(
                                user.blog,
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            )
                          ),
                        ],
                      ),
                      // ... display other user details as needed ...
                    ],
                  ),
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