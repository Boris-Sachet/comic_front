import 'package:comic_front/model/library.dart';

import '../services/service_library.dart';

class File {
  final String id;
  final String name;
  final int pagesCount;
  final int currentPage;
  final Library library;

  const File({
    required this.id,
    required this.name,
    required this.pagesCount,
    required this.currentPage,
    required this.library,
  });

  factory File.fromJson(Map<String, dynamic> json, Library library) {
    return File(
      id: json['_id'],
      name: json['name'],
      pagesCount: json['pages_count'],
      currentPage: json['current_page'],
      library: library,
    );
  }

  String get coverUrl {
    return 'http://${ServiceLibrary.baseUrl}/file/${library.name}/$id/cover';
  }
}
