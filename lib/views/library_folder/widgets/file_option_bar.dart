import 'package:comic_front/services/service_file.dart';
import 'package:flutter/material.dart';

import '../../../model/file.dart';

class FileOptionBar extends StatelessWidget {
  final File file;
  final Function onFileModified;

  const FileOptionBar({
    super.key,
    required this.file,
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
            icon: file.read ? const Icon(Icons.remove_red_eye) : const Icon(Icons.remove_red_eye_outlined),
            onPressed: toggleFileReadStatus,
          ),
          IconButton(icon: const Icon(Icons.info), onPressed: () {},),
          // PopupMenuButton(
          //   icon: Icon(Icons.share),
          //   itemBuilder: (context) => [
          //     PopupMenuItem(
          //       value: 1,
          //       child: Text("Facebook"),
          //     ),
          //     PopupMenuItem(
          //       value: 2,
          //       child: Text("Instagram"),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }

  void toggleFileReadStatus(){
    if (file.read) {
      file.currentPage == 0;
      ServiceFile.setCurrentPage(file, 0).then((value) => {
        onFileModified(value)
      });
    } else {
      file.currentPage == file.pagesCount - 1;
      ServiceFile.setCurrentPage(file, file.pagesCount - 1).then((value) =>
      {
        onFileModified(value)
      });
    }
  }

}