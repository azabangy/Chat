// ignore_for_file: use_build_context_synchronously, avoid_print, non_constant_identifier_names
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:chat/screens/chat_screen.dart';
import 'package:chat/screens/sign_up.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

import '../animation_enum.dart';

class SignIn extends StatefulWidget {
  static const screenRoutes = 'sign_in';

  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _auth = FirebaseAuth.instance;
  late String email;
  late String password;
  bool showLoading = false;
  @override
  void initState() {
    super.initState();
    controllerIdle = SimpleAnimation(AnimationEnum.idle.name);
    controllerHandsUp = SimpleAnimation(AnimationEnum.Hands_up.name);
    controllerHandsDown = SimpleAnimation(AnimationEnum.hands_down.name);
    controllerLookLeft = SimpleAnimation(AnimationEnum.Look_down_left.name);
    controllerLookRight = SimpleAnimation(AnimationEnum.Look_down_right.name);
    controllerSuccess = SimpleAnimation(AnimationEnum.success.name);
    controllerFail = SimpleAnimation(AnimationEnum.fail.name);

    rootBundle.load('assets/animated_login.riv').then((data) {
      final file = RiveFile.import(data);
      final artboard = file.mainArtboard;
      artboard.addController(controllerIdle);
      setState(() {
        riveArtboard = artboard;
      });
    });

    checkPasswordFocus();
    checkEmailFocus();
  }

  Artboard? riveArtboard;

  late RiveAnimationController controllerIdle;
  late RiveAnimationController controllerHandsUp;
  late RiveAnimationController controllerHandsDown;
  late RiveAnimationController controllerLookLeft;
  late RiveAnimationController controllerLookRight;
  late RiveAnimationController controllerSuccess;
  late RiveAnimationController controllerFail;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String testEmail = 'mahmoud@gmail.com';
  String testPass = '123456';
  final passwordFoucsNode = FocusNode();
  final emailFocusNode = FocusNode();
  bool isLookLeft = false;
  bool isLookRight = false;

