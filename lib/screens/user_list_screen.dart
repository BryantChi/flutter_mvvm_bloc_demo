import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_user/blocs/users/user_bloc.dart';
import 'package:github_user/blocs/users/user_event.dart';
import 'package:github_user/blocs/users/user_state.dart';
import 'package:github_user/screens/user_detail_screen.dart';
import 'package:github_user/view_models/user_view_model.dart';


class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final UserViewModel userViewModel = UserViewModel();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    context.read<UserBloc>().add(FetchUsers());
    // return BlocProvider(
    //     create: (_) => userViewModel.userBloc..add(FetchUsers()),
    //     child: ,
    // );
    return Scaffold(
      appBar: AppBar(title: Text('GitHub Users')),
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserInitial || (state is UserLoading && state.isFirstFetch)) {
            return Center(child: CircularProgressIndicator());
          } else if (state is UserError) {
            return Center(child: Text(state.message));
          } else if (state is UserLoaded) {
            return ListView.builder(
              controller: _scrollController,
              itemCount: state.hasReachedMax ? state.users.length : state.users.length + 1,
              itemBuilder: (context, index) {
                if (index >= state.users.length) {
                  return Center(child: CircularProgressIndicator());
                }
                final user = state.users[index];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 20.0),
                  leading: Image.network(user.avatarUrl),
                  title: Text(user.login),
                  trailing: user.siteAdmin ? Icon(Icons.verified) : null,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlocProvider.value(
                          value: context.read<UserBloc>(),
                          child: UserDetailScreen(username: user.login),
                        ),
                      ),
                    ).then((_) {
                      setState(() {});
                    });
                  },
                );
              },
            );
          } else if (state is UserLoading) {
            return ListView.builder(
              controller: _scrollController,
              itemCount: state.users.length + 1,
              itemBuilder: (context, index) {
                if (index >= state.users.length) {
                  return Center(child: CircularProgressIndicator());
                }
                final user = state.users[index];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 20.0),
                  leading: Image.network(user.avatarUrl),
                  title: Text(user.login),
                  trailing: user.siteAdmin ? Icon(Icons.verified) : null,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlocProvider.value(
                          value: context.read<UserBloc>(),
                          child: UserDetailScreen(username: user.login),
                        ),
                      ),
                    ).then((_) {
                      setState(() {});
                    });
                  },
                );
              },
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
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      final state = context.read<UserBloc>().state;
      if (state is UserLoaded && !state.hasReachedMax) {
        context.read<UserBloc>().add(FetchUsers(since: state.users.length));
      }
    }
  }

  bool get _isBottom {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.9) {
      return true;
    }
    return false;
  }
}