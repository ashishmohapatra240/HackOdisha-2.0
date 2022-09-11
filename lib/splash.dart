import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nirbhaya/dashboard.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  bool _visible = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        Future.delayed(
          Duration(milliseconds: 2000),
          () {
            setState(
              () {
                _visible = !_visible;
              },
            );
            // _navigatetohome();
          },
        );
      },
    );
  }

  _navigatetohome() async {
    // await Future.delayed(Duration(milliseconds: 1500), () {});

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: ((context) => Dashboard()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedOpacity(
        opacity: _visible ? 1.0 : 0.0,
        curve: Curves.linear,
        duration: const Duration(milliseconds: 1500),
        child: Center(
          child: Container(
            child: const Image(
              image: AssetImage("assets/images/logo.png"),
            ),
            height: 33.1,
            width: 148.63,
          ),
        ),
      ),
    );
  }
}