  void removeAllController() {
    riveArtboard?.artboard.removeController(controllerIdle);
    riveArtboard?.artboard.removeController(controllerHandsUp);
    riveArtboard?.artboard.removeController(controllerHandsDown);
    riveArtboard?.artboard.removeController(controllerLookLeft);
    riveArtboard?.artboard.removeController(controllerLookRight);
    riveArtboard?.artboard.removeController(controllerSuccess);
    riveArtboard?.artboard.removeController(controllerFail);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: showLoading,
        child: Stack(
          alignment: Alignment.center,
          children: [
            back_Image(),
            SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                      margin: const EdgeInsets.only(top: 50),
                      alignment: Alignment.center,
                      height: MediaQuery.of(context).size.height / 2.5,
                      child: animation_Bear(context)),
                  Form(
                    key: formKey,
                    child: loginInfo(context),
                  ),
                  logo(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void addControllerIdle() {
    removeAllController();
    riveArtboard?.artboard.addController(controllerIdle);
  }

  void addControllerHandsUp() {
    removeAllController();
    riveArtboard?.artboard.addController(controllerHandsUp);
  }

  void addControllerHandsDown() {
    removeAllController();
    riveArtboard?.artboard.addController(controllerHandsDown);
  }

  void addControllerLookRight() {
    removeAllController();
    riveArtboard?.artboard.addController(controllerLookRight);
  }

  void addControllerLookLeft() {
    removeAllController();
    riveArtboard?.artboard.addController(controllerLookLeft);
  }

  void addControllerSuccess() {
    removeAllController();
    riveArtboard?.artboard.addController(controllerSuccess);
  }

  void addControllerFail() {
    removeAllController();
    riveArtboard?.artboard.addController(controllerFail);
  }

  void checkPasswordFocus() {
    passwordFoucsNode.addListener(() {
      if (passwordFoucsNode.hasFocus) {
        addControllerHandsUp();
      } else {
        addControllerHandsDown();
      }
    });
  }

  void checkEmailFocus() {
    emailFocusNode.addListener(() {
      if (emailFocusNode.hasFocus) {
      } else {
        addControllerIdle();
      }
    });
  }
  bool isValid = false;

  void validateEmailAndPassword() {
    Future.delayed(const Duration(seconds: 1), () {
      if (formKey.currentState!.validate()) {
        isValid = !isValid;
        addControllerSuccess();
      } else {
        isValid = false;
        addControllerFail();
      }
    });
  }

  loginInfo(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(horizontal: 30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.black.withOpacity(.4),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          email_Field(),
          SizedBox(height: MediaQuery.of(context).size.height / 80),
          password_Field(),
          SizedBox(height: MediaQuery.of(context).size.height / 80),
          button_Text(context),
          button_Register(context),
        ],
      ),
    );
  }

  button_Text(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 1.5,
      child: TextButton(
        onPressed: () async {
          passwordFoucsNode.unfocus();
          emailFocusNode.unfocus();
          setState(() {
            showLoading = true;
          });
          try {
            final user = await _auth.signInWithEmailAndPassword(
                email: email, password: password);
            if (user !=null) {
              Navigator.pushReplacementNamed(context, ChatScreen.screenRoutes);
              setState(() {
                showLoading = false;
              });
            }
          } catch (e) {
            print(e);
          }
        },
        style: TextButton.styleFrom(
            elevation: 5,
            shape: const StadiumBorder(),
            backgroundColor: Colors.yellow[900]),
        child: const Text(
          'Login',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'AbrilFatface',
            fontSize: 20,
          ),
        ),
      ),
    );
  }

  button_Register(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 1.5,
      child: TextButton(
        onPressed: () {
          Navigator.pushNamed(context , SignUp.screenRoutes);
        },
        style: TextButton.styleFrom(
          elevation: 1,
          shape: const StadiumBorder(),
          // backgroundColor: Colors.blue
        ),
        child: const Text(
          'Register',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'AbrilFatface',
            fontSize: 20,
          ),
        ),
      ),
    );
  }

  password_Field() {
    return TextFormField(
      keyboardType: TextInputType.visiblePassword,
      obscureText: true,
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.yellow.shade900, width: 1),
          borderRadius: BorderRadius.circular(25),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.blue, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        prefixIcon: Icon(Icons.key, color: Colors.yellow.shade900),
        labelText: 'Password',
        labelStyle: TextStyle(
            fontFamily: 'AbrilFatface',
            fontSize: 20,
            color: Colors.yellow.shade900),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
      onChanged: (value) => password = value,
      focusNode: passwordFoucsNode,
      validator: (value) => value != testPass ? "Worst Password" : null,
    );
  }

  email_Field() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.yellow.shade900, width: 1),
          borderRadius: BorderRadius.circular(25),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.blue, width: 3),
          borderRadius: BorderRadius.circular(10),
        ),
        prefixIcon: Icon(
          Icons.email,
          color: Colors.yellow.shade900,
        ),
        labelText: 'Email',
        labelStyle: TextStyle(
            fontFamily: 'AbrilFatface',
            fontSize: 20,
            color: Colors.yellow.shade900),
        hintStyle: const TextStyle(
          fontFamily: 'AbrilFatface',
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
      focusNode: emailFocusNode,

      //validator: (value) => value != testEmail ? "Worst Email Address" : null,
      onChanged: (value) {
        email = value;
        if (value.isNotEmpty && value.length < 17 && !isLookLeft) {
          addControllerLookLeft();
        } else if (value.isNotEmpty && value.length > 17 && !isLookRight) {
          addControllerLookRight();
        }
      },
    );
  }

  SizedBox animation_Bear(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).size.height / 1.2,
        child: riveArtboard == null
            ? const SizedBox.shrink()
            : Rive(artboard: riveArtboard!));
  }

  Widget back_Image() {
    return SizedBox(
      height: double.infinity,
      child: Image.asset(
        'assets/backk.jpg',
        fit: BoxFit.fitHeight,
      ),
    );
  }

  Widget logo() {
    return Container(
      margin: const EdgeInsets.only(top: 1),
      alignment: Alignment.center,
      width: 100,
      height: 100,
      child: Image.asset('assets/m_back.png'),
    );
  }
}
