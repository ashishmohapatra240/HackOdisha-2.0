import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nirbhaya/features/home/home.dart';
import 'package:nirbhaya/global_variables.dart';
import 'package:nirbhaya/myContactsScreen.dart';
import 'package:nirbhaya/phonebook.dart';
import 'package:nirbhaya/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart' as appPermissions;
import 'package:location/location.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool alerted = false;

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
  void initState() {
    super.initState();
    checkAlertSharedPreferences();
    checkPermission();
  }

  late SharedPreferences prefs;
  checkAlertSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(
        () {
          alerted = prefs.getBool("alerted") ?? false;
        },
      );
    }
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
      floatingActionButton: _page == 1
          ? FloatingActionButton(
              backgroundColor: GlobalVariables.primaryColor,
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PhoneBook()));
              },
              child: const Icon(
                Icons.add,
              ),
            )
          : FloatingActionButton(
              backgroundColor: GlobalVariables.primaryColor,
              onPressed: () async {
                if (alerted) {
                  int pin = (prefs.getInt('pin') ?? -1111);
                  print('User $pin .');
                  if (pin == -1111) {
                    sendAlertSMS(false);
                  }
                } else {
                  sendAlertSMS(true);
                }
              },
              child: alerted
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Image.asset(
                        //   "assets/alarm.png",
                        //   height: 24,
                        // ),
                        Text("STOP")
                      ],
                    )
                  // : Image.asset(
                  //     "assets/icons/alert.png",
                  //     height: 36,
                  //   ),
                  : Icon(Icons.emergency)),
    );
  }

  checkPermission() async {
    appPermissions.PermissionStatus conPer =
        await appPermissions.Permission.contacts.status;
    appPermissions.PermissionStatus locPer =
        await appPermissions.Permission.location.status;
    appPermissions.PermissionStatus phonePer =
        await appPermissions.Permission.phone.status;
    appPermissions.PermissionStatus smsPer =
        await appPermissions.Permission.sms.status;
    if (conPer != appPermissions.PermissionStatus.granted) {
      await appPermissions.Permission.contacts.request();
    }
    if (locPer != appPermissions.PermissionStatus.granted) {
      await appPermissions.Permission.location.request();
    }
    if (phonePer != appPermissions.PermissionStatus.granted) {
      await appPermissions.Permission.phone.request();
    }
    if (smsPer != appPermissions.PermissionStatus.granted) {
      await appPermissions.Permission.sms.request();
    }
  }

  // void sendSMS(String number, String msgText) {
  //   print(number);
  //   print(msgText);
  //   smsSender.SmsMessage msg = smsSender.SmsMessage(number, msgText);
  //   final smsSender.SmsSender sender =  smsSender.SmsSender();
  //   msg.onStateChanged.listen((state) {
  //     if (state == smsSender.SmsMessageState.Sending) {
  //       return Fluttertoast.showToast(
  //         msg: 'Sending Alert...',
  //         backgroundColor: Colors.blue,
  //       );
  //     } else if (state == smsSender.SmsMessageState.Sent) {
  //       return Fluttertoast.showToast(
  //         msg: 'Alert Sent Successfully!',
  //         backgroundColor: Colors.green,
  //       );
  //     } else if (state == smsSender.SmsMessageState.Fail) {
  //       return Fluttertoast.showToast(
  //         msg: 'Failure! Check your credits & Network Signals!',
  //         backgroundColor: Colors.red,
  //       );
  //     } else {
  //       return Fluttertoast.showToast(
  //         msg: 'Failed to send SMS. Try Again!',
  //         backgroundColor: Colors.red,
  //       );
  //     }
  //   });
  //   sender.sendSms(msg);
  // }

  sendAlertSMS(bool isAlert) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setBool("alerted", isAlert);
      alerted = isAlert;
    });
    checkPermission();

    prefs.setBool("alerted", isAlert);
    List<String> numbers = prefs.getStringList("numbers") ?? [];
    LocationData? myLocation;
    String error;
    Location location = Location();
    String link = '';
    try {
      myLocation = await location.getLocation();
      var currentLocation = myLocation;

      if (numbers.isEmpty) {
        setState(() {
          prefs.setBool("alerted", false);
          alerted = false;
        });
        return Fluttertoast.showToast(
          msg: 'No Contacts Found!',
          backgroundColor: Colors.red,
        );
      } else {
        //var coordinates =
        //    Coordinates(currentLocation.latitude, currentLocation.longitude);
        //var addresses =
        //    await Geocoder.local.findAddressesFromCoordinates(coordinates);
        // var first = addresses.first;
        String li =
            "http://maps.google.com/?q=${currentLocation.latitude},${currentLocation.longitude}";
        if (isAlert) {
          link = "Help Me! SOS \n$li";
        } else {
          Fluttertoast.showToast(
              msg: "Contacts are being notified about false SOS.");
          link = "I am safe, track me here\n$li";
        }

        for (int i = 0; i < numbers.length; i++) {
          // sendSMS(numbers[i].split("***")[1], link);
        }
      }
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        error = 'Please grant permission';
        print('Error due to Denied: $error');
      }
      if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
        error = 'Permission denied- please enable it from app settings';
        print("Error due to not Asking: $error");
      }
      myLocation = null;

      prefs.setBool("alerted", false);

      setState(() {
        alerted = false;
      });
    }
  }
}
