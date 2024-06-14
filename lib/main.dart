import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_user/blocs/users/user_bloc.dart';
import 'package:github_user/repositories/user_repository.dart';
import 'package:github_user/screens/user_list_screen.dart';
import 'package:github_user/services/api_service.dart';

void main() {
  final userRepository = UserRepository(apiService: ApiService());
  runApp(MyApp(userRepository: userRepository));
  // runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final UserRepository userRepository;
  const MyApp({super.key, required this.userRepository});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: userRepository,
      child: BlocProvider(
        create: (context) => UserBloc(userRepository: userRepository),
        child: MaterialApp(
          title: 'GitHub Users',
          theme: ThemeData(
            // primarySwatch: Colors.blue,
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: UserListScreen(),
        ),
      ),
    );
    // return MaterialApp(
    //   title: 'GitHub Users',
    //   theme: ThemeData(
    //     primarySwatch: Colors.blue,
    //   ),
    //   home: const UserListScreen(),
    // );
  }
}
