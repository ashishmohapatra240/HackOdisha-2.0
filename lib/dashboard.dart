import 'package:flutter/material.dart';
import 'package:nirbhaya/features/home/home.dart';
import 'package:nirbhaya/global_variables.dart';
import 'package:nirbhaya/myContactsScreen.dart';
import 'package:nirbhaya/settings.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _page = 0;
  List<Widget> pages = [
    const Home(),
    const MyContactsScreen(),
    const Settings(),
  ];

  void updatePage(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_page],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _page,
        selectedItemColor: GlobalVariables.primaryColor,
        unselectedItemColor: GlobalVariables.unselectedNavBarColor,
        backgroundColor: GlobalVariables.cardBackgroundColor,
        iconSize: 24,
        onTap: updatePage,
        items: [
          //Home
          BottomNavigationBarItem(
            icon: Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: _page == 0
                        ? GlobalVariables.cardBackgroundColor
                        : Colors.white,
                  ),
                ),
              ),
              child: Icon(Icons.home),
            ),
            label: '',
          ),

          BottomNavigationBarItem(
            icon: Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: _page == 1
                        ? GlobalVariables.cardBackgroundColor
                        : Colors.white,
                  ),
                ),
              ),
              child: Icon(Icons.contacts),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: _page == 1
                        ? GlobalVariables.cardBackgroundColor
                        : Colors.white,
                  ),
                ),
              ),
              child: Icon(Icons.settings),
            ),
            label: '',
          ),
        ],
      ),
    );
  }
}
