import 'package:comic_front/services/service_settings.dart';
import 'package:flutter/material.dart';

import '../library_selector/library_selector.dart';

class GlobalDrawer extends StatelessWidget {
  const GlobalDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
              child: ListTile(
                title: const Text("Comic reader app"),
                subtitle: Text(ServiceSettings.currentLibrary?.name ?? ''),
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