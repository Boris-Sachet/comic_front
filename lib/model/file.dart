import 'package:comic_front/model/library.dart';

import '../services/service_settings.dart';

class File {
  final String id;
  final String name;
  final int pagesCount;
  int currentPage;
  final DateTime addDate;
  final DateTime updateDate;
  final Library library;

  File({
    required this.id,
    required this.name,
    required this.pagesCount,
    required this.currentPage,
    required this.addDate,
    required this.updateDate,
    required this.library,
  });

  factory File.fromJson(Map<String, dynamic> json, Library library) {
    return File(
      id: json['_id'],
      name: json['name'],
      pagesCount: json['pages_count'],
      currentPage: json['current_page'],
      addDate: DateTime.parse(json['add_date']),
      updateDate: DateTime.parse(json['update_date']),
      library: library,
    );
  }

  String get coverUrl {
    return 'http://${ServiceSettings.apiUrl}/file/${library.name}/$id/cover';
  }

  List<String> get pagesUrl {
    List<String> result = [];
    for (var i = 0; i <= pagesCount; i++) {
      result.add('http://${ServiceSettings.apiUrl}/file/${library.name}/$id/page/$i');
    }
    return result;
  }

  bool get read {
    return currentPage + 1 == pagesCount;
  }
}
