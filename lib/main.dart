import 'package:chat/screens/chat_screen.dart';
import 'package:chat/screens/sign_in.dart';
import 'package:chat/screens/sign_up.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _auth = FirebaseAuth.instance;

  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: _auth.currentUser == null
          ? SignIn.screenRoutes
          : ChatScreen.screenRoutes,
      routes: {
        SignIn.screenRoutes: (context) => const SignIn(),
        SignUp.screenRoutes: (context) => const SignUp(),
        ChatScreen.screenRoutes: (context) => const ChatScreen(),
      },
    );
  }
}
