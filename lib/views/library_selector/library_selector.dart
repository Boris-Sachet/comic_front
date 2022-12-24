import 'package:comic_front/views/library_selector/widgets/libraries_list.dart';
import 'package:flutter/material.dart';
import '../../services/service_library.dart';

class LibrarySelector extends StatefulWidget {
  const LibrarySelector({super.key});

  @override
  LibrarySelectorState createState() => LibrarySelectorState();
}

class LibrarySelectorState extends State<LibrarySelector> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Library'),
      ),
      body: LibraryList(librariesFuture: ServiceLibrary().getLibraries())
    );
  }
}
