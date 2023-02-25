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
  final double borderRadius = 5.0;

  const DirectoryListTile({
    super.key,
    required this.library,
    required this.directory,
    this.placeholder = "assets/icons/comic.png",
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8.0,
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius)
      ),
      color: Colors.blueGrey,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
        leading: leadingImage(),
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
    return Container(
        constraints: const BoxConstraints(
          maxWidth: 55,
          minWidth: 55,
        ),
      padding: const EdgeInsets.only(right: 12.0),
      decoration: const BoxDecoration(
        border: Border(
          right: BorderSide(width: 1.0, color: Colors.white24)
        )
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4.0),
        child: directory.thumbnailId != null ? CachedNetworkImage(
          imageUrl: directory.thumbnailUrl,
          placeholder: (context, url) => Image.asset(placeholder),
          errorWidget: (context, url, error) => Image.asset(placeholder),
        ): const Icon(Icons.folder),
      )
    );
  }
}