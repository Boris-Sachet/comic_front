import 'package:comic_front/model/library.dart';
import 'package:comic_front/services/service_library.dart';
import 'package:flutter/material.dart';

import '../library_selector/library_selector.dart';

class GlobalDrawer extends StatelessWidget {
  const GlobalDrawer({
    super.key,
  });

  FutureBuilder<Library?> displayCurrentLibraryName() {
    return FutureBuilder(
      future: ServiceLibrary.getCurrentLibrary(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          if (snapshot.data == null) {
            return const Text("");
          } else {
            return Text(snapshot.data!.name);
          }
        } else {
          return const Text("");
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
              child: ListTile(
                title: const Text("Comic reader app"),
                subtitle: displayCurrentLibraryName(),
              )
          ),
          Expanded(child: ListView(children: [
            Card(child: ListTile(
              title: const Text("Select library"),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const LibrarySelector()));
              },
            ),),
          ],)),
        ],
      ),
    );
  }
}