import 'dart:math';

import 'package:flutter/material.dart';
import 'package:nirbhaya/features/home/emergency/emergency.dart';
import 'package:nirbhaya/features/widgets/carousel.dart';
import 'package:nirbhaya/global_variables.dart';

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
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: RichText(
                text: const TextSpan(
                  text: 'Hey, ',
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.black,
                      fontWeight: FontWeight.w600),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Diana Prince',
                      style: TextStyle(
                          color: GlobalVariables.primaryColor, fontSize: 30),
                    ),
                  ],
                ),
              ),
            ),
            // Text(
            //   'Hey, Diana Prince',
            //   style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
            // ),
            Carousel(),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Emergency Numbers',
                style: TextStyle(
                    color: GlobalVariables.primaryTextColor,
                    fontSize: 24,
                    fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(
              height: 12,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 0, 0),
              child: Emergency(),
            ),
          ],
        ),
      ),
    );
  }
}
