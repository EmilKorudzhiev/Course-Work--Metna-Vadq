import 'dart:convert';

import 'package:MetnaVadq/blocs/secure_storage_controller.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:MetnaVadq/utils/constants.dart';


class AuthController {

  static Future saveJwtToken(Map<String, dynamic> json) async {
    await SecureStorageController.storage
        .write(
        key: SecureStorageController.jwtStorageKey,
        value: jsonEncode(json));
    print(await SecureStorageController.storage.read(key: "jwt"));
  }


  static Future loginUser(String email, String password) async {
    const url = "${Constants.URL}auth/authenticate";

    Map<String,String> headers = {'Content-Type':'application/json'};

    var body = jsonEncode({
      "email": email,
      "password": password,
    });

    http.Response response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
    );
    print(response.body);
    print(response.statusCode);

    final statusType = (response.statusCode / 100).floor() * 100;
    switch (statusType) {
      case 200:

        saveJwtToken(jsonDecode(response.body));
        // final jwtAccessToken = json['access_token'];
        // final jwtAccessTokenExpiration = json['access_token_validity'];
        // final jwtRefreshToken = json['access_token'];
        // print("JWT TOKEN:: " + jwtAccessToken);
        // print("JWT EXP:: " + jwtAccessTokenExpiration);
        // print("JWT REFRESH:: " + jwtRefreshToken);



      case 400:
        final json = jsonDecode(response.body);
      case 300:
      case 500:
      default:
        print("error");
    }
  }
}