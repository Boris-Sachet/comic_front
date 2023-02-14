class Library {
  final String name;
  final String path;
  final bool hidden;
  final String connect_type;
  final String user;
  final String server;
  final String service_name;

  const Library({
    required this.name,
    required this.path,
    required this.hidden,
    required this.connect_type,
    this.user = '',
    this.server = '',
    this.service_name = '',
  });

  factory Library.fromJson(Map<String, dynamic> json) {
    return Library(name: json['name'],
        path: json['path'],
        hidden: json['hidden'],
        connect_type: json['connect_type'],
        user: json['user'] ?? '',
        server: json['server'] ?? '',
        service_name: json['service_name'] ?? '',
    );
  }
}