import 'package:comic_front/views/library_folder/widgets/folder_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
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
  GridTile generateFileGridTile(BuildContext context, Library library, File file) {
    return GridTile(
      footer: Container(
        // alignment: AlignmentGeometry.,
        color: Colors.black54.withOpacity(0.2),
        // height: 23,
        width: double.maxFinite,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                // Title
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 1, right: 1),
                        child: Text(
                          file.name,
                          style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 0.8),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          softWrap: false,
                        ),
                      )
                    ),
                  ],
                ),
                // Reading progress
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    LinearPercentIndicator(
                      width: constraints.maxWidth,
                      lineHeight: 7.0,
                      percent: file.currentPage / file.pagesCount,
                      progressColor: Colors.orange,
                      backgroundColor: Colors.grey.withOpacity(0.2),
                      center: Text(
                        "${file.currentPage}/${file.pagesCount}",
                        style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 0.5),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        )
      ),
      child: const Text("Placeholder"),
    );
  }

  /// Create a List tile for a going back to the parent directory
  Container generateBackTile(BuildContext context, Library library, Directory directory) {
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
          return generateBackTile(context, widget.library, widget.directory);
        }
        return generateDirectoryTile(context, widget.library, directories[index - backIndex]);
      }
    )];
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false, // Disable back button
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: LibraryAppBar(
              library: widget.library,
              directory: widget.directory,
            ),
          ),

          body: FutureBuilder<List>(
            future: futureContent,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final List<Directory> directories = snapshot.data![0] as List<Directory>;
                final List<File> files = snapshot.data![1] as List<File>;
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
                          return generateFileGridTile(context, widget.library, files[index]);
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
    );
  }
}