import 'dart:convert';
import 'dart:developer';
import 'package:expense_manager/config/app_config.dart';
import 'package:expense_manager/core/http/http_type_def.dart';
import 'package:expense_manager/data/models/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPrefsRepoProvider =
    Provider<SharedPrefsRepo>((ref) => SharedPrefsRepo());

class SharedPrefsRepo {
  final String _accessTokenKey = "ACCESS_TOKEN";
  final String _refreshTokenKey = "REFRESH_TOKEN";
  final String _currentUserKey = "CURRENT_USER";
  final _name = "SHARED_PREFS_REPO";

  Future<String?> getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final cookie = prefs.getString(_accessTokenKey);
    if (AppConfig.devMode) {
      log("Reading cookie", name: _name);
      log("Data : $cookie", name: _name);
    }
    return cookie;
  }

  Future<String?> getRefreshToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final cookie = prefs.getString(_refreshTokenKey);
    if (AppConfig.devMode) {
      log("Reading cookie", name: _name);
      log("Data : $cookie", name: _name);
    }
    return cookie;
  }

  Future<User?> getCurrentUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_currentUserKey);
    if (AppConfig.devMode) {
      log("Reading user", name: _name);
      log("Data : $data", name: _name);
    }
    final user = data != null ? User.fromJson(jsonDecode(data)) : null;
    return user;
  }

  FutureVoid setCurrentUser(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (AppConfig.devMode) {
      log("Saving user", name: _name);
      log("Data : ${user.toJson()}", name: _name);
    }
    prefs.setString(_currentUserKey, jsonEncode(user.toJson()));
  }

  FutureVoid setRefreshToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (AppConfig.devMode) {
      log("Saving refresh_token", name: _name);
    }
    prefs.setString(_refreshTokenKey, token);
  }

  FutureVoid setAccessToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (AppConfig.devMode) {
      log("Saving refresh_token", name: _name);
    }
    prefs.setString(_accessTokenKey, token);
  }

  FutureVoid setKey(String key, String data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (AppConfig.devMode) {
      log("Saving key", name: _name);
      log("Data : $data", name: _name);
    }
    prefs.setString(key, data);
  }

  FutureVoid clear() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
