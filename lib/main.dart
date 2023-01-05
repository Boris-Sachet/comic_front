import 'package:comic_front/views/library_selector/library_selector.dart';
import 'package:flutter/material.dart';
import 'services/service_library.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'views/library_folder/library_folder.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue).copyWith(secondary: Colors.white, brightness: Brightness.light),
      ),
      dark: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.red).copyWith(secondary: Colors.amber, brightness: Brightness.dark),
      ),
      initial: AdaptiveThemeMode.dark,
      builder: (theme, darkTheme) => MaterialApp(
        title: 'Comic Reader',
        theme: theme,
        darkTheme: darkTheme,
        home: const MyHomePage(title: 'Comic Reader Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ServiceLibrary.getCurrentLibrary(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        // Check if there's already a selected library and get it from the backend and redirect to it
        // Or else redirect to the library selector
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()),);
          }
          if (snapshot.data == null) {
            return const LibrarySelector();
          } else {
            return LibraryFolder(library: snapshot.data!);
          }
        } else {
          return const Center(child: CircularProgressIndicator(),);
        }
      },
    );
  }
}