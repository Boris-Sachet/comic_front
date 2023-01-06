import 'package:comic_front/views/library_folder/widgets/back_tile.dart';
import 'package:comic_front/views/library_folder/widgets/directory_list_tile.dart';
import 'package:comic_front/views/library_folder/widgets/file_grid_tile.dart';
import 'package:comic_front/views/library_folder/widgets/folder_app_bar.dart';
import 'package:flutter/material.dart';
import '../../model/directory.dart';
import '../../model/file.dart';
import '../../model/library.dart';
import '../../services/service_library.dart';
import '../drawer/global_drawer.dart';

class LibraryFolder extends StatefulWidget {
  final Library library;
  final Directory directory;

  const LibraryFolder({super.key, required this.library, this.directory = Directory.root});

  @override
  LibraryFolderState createState() => LibraryFolderState();
}

class LibraryFolderState extends State<LibraryFolder> {
  late Future<List> futureContent = ServiceLibrary.getLibraryContent(widget.library, widget.directory.path);

  @override
  void initState() {
    super.initState();
  }
  
  /// Generate list view of directories
  List<Widget> generateDirectoryList (List<Directory> directories) {
    // To still display the back button on directories with no subfolders
    int itemCount = !widget.directory.isRoot() && directories.isEmpty ? 1 : directories.length;
    return [ListView.builder(physics: const ScrollPhysics(),
      shrinkWrap: true,
      itemCount: itemCount,
      itemBuilder: (BuildContext context, int index) {
        int backIndex = 0;
        if (index == 0 && !widget.directory.isRoot()) {
          backIndex = 1;
          return BackTile(library: widget.library, directory: widget.directory);
        }
        return DirectoryListTile(
          library: widget.library,
          directory: directories[index - backIndex],
        );
      }
    )];
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false, // Disable back button
        child: Scaffold(
          drawer: const GlobalDrawer(),
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: LibraryAppBar(
              library: widget.library,
              directory: widget.directory,
            ),
          ),

          body: RefreshIndicator(
            onRefresh: () async { setState(() {}); },
            child: FutureBuilder<List>(
              future: futureContent,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final List<Directory> directories = snapshot.data![0] as List<Directory>;
                  final List<File> files = snapshot.data![1] as List<File>;
                  if (files.isEmpty && directories.isEmpty) return const Center(child: Text("Library is empty"),);

                  return CustomScrollView(
                      slivers: <Widget>[
                        SliverList(
                          delegate: SliverChildListDelegate(
                              generateDirectoryList(directories)
                          ),
                        ),
                        SliverGrid(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1.0,
                          ),
                          delegate: SliverChildBuilderDelegate(
                                (context, index) {
                              return FileGridTile(library: widget.library, file: files[index]);
                            },
                            childCount: files.length,
                          ),
                        )
                      ]
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                return const Center(child: CircularProgressIndicator(),);
              },
            ),
          ),
        ),
    );
  }
}