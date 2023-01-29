// ignore_for_file: avoid_print, non_constant_identifier_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'chat_screen.dart';

class SignUp extends StatefulWidget {
  static const screenRoutes = 'sign_up';

  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _auth = FirebaseAuth.instance;
  late String email;
  late String password;
  bool showLoading = false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showLoading,
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                Colors.yellow.shade900,
                Colors.yellow.shade100,
                Colors.yellow.shade900,
              ]),
            ),
            height: double.infinity,
            alignment: Alignment.bottomLeft,
          ),
        ),
        body: Stack(children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            alignment: Alignment.center,

            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  logo(),
                  loginInfo(context),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Container loginInfo(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(horizontal: 30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(colors: [
          Colors.yellow.shade900,
          Colors.yellow.shade200,
          Colors.yellow.shade900,
        ]),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          email_Field(),
          SizedBox(height: MediaQuery.of(context).size.height / 50),
          password_Field(),
          SizedBox(height: MediaQuery.of(context).size.height / 20),
          button_Text(context),
        ],
      ),
    );
  }

  button_Text(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 1.5,
      child: TextButton(
        onPressed: () async {
          setState(() {
            showLoading = true;
          });
          try {

            Navigator.pushReplacementNamed(context, ChatScreen.screenRoutes);
            setState(() {
              showLoading = false;
            });
          } catch (e) {
            print(e);
          }
        },
        style: TextButton.styleFrom(
            elevation: 20,
            shadowColor: Colors.pink.shade900,
            shape: const StadiumBorder(),
            backgroundColor: Colors.yellow[900]),
        child:  Text(
          'Register',
          style: TextStyle(
            color: Colors.pink.shade900,
            fontFamily: 'AbrilFatface',
            fontSize: 20,
          ),
        ),
      ),
    );
  }

  TextFormField email_Field() {
    return TextFormField(
      onChanged: (value) => email = value,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.pink.shade900, width: 1),
          borderRadius: BorderRadius.circular(25),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.blue, width: 3),
          borderRadius: BorderRadius.circular(10),
        ),
        prefixIcon: Icon(
          Icons.email,
          color: Colors.pink.shade900,
        ),
        labelText: 'Email',
        labelStyle: TextStyle(
            fontFamily: 'AbrilFatface',
            fontSize: 20,
            color: Colors.pink.shade900),
        hintStyle: const TextStyle(
          fontFamily: 'AbrilFatface',
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),

    );
  }

  TextFormField password_Field() {
    return TextFormField(
      onChanged: (value) => password = value,

      keyboardType: TextInputType.visiblePassword,
      obscureText: true,
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.pink.shade900, width: 1),
          borderRadius: BorderRadius.circular(25),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.blue, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        prefixIcon: Icon(Icons.key, color: Colors.pink.shade900),
        labelText: 'Password',
        labelStyle: TextStyle(
            fontFamily: 'AbrilFatface',
            fontSize: 20,
            color: Colors.pink.shade900),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
      // focusNode: passwordFoucsNode,
      // validator: (value) => value != testPass ? "Worst Password" : null,
    );
  }

  Widget logo() {
    return Container(
      margin: const EdgeInsets.all(20),
      alignment: Alignment.center,
      width: 200,
      height: 200,
      child: Image.asset('assets/m_back.png'),
    );
  }
}
