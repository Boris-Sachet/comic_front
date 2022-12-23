import 'package:flutter/material.dart';
import 'services/service_library.dart';
import 'model/library.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'views/library_selector/widgets/library_dropdown.dart';


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
  late Future<Library> futureLibrary;

  @override
  void initState(){
    super.initState();
    futureLibrary = ServiceLibrary().getLibrary();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            LibraryDropdown(
              librariesFuture: ServiceLibrary().getLibraries(),
              onChanged: (library) {
                // Do something with the selected library
              },
            ),
          ],
        ),
      ),
    );
  }
}
