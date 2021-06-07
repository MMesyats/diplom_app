import 'package:diplom_app/pages/AuthPage.dart';
import 'package:diplom_app/pages/HomePage.dart';
import 'package:diplom_app/services/Backend.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

final routes = {
  '/auth': (context) => AuthPage(),
  '/home': (context) => HomePage()
};

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseAuth.instance.signOut();
  final user = FirebaseAuth.instance.currentUser;
  final userInfo = await Backend.getUserInfo();
  if (user != null && userInfo != null) {
    runApp(App(
      initialRoute: '/home',
    ));
  } else {
    runApp(App(
      initialRoute: '/auth',
    ));
  }
}

class App extends StatelessWidget {
  App({this.initialRoute});

  final String initialRoute;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      color: const Color(0xFFe7edf3),
      theme: ThemeData(
          buttonColor: Colors.blue[200],
          textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                  primary: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: Colors.blue[500],
                  minimumSize: Size(double.infinity, 0))),
          textTheme: TextTheme(button: TextStyle(fontSize: 16))),
      initialRoute: initialRoute,
      routes: routes,
    );
  }
}
