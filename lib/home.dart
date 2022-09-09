import 'dart:math';

import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int nameIndex = 0;

  @override
  void initState() {
    super.initState();
    getRandomInt(false);
  }

  getRandomInt(fromClick) {
    Random rnd = Random();

    nameIndex = rnd.nextInt(4);
    if (mounted && fromClick) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Image.asset(
            'assets/images/logo.png',
            height: 36,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(children: [Text('Hey, ')]),
        ),
      ),
    );
  }
}
