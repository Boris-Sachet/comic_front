class File {
  final String id;
  final String name;
  final int pagesCount;
  final int currentPage;
  final String type = 'file';

  const File({
    required this.id,
    required this.name,
    required this.pagesCount,
    required this.currentPage,
  });

  factory File.fromJson(Map<String, dynamic> json) {
    return File(
      id: json['_id'],
      name: json['name'],
      pagesCount: json['pages_count'],
      currentPage: json['current_page'],
    );
  }
}
