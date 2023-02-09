import 'dart:convert';

import 'package:comic_front/services/service_settings.dart';
import 'package:http/http.dart' as http;
import 'package:comic_front/model/file.dart';

import '../model/library.dart';

class ServiceFile {
  static Future<File> setCurrentPage(File file, int page) async {
    final response = await http.post(Uri.parse('http://${ServiceSettings.apiUrl}/file/${file.library.name}/${file.id}/page/$page'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(utf8.decode(response.bodyBytes));
      final File updatedFile = File.fromJson(json, file.library);
      return updatedFile;
    } else {
      throw Exception('Failed to update file current page');
    }
  }
}