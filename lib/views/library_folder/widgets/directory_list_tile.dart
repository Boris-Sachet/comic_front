import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../model/directory.dart';
import '../../../model/library.dart';
import '../library_folder.dart';

/// Create a List tile for a Directory object
class DirectoryListTile extends StatelessWidget {
  final Library library;
  final Directory directory;
  final String placeholder;

  const DirectoryListTile({
    super.key,
    required this.library,
    required this.directory,
    this.placeholder = "assets/icons/comic.png",
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueGrey,
      child: ListTile(
        // leading: const Icon(Icons.folder),
        leading: directory.thumbnailId != null ? leadingImage() : const Icon(Icons.folder),
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

  Widget leadingImage(){
    return ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 40,
          minWidth: 40,
        ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4.0),
        child: CachedNetworkImage(
          imageUrl: directory.thumbnailUrl,
          placeholder: (context, url) => Image.asset(placeholder),
          errorWidget: (context, url, error) => Image.asset(placeholder),
        ),
      )
    );
  }
}