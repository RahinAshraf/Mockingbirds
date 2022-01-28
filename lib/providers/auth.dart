import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;

  Future<void> authenticate(String email, String password, String urlSegment) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:sign$urlSegment?key=AIzaSyAfslOMWmJPNnGOYgq4CTuTOd5zONv8vHc');
    final response = await http.post(
      url,
      body: json.encode(
        {
          'email': email,
          'password': password,
          'returnSecureToken': true,
        },
      ),
    );
  }

  Future<void> signup(String email, String password) async {
    return authenticate(email, password, 'Up');
  }

  Future<void> login(String email, String password) async {
    return authenticate(email, password, 'InWIthPassword');
  }
}
