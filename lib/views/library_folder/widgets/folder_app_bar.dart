import 'package:flutter/material.dart';
import '../../../model/file.dart';
import '../../../model/library.dart';
import '../../../model/directory.dart';

class LibraryAppBar extends StatelessWidget {
  final Library library;
  final Directory directory;
  final List<File> selectedFiles;
  final VoidCallback selectAll;
  final VoidCallback unselectAll;

  const LibraryAppBar({
    super.key,
    required this.library,
    required this.directory,
    required this.selectedFiles,
    required this.selectAll,
    required this.unselectAll,
  });

  /// Generate the appbar title accordingly to current folder
  Text appBarTitle(Library library, Directory directory) {
    if (directory.isRoot()) {
      return Text(library.name);
    } else {
      return Text(directory.name);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      // automaticallyImplyLeading: true,
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          appBarTitle(library, directory),
          if (!directory.isRoot() || selectedFiles.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                selectedFiles.isNotEmpty ? "${selectedFiles.length} files selected" : directory.path,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
            )
        ],
      ),
      actions: selectActions(),
    );
  }

  /// Action buttons displayed when a file is selected
  List<Widget>? selectActions() {
    if (selectedFiles.isNotEmpty) {
      return [
        IconButton(onPressed: selectAll, icon: const Icon(Icons.select_all), tooltip: "Select all files",),
        IconButton(onPressed: unselectAll, icon: const Icon(Icons.deselect), tooltip: "Deselect all files",)
      ];
    }
    return null;
  }
}

