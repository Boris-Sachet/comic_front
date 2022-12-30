import 'package:flutter/material.dart';
import '../../../model/library.dart';
import '../../../model/directory.dart';

class LibraryAppBar extends StatelessWidget {
  final Library library;
  final Directory directory;

  const LibraryAppBar({
    super.key,
    required this.library,
    required this.directory,
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
      automaticallyImplyLeading: false,
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          appBarTitle(library, directory),
          if (!directory.isRoot())
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                directory.path,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
            )
        ],
      ),
    );
  }
}

