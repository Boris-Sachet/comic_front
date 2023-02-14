import 'dart:async';
import 'dart:io';

import 'package:comic_front/services/service_library.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


import '../model/library.dart';

class ServiceSettings {
  static String? _apiUrl;
  static Library? _currentLibrary;
  static bool _showHiddenLibraries = false;
  static bool? _darkMode;

  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _initApiUrl(prefs);
    await _initCurrentLibrary(prefs);
    _initShowHiddenLibraries();
    _initDarkMode(prefs);
  }
  //=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+
  // API URL
  //=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+
  /// Get the apiUrl from persistent storage and retrieve it from api if it exist
  static void _initApiUrl(SharedPreferences prefs)  {
    _apiUrl = prefs.getString('apiUrl');
  }

  static String? get apiUrl {
    return _apiUrl;
  }

  static set apiUrl(String? url) {
    _apiUrl = url;
    SharedPreferences.getInstance().then((pref) => {
      if (url != null) {pref.setString('apiUrl', url)} else {pref.remove('apiUrl')}
    });
  }

  /// Test the connectivity to a comic back api
  static Future<bool> pingApiUrl(String url) async {
    try {
      final response = await http.get(Uri.parse('http://$url/ping')).timeout(const Duration(seconds: 5));
      if (response.statusCode == 200 && response.body == "pong") {
        return true;
      } return false;
    }
    on SocketException catch (_) { return false; }
    on TimeoutException catch (_) { return false; }
  }

  //=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+
  // Current Library
  //=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+
  /// Get the current library from persistent storage and retrieve it from api if it exist
  static Future<void> _initCurrentLibrary(SharedPreferences prefs) async {
    if (_apiUrl != null) {
      final prefCurrentLibraryName = prefs.getString('currentLibraryName');
      if (prefCurrentLibraryName != null) {
        _currentLibrary = await ServiceLibrary.getLibrary(prefCurrentLibraryName);
      }
    }
  }

  static Library? get currentLibrary {
    return _currentLibrary;
  }

  static set currentLibrary(Library? library) {
    _currentLibrary = library;
    SharedPreferences.getInstance().then((pref) => {
      if (library != null && !library.hidden) {pref.setString('currentLibraryName', library.name)}
      else {pref.remove('currentLibraryName')}
    });
  }

  //=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+
  // Show Hidden Libraries
  //=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+
  /// Get wether or not the hiddenLibraries are shown from persistent storage and retrieve it from api if it exist
  static void _initShowHiddenLibraries() {
    // final prefs = await SharedPreferences.getInstance();
    // _showHiddenLibraries = prefs.getBool('showHiddenLibraries') ?? false;
    _showHiddenLibraries = false;
  }

  static bool get showHiddenLibraries {
    return _showHiddenLibraries;
  }

  static set showHiddenLibraries(bool show) {
    _showHiddenLibraries = show;
    // SharedPreferences.getInstance().then((pref) => pref.setBool('showHiddenLibraries', show).then((value) => {}));
  }

  //=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+
  // Dark Mode
  //=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+
  /// Get the darkMode status from persistent storage and retrieve it from api if it exist
  static void _initDarkMode(SharedPreferences prefs) {
    _darkMode = prefs.getBool('darkMode') ?? WidgetsBinding.instance.platformDispatcher.platformBrightness == Brightness.dark;
  }

  static bool get darkMode {
    return _darkMode ?? WidgetsBinding.instance.platformDispatcher.platformBrightness == Brightness.dark;
  }

  static set darkMode(bool darkMode) {
    _darkMode = darkMode;
    SharedPreferences.getInstance().then((pref) => pref.setBool('darkMode', darkMode).then((value) => {}));
  }
}