import 'package:fleetconnect/enums/locationAccess.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';

class PermissionsService {
  // final PermissionStatus _permission = Permission.contacts.status;
  StreamController<LocationAccessFromUser> locationServiceController =
      StreamController<LocationAccessFromUser>.broadcast();

  final PermissionHandler _permissionHandler = PermissionHandler();
  Future<bool> _requestPermission(PermissionGroup permission) async {
    var result = await _permissionHandler.requestPermissions([permission]);
    if (result[permission] == PermissionStatus.granted) {
      locationServiceController.add(LocationAccessFromUser.given);
      return true;
    }
    if (result[permission] == PermissionStatus.denied) {
      locationServiceController.add(LocationAccessFromUser.denied);
    }
    if (result[permission] == PermissionStatus.restricted) {
      locationServiceController.add(LocationAccessFromUser.deniedForever);
    }

    return false;
  }

  Future<bool> hasPermission(PermissionGroup permission) async {
    var permissionStatus =
        await _permissionHandler.checkPermissionStatus(permission);
    return permissionStatus == PermissionStatus.granted;
  }

  Future<bool> requestLocationPermission() async {
    return _requestPermission(PermissionGroup.locationAlways);
  }

  Future<bool> requestContactsPermission({Function onPermissionDenied}) async {
    var granted = await _requestPermission(PermissionGroup.location);
    print(granted);
    if (!granted) {
      onPermissionDenied();
    }
    return granted;
  }

  Future<bool> hasContactsPermission() async {
    return hasPermission(PermissionGroup.contacts);
  }

  void goToSettingsForPermission() {
    _permissionHandler.openAppSettings();
  }

  void undefinedLocationHandling() {
    _permissionHandler.checkServiceStatus(PermissionGroup.location);
  }
}
