import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class HttpService {
  Future<void> postRequest(double latitude, double longitude) async {
    var url = 'https://openapi.fleetconnect.io/device-data';

    Map data = {
      "token": "5b0262ee305b1530afa88e3e",
      "imei": "0358735070711998",
      "latitude": latitude,
      "longitude": longitude
    };
    //encode Map to JSON
    var body = json.encode(data);

    var response = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: body);
    print("${response.statusCode}");
    print("${response.body}");
  }
}
