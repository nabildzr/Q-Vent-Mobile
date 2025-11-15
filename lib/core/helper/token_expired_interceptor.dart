import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../../features/Authentication/presentation/pages/login_page.dart';
import '../../features/Authentication/presentation/provider/authentication_provider.dart';

class HttpClientWithTokenExpiration {
  final BuildContext context;
  final http.Client _client = http.Client();
  
  HttpClientWithTokenExpiration(this.context);
  
  Future<http.Response> get(Uri url, {Map<String, String>? headers}) async {
    final response = await _client.get(url, headers: headers);
    return _handleResponse(response);
  }
  
  Future<http.Response> post(Uri url, {Map<String, String>? headers, Object? body, Encoding? encoding}) async {
    final response = await _client.post(url, headers: headers, body: body, encoding: encoding);
    return _handleResponse(response);
  }
  
  Future<http.Response> put(Uri url, {Map<String, String>? headers, Object? body, Encoding? encoding}) async {
    final response = await _client.put(url, headers: headers, body: body, encoding: encoding);
    return _handleResponse(response);
  }
  
  Future<http.Response> delete(Uri url, {Map<String, String>? headers, Object? body, Encoding? encoding}) async {
    final response = await _client.delete(url, headers: headers, body: body, encoding: encoding);
    return _handleResponse(response);
  }
  
  Future<http.Response> _handleResponse(http.Response response) async {
    if (response.statusCode == 401) {
      // Token expired or invalid
      await _handleTokenExpired();
    }
    return response;
  }
  
  Future<void> _handleTokenExpired() async {
    final authProvider = Provider.of<AuthenticationProvider>(context, listen: false);
    
    // Logout user
    await authProvider.logout();
    
    // Navigate to login page
    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => LoginPage()),
      (route) => false,
    );
  }
  
  void close() {
    _client.close();
  }
}