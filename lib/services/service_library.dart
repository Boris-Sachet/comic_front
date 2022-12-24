import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/library.dart';
import '../model/directory.dart';
import '../model/file.dart';

class ServiceLibrary{
  static const String baseUrl = '192.168.1.18:8042';
  static Library? currentLibrary;


  /// Get a list of all libraries
  Future<List<Library>> getLibraries() async {
    final response = await http.get(Uri.parse('http://$baseUrl/library'));
    if (response.statusCode == 200) {
      final List<dynamic> json = jsonDecode(response.body);
      final List<Library> libraries = json.map((dynamic item) => Library.fromJson(item)).toList();
      return libraries;
    } else {
      throw Exception('Failed to load libraries');
    }
  }


  /// Get a library by name
  Future<Library> getLibrary() async {
    final response = await http.get(Uri.parse('http://$baseUrl/library/comics'));

    if (response.statusCode == 200) {
      return Library.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch library');
    }
  }

  Future<List> getLibraryContent(String libraryName, String directoryPath) async {
    final response = await http.get(Uri.parse('http://$baseUrl/library/$libraryName/content/?path=$directoryPath'));

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

}