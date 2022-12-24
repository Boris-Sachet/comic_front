import 'package:flutter/material.dart';
import '../../../model/library.dart';
import '../../library_folder/library_folder.dart';

class LibraryList extends StatelessWidget {
  final Future<List<Library>> librariesFuture;
  const LibraryList({super.key, required this.librariesFuture,});

  Container generateTile(BuildContext context, Library library) {
    return Container(
        color: Colors.blueGrey,
        child: ListTile(
          leading: const Icon(Icons.library_books),
          title: Text(library.name),
          subtitle: Text(library.path),
          trailing: const Icon(Icons.keyboard_arrow_right),
          onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LibraryFolder(library: library,),
                ),
              ),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Library>>(
      future: librariesFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final List<Library> libraries = snapshot.data ?? [];
          if (libraries.isNotEmpty) {
            return ListView.builder(
              itemCount: libraries.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (BuildContext context, int index) {
                return generateTile(context, libraries[index]);
              },
            );
          } else {
            return const Text('No libraries');
          }
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return const Center(child: CircularProgressIndicator(),);
      },
    );
  }
}