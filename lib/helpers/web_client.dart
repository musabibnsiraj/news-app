import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../helpers/utill.dart';
import '../../app_config.dart';

class WebClient {
  static const internalAPIbaseUrl = AppConfig.internalAPIbaseUrl;
  static const internalEndpointUrl = AppConfig.internalEndpointUrl;
  static const apiKey = AppConfig.apiKey;
  late BuildContext context;

  Future<dynamic> get(String path, {Map<String, dynamic>? params}) async {
    var client = http.Client();
    var uri =
        Uri.https(internalAPIbaseUrl, '$internalEndpointUrl$path', params);
    var response = await client.get(uri);
    final json = jsonDecode(response.body);

    // Check for errors in the API response
    if (response.statusCode != 200) {
      Utill.showError("Error: Something went wrong!");
    } else {
      return json;
    }
  }
}
