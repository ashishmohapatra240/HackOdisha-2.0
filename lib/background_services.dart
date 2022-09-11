import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:location/location.dart';
import 'package:shake/shake.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:telephony/telephony.dart';
import 'package:vibration/vibration.dart';
import 'package:workmanager/workmanager.dart';
import 'package:geolocator/geolocator.dart';

void onStart() async {
  WidgetsFlutterBinding.ensureInitialized();
  final service = FlutterBackgroundService();

  SharedPreferences prefs = await SharedPreferences.getInstance();

  // I have instanciated the service object above and here I am just
  // making a stream to listen for the events
  service.onDataReceived.listen((event) async {
    if (event!["action"] == "setAsForeground") {
      service.setForegroundMode(true);

      return;
    }

    if (event["action"] == "setAsBackground") {
      service.setForegroundMode(false);
    }

    if (event["action"] == "stopService") {
      service.stopBackgroundService();
    }
  });
  Location _location;
  Position currentLocation;

  // BackgroundLocation.getLocationUpdates((location) {
  // _location = location;
  // prefs.setStringList("location",
  //     [location.latitude.toString(), location.longitude.toString()]);
  // });

  // Location location = Location();
  // location.enableBackgroundMode(enable: true);

  // bool _serviceEnabled;
  // PermissionStatus _permissionGranted;
  // LocationData _locationData;

  // _serviceEnabled = await location.serviceEnabled();
  // if (!_serviceEnabled) {
  //   _serviceEnabled = await location.requestService();
  //   if (!_serviceEnabled) {
  //     return;
  //   }
  // }

  // _permissionGranted = await location.hasPermission();
  // if (_permissionGranted == PermissionStatus.denied) {
  //   _permissionGranted = await location.requestPermission();
  //   if (_permissionGranted != PermissionStatus.granted) {
  //     return;
  //   }
  // }

  // _locationData = await location.getLocation();
  // prefs.setStringList("location", [location.toString()]);

  //Location
  bool serviceEnabled;
  LocationPermission permission;
  currentLocation = await Geolocator.getCurrentPosition();
      prefs.setStringList("location",
        [currentLocation.latitude.toString(), currentLocation.longitude.toString()]);
        print(currentLocation.latitude.toString());
        print(currentLocation.longitude.toString());

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }



  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  String screenShake = "Be strong, We are with you!";
  ShakeDetector.autoStart(
      shakeThresholdGravity: 7,
      onPhoneShake: () async {
        print("Test 1");
        if (await Vibration.hasVibrator() ?? true) {
          print("Test 2");
          if (await Vibration.hasCustomVibrationsSupport() ?? true) {
            print("Test 3");
            Vibration.vibrate(duration: 1000);
          } else {
            print("Test 4");
            Vibration.vibrate();
            await Future.delayed(Duration(milliseconds: 500));
            Vibration.vibrate();
          }
          print("Test 5");
        }
        print("Test 6");
        String link = '';
        print("Test 7");
        try {
          double lat = currentLocation.latitude;
          double long = currentLocation.longitude;
          print("$lat ... $long");
          print("Test 9");
          link = "http://maps.google.com/?q=$lat,$long";
          SharedPreferences prefs = await SharedPreferences.getInstance();
          List<String> numbers = prefs.getStringList("numbers") ?? [];
          String error;
          try {
            if (numbers.isEmpty) {
              screenShake = "No contacs found, Please call 15 ASAP.";
              debugPrint(
                'No Contacts Found!',
              );
              return;
            } else {
              for (int i = 0; i < numbers.length; i++) {
                //Here I used telephony to send sms messages to the saved contacts.
                Telephony.backgroundInstance.sendSms(
                    to: numbers[i], message: "Help Me! Track me here.\n$link");
              }
              prefs.setBool("alerted", true);
              screenShake = "SOS alert Sent! Help is on the way.";
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
          }
          print("Test 10");
          print(link);
        } catch (e) {
          print("Test 11");
          print(e);
        }
      });
  print("Test 12");

  service.setForegroundMode(true);

  Timer.periodic(Duration(seconds: 1), (timer) async {
    if (!(await service.isServiceRunning())) timer.cancel();

    service.setNotificationInfo(
      title: "Safe Shake activated!",
      content: screenShake,
    );

    service.sendData(
      {"current_date": DateTime.now().toIso8601String()},
    );
  });
}

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    String contact = inputData!['contact'];
    final prefs = await SharedPreferences.getInstance();
    print(contact);
    List<String>? location = prefs.getStringList("location");
    String link = "http://maps.google.com/?q=${location![0]},${location[1]}";
    print(location);
    print(link);
    Telephony.backgroundInstance
        .sendSms(to: contact, message: "I am on my way! Track me here.\n$link");
    return true;
  });
}
