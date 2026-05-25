import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/home_screen.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<bool> isLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString('token');

    return token != null;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'Todo App',

      theme: ThemeData(useMaterial3: true),

      home: FutureBuilder(
        future: isLogin(),

        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (snapshot.data == true) {
            return const HomeScreen();
          }

          return const LoginScreen();
        },
      ),
    );
  }
}
