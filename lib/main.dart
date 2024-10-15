import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testlab/login_page.dart';
import 'package:testlab/my_home_page.dart';
import 'package:testlab/page/insertProduct.dart';
import 'package:testlab/pages/UserPage.dart';
import 'package:testlab/pages/adminPage.dart';
import 'package:testlab/providers/usar_providers.dart';
import 'package:testlab/register_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => UserProvider()), // กำหนด UserProvider
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: MaterialApp(
          title: 'Login Example',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          debugShowCheckedModeBanner: false,
          initialRoute: '/login',
          routes: {
            '/home': (context) => UserPage(),
            '/login': (context) => LoginPage(),
            '/register': (context) => RegisterPage(),
            '/register': (context) => RegisterPage(),
            '/admin': (context) => Adminpage(),
            '/insertProduct': (context) => insertProduct(),
          }),
    );
  }
}