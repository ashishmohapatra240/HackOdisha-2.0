import 'package:flutter/material.dart';
import 'package:nirbhaya/features/home/emergency/widgets/ambulance.dart';
import 'package:nirbhaya/features/home/emergency/widgets/nationalemergency.dart';
import 'package:nirbhaya/features/home/emergency/widgets/police.dart';
import 'package:nirbhaya/features/home/emergency/widgets/womenabuse.dart';

class Emergency extends StatelessWidget {
  const Emergency({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 180,
      child: ListView(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        children: [
          NationalEmergency(),
          PoliceEmergency(),
          AmbulanceEmergency(),
          WomenAbuseEmergency(),
        ],
      ),
    );
  }
}
