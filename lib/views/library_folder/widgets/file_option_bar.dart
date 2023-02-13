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
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {},
            tooltip: "Refresh file in database",
          ),
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

  // /// This method only exist to allow calling b
  // void readButtonPressed() {
  //   toggleFileReadStatus().then((value) => onFileModified());
  // }

  Future<void> toggleFileReadStatus() async {
    int index = 0;
    if (selectedFiles[0].read) {
      for (var file in selectedFiles) {
        selectedFiles[index] = await ServiceFile.setCurrentPage(file, 0);
        index++;
      }
    } else {
      for (var file in selectedFiles) {
        selectedFiles[index] = await ServiceFile.setCurrentPage(file, file.pagesCount - 1);
        index++;
      }
    }
    onFileModified();
  }

  // void regenFile(){
  //   FutureBuilder(
  //     future: ServiceFile.regenFileData(file),
  //       builder: (context, snapshot) {
  //         if (snapshot.connectionState == ConnectionState.done) {
  //           if (snapshot.hasData){
  //             file = snapshot.data;
  //           }
  //         }
  //       }
  //   );
  // }

}