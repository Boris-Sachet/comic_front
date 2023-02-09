import 'package:comic_front/services/service_settings.dart';
import 'package:comic_front/views/library_selector/library_selector.dart';
import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'views/library_folder/library_folder.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ServiceSettings.init();
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
      initial: ServiceSettings.darkMode ? AdaptiveThemeMode.dark : AdaptiveThemeMode.light,
      builder: (theme, darkTheme) => MaterialApp(
        title: 'Comic Reader',
        theme: theme,
        darkTheme: darkTheme,
        debugShowCheckedModeBanner: false,
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
    if (ServiceSettings.apiUrl == null) {
      return const Scaffold(body: Center(child: Text('No api url configured')),);
    }
    return ServiceSettings.currentLibrary != null ? LibraryFolder(library: ServiceSettings.currentLibrary!) : const LibrarySelector();
    // return FutureBuilder(
    //   future: ServiceSettings.init(),
    //   builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
    //     // Check if there's already a selected library and get it from the backend and redirect to it
    //     // Or else redirect to the library selector
    //     if (snapshot.connectionState == ConnectionState.done) {
    //       if (snapshot.hasError) {
    //         if (ServiceSettings.apiUrl == null) {
    //           return const Scaffold(body: Center(child: Text('No api url configured')),);
    //         }
    //         return Scaffold(body: Center(child: Text(snapshot.error.toString()),),);
    //       }
    //       return ServiceSettings.currentLibrary != null ? LibraryFolder(library: ServiceSettings.currentLibrary!) : const LibrarySelector();
    //     } else {
    //       return const Center(child: CircularProgressIndicator(),);
    //     }
    //   },
    // );
  }
}