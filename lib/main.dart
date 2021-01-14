import 'dart:async';

import 'package:fleetconnect/models/UserLocation.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';

import 'Services/PermissionService.dart';
import 'Services/httpService.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FleetConnect(),
    );
  }
}

class FleetConnect extends StatefulWidget {
  @override
  _FleetConnectState createState() => _FleetConnectState();
}

class _FleetConnectState extends State<FleetConnect> {
  StreamController<UserLocation> locationStream =
      StreamController<UserLocation>.broadcast();
  String staus;
  String location = "wer";
  Future<bool> checkForLocationAccess() async {
    bool status =
        await PermissionsService().hasPermission(PermissionGroup.location);
    if (status == true) {
      setState(() {
        staus = "have location";
      });
    } else {
      setState(() {
        staus = " dont have location";
      });
    }
  }

  void requestForPermission() {
    PermissionsService().requestContactsPermission(onPermissionDenied: () {
      PermissionsService().goToSettingsForPermission();
    });
  }

  @override
  void initState() {
    checkForLocationAccess();
    requestForPermission();
    Stream stream = locationStream.stream;
    stream.listen((value) async {
      await HttpService().postRequest(value.lat, value.lon);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Fleet Connect"),
        ),
        body: Center(
          child: FlatButton(
            onPressed: () {
              Location().onLocationChanged.listen((changeLocation) {
                locationStream.add(UserLocation(
                    lat: changeLocation.latitude,
                    lon: changeLocation.longitude));
              });
            },
            child: Text(staus ?? "Start Tracking"),
          ),
        ));
  }
}
