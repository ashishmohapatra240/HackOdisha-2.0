import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:nirbhaya/global_variables.dart';

class PoliceEmergency extends StatelessWidget {
  const PoliceEmergency({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: InkWell(
            onTap: () {
              _callNumber("15");
            },
            child: Container(
              height: 72,
              width: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: GlobalVariables.callCardColor,
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 20,
                    ),
                    child: Row(
                      children: const [
                        Icon(
                          Icons.call,
                          color: GlobalVariables.primaryColor,
                        ),
                        Text(
                          '100',
                          style: TextStyle(
                              color: GlobalVariables.primaryColor,
                              fontSize: 24,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
         SizedBox(
          height: 8,
        ),
        Text(
          'Police Station',
          style:
              TextStyle(color: GlobalVariables.primaryTextColor, fontSize: 10),
        ),
      ],
    );
  }

  _callNumber(number) async {
    await FlutterPhoneDirectCaller.callNumber(number);
  }
}
