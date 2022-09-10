import 'package:flutter/material.dart';
import 'package:nirbhaya/global_variables.dart';

class PoliceStationCard extends StatelessWidget {
  final Function openMapFunc;
  const PoliceStationCard({Key? key, required this.openMapFunc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: GlobalVariables.borderColor,
          )),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: InkWell(
                onTap: () {
                  openMapFunc("Police Stations near me");
                },
                child: Center(
                  child: Icon(Icons.local_police),
                ),
              ),
            ),
            Text("Police Stations"),
          ],
        ),
      ),
    );
  }
}
