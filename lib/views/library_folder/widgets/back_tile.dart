import 'package:flutter/material.dart';

import '../../../model/directory.dart';
import '../../../model/library.dart';
import '../library_folder.dart';

/// Create a List tile for a going back to the parent directory
class BackTile extends StatelessWidget {
  final Library library;
  final Directory directory;

  const BackTile({
    super.key,
    required this.library,
    required this.directory,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueGrey,
      child: ListTile(
        leading: const Icon(Icons.arrow_back),
        title: const Text(".."),
        // subtitle: Text(directory.path),
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => LibraryFolder(library: library, directory: directory.parent,)
            )
        ),
      ),
    );
  }
}