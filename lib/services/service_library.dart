import 'dart:convert';

import 'package:comic_front/services/service_settings.dart';
import 'package:http/http.dart' as http;

import '../model/library.dart';
import '../model/directory.dart';
import '../model/file.dart';

class ServiceLibrary {
  static Library? _currentLibrary;


  /// Get a list of all libraries
  static Future<List<Library>> getLibraries() async {
    final response = await http.get(Uri.parse('http://${ServiceSettings.apiUrl}/library'));
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
    final response = await http.get(Uri.parse('http://${ServiceSettings.apiUrl}/library/$libraryName'));

    if (response.statusCode == 200) {
      return Library.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch library');
    }
  }


  /// Get the content of a directory in a library
  static Future<List> getLibraryContent(Library library, String directoryPath) async {
    final response = await http.get(Uri.parse('http://${ServiceSettings.apiUrl}/library/${library.name}/content/?path=$directoryPath'));

    if (response.statusCode == 200) {
      final List<dynamic> json = jsonDecode(utf8.decode(response.bodyBytes));
      final List<Directory> directories = (json[0] as List).map((dynamic item) => Directory.fromJson(item)).toList();
      final List<File> files = (json[1] as List).map((dynamic item) => File.fromJson(item, library)).toList();

      directories.sort((a, b) => a.name.compareTo(b.name));
      files.sort((a, b) => a.name.compareTo(b.name));

      return [directories, files];
    } else {
      throw Exception('Failed to fetch library folder content');
    }
  }
}