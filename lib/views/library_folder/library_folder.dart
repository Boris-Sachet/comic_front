import 'package:flutter/material.dart';
import '../../model/directory.dart';
import '../../model/file.dart';
import '../../model/library.dart';
import '../../services/service_library.dart';

class LibraryFolder extends StatefulWidget {
  final Library library;
  final Directory directory;

  const LibraryFolder({super.key, required this.library, this.directory = Directory.root});

  @override
  _LibraryFolderState createState() => _LibraryFolderState();
}

class _LibraryFolderState extends State<LibraryFolder> {
  late Future<List> futureContent;

  @override
  void initState() {
    super.initState();
    futureContent = ServiceLibrary.getLibraryContent(widget.library.name, widget.directory.path);
  }

  /// Create a List tile for a Directory object
  Container generateDirectoryTile(BuildContext context, Library library, Directory directory) {
    return Container(
      color: Colors.blueGrey,
      child: ListTile(
        leading: const Icon(Icons.folder),
        title: Text(directory.name),
        // subtitle: Text(directory.path),
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => LibraryFolder(library: library, directory: directory,)
            )
        ),
      ),
    );
  }

  /// Create a List tile for a File object
  Container generateFileTile(BuildContext context, Library library, File file) {
    return Container(
      color: Colors.blueAccent,
      child: ListTile(
        leading: const Icon(Icons.file_open),
        title: Text(file.name),
        subtitle: Text("Current page: ${file.currentPage.toString()}"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.library.name} - ${widget.directory.path}'),
      ),
      body: FutureBuilder<List>(
        future: futureContent,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final List<Directory> directories = snapshot.data![0] as List<Directory>;
            final List<File> files = snapshot.data![1] as List<File>;
            return ListView.builder(
              // TODO build a back tile at the top with .. leading to parent folder
              itemCount: directories.length + files.length,
              itemBuilder: (BuildContext context, int index) {
                if (index < directories.length) {
                  return generateDirectoryTile(context, widget.library, directories[index]);
                }
                return generateFileTile(context, widget.library, files[index - directories.length]);
              },
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return const Center(child: CircularProgressIndicator(),);
        },
      ),
    );
  }
}