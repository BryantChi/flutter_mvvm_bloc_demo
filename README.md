# GitHub Users Flutter App

這是一個使用Flutter構建的應用程序，展示了如何實現使用MVVM、Bloc模式以及API封裝來加載和顯示GitHub用戶列表，以及用戶詳細信息。

## 目錄
- [安裝要求](#安裝要求)
- [安裝指南](#安裝指南)
- [項目結構](#項目結構)
- [功能特性](#功能特性)
- [使用說明](#使用說明)
- [代碼說明](#代碼說明)

## 安裝要求
- Flutter 2.0或更高版本
- Dart 2.12或更高版本

## 安裝指南

1. **克隆項目**
   ```bash
   git clone https://github.com/yourusername/github_users_flutter.git
   cd github_users_flutter
2. **安裝依賴**
   ```bash
   flutter pub get
3. **運行項目**
   ```bash
   flutter run

## 項目結構

```css
lib/
├── blocs/
│   ├── user_bloc.dart
│   ├── user_event.dart
│   └── user_state.dart
├── models/
│   └── user.dart
├── repositories/
│   └── user_repository.dart
├── screens/
│   ├── user_detail_screen.dart
│   └── user_list_screen.dart
├── services/
│   └── api_service.dart
├── view_models/
│   └── user_view_model.dart
└── main.dart
```

## 功能特性

- 用戶列表: 加載並顯示GitHub用戶列表。
- 滾動加載更多: 在滾動到底部時自動加載更多用戶。
- 用戶詳細頁面: 點擊用戶列表中的用戶以查看詳細信息。
- 加載指示器: 在加載數據時顯示加載指示器。

# 使用說明
## UserBloc
lib/blocs/user_bloc.dart
```dart
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
          since = users.length;
          emit(UserLoaded(users: users));
        } else {
          emit(UserLoaded(users: []));
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
```

## UserDetailScreen
lib/screens/user_detail_screen.dart
```dart
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
          },
        ),
      ),
    );
  }
}
```

## UserListScreen
lib/screens/user_list_screen.dart
```dart
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
            }
          },
        ),
      ),
    );

  }

}
```

## main.dart
lib/main.dart
```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_user/blocs/users/user_bloc.dart';
import 'package:github_user/repositories/user_repository.dart';
import 'package:github_user/screens/user_list_screen.dart';
import 'package:github_user/services/api_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GitHub Users',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: UserListScreen(),
    );
  }
}
```

## 其他文件

- models/user.dart: 定義User模型。
- repositories/user_repository.dart: 定義UserRepository來處理API請求。
- services/api_service.dart: 定義APIService來實際執行HTTP請求。
- view_models/user_view_model.dart: 定義UserViewModel來與Bloc互動。

這樣，我們就完成了一個簡單的Flutter應用程序，展示了如何使用MVVM、Bloc模式以及API封裝來加載和顯示GitHub用戶列表及詳細信息。
