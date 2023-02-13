import 'dart:js';

import 'package:comic_front/services/service_file.dart';
import 'package:flutter/material.dart';

import '../../../model/file.dart';

class FileOptionBar extends StatelessWidget {
  final List<File> selectedFiles;
  final Function onFileModified;

  const FileOptionBar({
    super.key,
    required this.selectedFiles,
    required this.onFileModified
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          IconButton(
            icon: selectedFiles[0].read ? const Icon(Icons.remove_red_eye) : const Icon(Icons.remove_red_eye_outlined),
            onPressed: toggleFileReadStatus,
          ),
          IconButton(icon: const Icon(Icons.info), onPressed: () {},),
          PopupMenuButton(
            icon: const Icon(Icons.more_horiz),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                child: TextButton(
                  onPressed: regenSelectedFiles,
                  child: const Text("Refresh file in database"),
                ),
              ),
              // PopupMenuItem(
              //   value: 2,
              //   child: Text("Instagram"),
              // ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> toggleFileReadStatus() async {
    if (selectedFiles[0].read) {
      for (var file in selectedFiles) {
        await ServiceFile.setCurrentPage(file, 0);
      }
    } else {
      for (var file in selectedFiles) {
        await ServiceFile.setCurrentPage(file, file.pagesCount - 1);
      }
    }
    onFileModified();
  }

  Future<void> regenSelectedFiles() async {
    for (var file in selectedFiles) {
      await ServiceFile.regenFileData(file);
    }
    selectedFiles.clear();
    onFileModified();
  }
}