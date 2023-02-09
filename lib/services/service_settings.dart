import 'package:comic_front/services/service_library.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/library.dart';

class ServiceSettings {
  static String? _apiUrl;
  static Library? _currentLibrary;
  static bool _showHiddenLibraries = false;
  static bool? _darkMode;

  static Future<void> init() async {
    await _initApiUrl();
    await _initCurrentLibrary();
    await _initShowHiddenLibraries();
    await _initDarkMode();
  }

  /// Get the apiUrl from persistent storage and retrieve it from api if it exist
  static Future<void> _initApiUrl() async {
    final prefs = await SharedPreferences.getInstance();
    // _apiUrl = prefs.getString('apiUrl');
    _apiUrl = '192.168.1.18:8042';
    // _apiUrl = '10.0.2.2:8000';
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

  /// Get the current library from persistent storage and retrieve it from api if it exist
  static Future<void> _initCurrentLibrary() async {
    if (_apiUrl != null) {
      final prefs = await SharedPreferences.getInstance();
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

  /// Get wether or not the hiddenLibraries are shown from persistent storage and retrieve it from api if it exist
  static Future<void> _initShowHiddenLibraries() async {
    final prefs = await SharedPreferences.getInstance();
    _showHiddenLibraries = prefs.getBool('showHiddenLibraries') ?? false;
  }

  static bool get showHiddenLibraries {
    return _showHiddenLibraries;
  }

  static set showHiddenLibraries(bool show) {
    _showHiddenLibraries = show;
    SharedPreferences.getInstance().then((pref) => pref.setBool('currentLibraryName', show).then((value) => {}));
  }

  /// Get the darkMode status from persistent storage and retrieve it from api if it exist
  static Future<void> _initDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
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