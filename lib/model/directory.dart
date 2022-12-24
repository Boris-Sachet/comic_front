class Directory {
  final String name;
  final String path;
  final String type = 'directory';

  const Directory ({
    required this.name,
    required this.path,
  });

  static const Directory root = Directory(name: 'root', path: '/');

  factory Directory.fromJson(Map<String, dynamic> json) {
    return Directory(
      name: json['name'],
      path: json['path'],
    );
  }

  Directory get parent {
    if (path == root.path) {
      return this;
    }
    final List<String> pathParts = path.split('/');
    pathParts.removeLast();
    final String parentPath = pathParts.join('/');
    return Directory(name: 'Parent', path: parentPath);
  }
}