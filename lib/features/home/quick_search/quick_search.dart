import 'package:flutter/material.dart';
import 'package:nirbhaya/features/home/quick_search/widgets/bus_stops.dart';
import 'package:nirbhaya/features/home/quick_search/widgets/hospital.dart';
import 'package:nirbhaya/features/home/quick_search/widgets/police_station.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:fluttertoast/fluttertoast.dart';

class QuickSearch extends StatelessWidget {
  const QuickSearch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 96,
      width: MediaQuery.of(context).size.width,
      child: ListView(
          scrollDirection: Axis.horizontal,
          physics: BouncingScrollPhysics(),
          children: [
            PoliceStationCard(openMapFunc: openMap),
            HospitalCard(openMapFunc: openMap),
            BusStopCard(openMapFunc: openMap)
          ]),
    );
  }

  static Future<void> openMap(String location) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$location';

    try {
      if (await canLaunchUrl(
        Uri.parse(googleUrl),
      )) {
        await launchUrl(Uri.parse(googleUrl));
      }
    } catch (e) {
      print(e);
      Fluttertoast.showToast(
          msg: "Something went wrong! Call emergency numbers.");
    }
    // if (await canLaunch(googleUrl)) {
    //   await launch(googleUrl);
    // } else {
    //   throw 'Could not open the map.';
    // }
  }
}
