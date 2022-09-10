import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nirbhaya/features/home/emergency/emergency.dart';
import 'package:nirbhaya/features/home/quick_search/quick_search.dart';
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
              padding: const EdgeInsets.only(left: 24.0, top: 16),
              child: RichText(
                text: TextSpan(
                  text: 'Hey, ',
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontFamily: GoogleFonts.raleway().fontFamily),
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
            SizedBox(
              height: 16,
            ),
            // Text(
            //   'Hey, Diana Prince',
            //   style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
            // ),
            Padding(
              padding: const EdgeInsets.only(left: 24),
              child: RichText(
                text: TextSpan(
                  text: 'Some ',
                  style: TextStyle(
                      fontSize: 24,
                      color: GlobalVariables.primaryTextColor,
                      fontWeight: FontWeight.w600,
                      fontFamily: GoogleFonts.raleway().fontFamily),
                  children: const <TextSpan>[
                    TextSpan(
                      text: 'superwomen ',
                      style: TextStyle(
                          color: GlobalVariables.primaryColor, fontSize: 24),
                    ),
                    TextSpan(
                      text: 'stories',
                      style: TextStyle(
                          color: GlobalVariables.primaryTextColor,
                          fontSize: 24),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Carousel(),
            const SizedBox(
              height: 20,
            ),
            const Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Emergency Numbers',
                style: TextStyle(
                  color: GlobalVariables.primaryTextColor,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0,
                ),
              ),
            ),
            SizedBox(
              height: 12,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 0, 0),
              child: Emergency(),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 24),
              child: Text(
                'Quick Search',
                style: TextStyle(
                  color: GlobalVariables.primaryTextColor,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0,
                ),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 24),
              child: QuickSearch(),
            ),
          ],
        ),
      ),
    );
  }
}
