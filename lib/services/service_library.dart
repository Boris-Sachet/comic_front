import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../model/library.dart';
import '../model/directory.dart';
import '../model/file.dart';

class ServiceLibrary{
  static const String _baseUrl = '192.168.1.18:8042';
  static Library? _currentLibrary;


  /// Get a list of all libraries
  static Future<List<Library>> getLibraries() async {
    final response = await http.get(Uri.parse('http://$_baseUrl/library'));
    if (response.statusCode == 200) {
      final List<dynamic> json = jsonDecode(response.body);
      final List<Library> libraries = json.map((dynamic item) => Library.fromJson(item)).toList();
      return libraries;
    } else {
      throw Exception('Failed to load libraries');
    }
  }


  /// Get a library by name
  static Future<Library> getLibrary(String libraryName) async {
    final response = await http.get(Uri.parse('http://$_baseUrl/library/$libraryName'));

    if (response.statusCode == 200) {
      return Library.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch library');
    }
  }


  /// Get the content of a directory in a library
  static Future<List> getLibraryContent(String libraryName, String directoryPath) async {
    final response = await http.get(Uri.parse('http://$_baseUrl/library/$libraryName/content/?path=$directoryPath'));

    if (response.statusCode == 200) {
      final List<dynamic> json = jsonDecode(utf8.decode(response.bodyBytes));
      final List<Directory> directories = (json[0] as List).map((dynamic item) => Directory.fromJson(item)).toList();
      final List<File> files = (json[1] as List).map((dynamic item) => File.fromJson(item)).toList();

      directories.sort((a, b) => a.name.compareTo(b.name));
      files.sort((a, b) => a.name.compareTo(b.name));

      return [directories, files];
    } else {
      throw Exception('Failed to fetch library folder content');
    }
  }

  /// Get the current library from persistent storage and retrieve it from api if it exist
  static Future<Library?> getCurrentLibrary() async {
    if (_currentLibrary == null) {
      final prefs = await SharedPreferences.getInstance();
      final prefCurrentLibraryName = prefs.getString('currentLibraryName');
      if (prefCurrentLibraryName != null) {
        _currentLibrary = await getLibrary(prefCurrentLibraryName);
      }
    }
    return _currentLibrary;
  }

  /// Set the current library value, in this class and store it's name async in persistent storage
  static void setCurrentLibrary(Library library) async {
    _currentLibrary = library;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('currentLibraryName', library.name);
  }

  static String getFileCoverUrl(String fileId) {
    return 'http://$_baseUrl/file/comics/$fileId/cover';
  }
}