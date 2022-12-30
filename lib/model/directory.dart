class Directory {
  final String name;
  final String path;

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
    if (isRoot()) {
      return this;
    }
    final List<String> pathParts = path.split('/');
    pathParts.removeLast();
    final String parentPath = pathParts.join('/');
    if (parentPath == "") {
      return root;
    }
    String parentName = pathParts[pathParts.length - 1];
    return Directory(name: parentName, path: parentPath);
  }

  bool isRoot() {
    return path == root.path;
  }
}