import 'package:fleetconnect/enums/locationAccess.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LocationSensitiveScreens extends StatelessWidget {
  final Widget child;

  const LocationSensitiveScreens({this.child});
  @override
  Widget build(BuildContext context) {
    var locationStatus = Provider.of<LocationAccessFromUser>(context);
    if (locationStatus == LocationAccessFromUser.given) {
      return child;
    }
    if (locationStatus == LocationAccessFromUser.denied) {
      return Scaffold(
        body: Center(
          child: Text("No permission is granted"),
        ),
      );
    }
    if (locationStatus == LocationAccessFromUser.deniedForever) {
      return Scaffold(
        body: Center(
          child: Text("No permission is granted FOREVER"),
        ),
      );
    }
    return child;
  }
}
