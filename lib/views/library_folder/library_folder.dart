import 'package:comic_front/views/library_folder/widgets/back_tile.dart';
import 'package:comic_front/views/library_folder/widgets/directory_list_tile.dart';
import 'package:comic_front/views/library_folder/widgets/file_grid_tile.dart';
import 'package:comic_front/views/library_folder/widgets/file_option_bar.dart';
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
  final List<File> selectedFiles = [];

  @override
  void initState() {
    super.initState();
    futureContent = ServiceLibrary.getLibraryContent(widget.library, widget.directory.path);
  }
  
  /// Generate list view of directories
  List<Widget> generateDirectoryList (List<Directory> directories) {
    int backIndex = 0;
    int itemCount = directories.length;
    if (!widget.directory.isRoot()) {
      // If folder is not root back button must be displayed
      itemCount = directories.length + 1;
    }
    return [ListView.builder(physics: const ScrollPhysics(),
      shrinkWrap: true,
      itemCount: itemCount,
      itemBuilder: (BuildContext context, int index) {
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
        onWillPop: () async => true, // Disable back button
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
            onRefresh: () async { setState(() {
              futureContent = ServiceLibrary.getLibraryContent(widget.library, widget.directory.path);
            }); },
            child: FutureBuilder<List>(
              future: futureContent,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final List<Directory> directories = snapshot.data![0] as List<Directory>;
                  final List<File> files = snapshot.data![1] as List<File>;
                  if (files.isEmpty && directories.isEmpty) return const Center(child: Text("Library is empty"),);

                  updateSelectedItems(files);

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
                              return FileGridTile(
                                  library: widget.library,
                                  file: files[index],
                                  selectedFiles: selectedFiles,
                                  select: selectFile,
                                  unselect: unselectFile,
                              );
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
          bottomNavigationBar: selectedFiles.isEmpty ? null : FileOptionBar(selectedFiles: selectedFiles, onFileModified: modifiedFile,),
        ),
    );
  }

  /// Select file callback
  void selectFile(File file){
    setState(() {
      selectedFiles.add(file);
    });
  }

  /// Unselect file callback
  void unselectFile(File file){
    setState(() {
      selectedFiles.remove(file);
    });
  }

  /// Update the list of selected files with the equivalent new objects after a
  void updateSelectedItems(List<File> files) {
    for (var i = 0; i < selectedFiles.length; i++) {
      for (var file in files) {
        if (selectedFiles[i].id == file.id) {
          selectedFiles[i] = file;
          break;
        }
      }
    }
  }

  /// Callback to be called after a file has been modified, update the view
  void modifiedFile(){
    setState(() {
      futureContent = ServiceLibrary.getLibraryContent(widget.library, widget.directory.path);
    });
  }
}