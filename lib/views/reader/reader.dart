import 'package:comic_front/views/reader/widgets/reader_gallery.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../model/file.dart';

class Reader extends StatefulWidget {
  const Reader({super.key, required this.file});
  final File file;

  @override
  ReaderState createState() => ReaderState();

}

class ReaderState extends State<Reader> {
  late bool _showInterface;
  Axis _axis = Axis.horizontal;
  Icon _icon = const Icon(Icons.stay_current_landscape);

  @override
  void initState() {
    _showInterface = false;
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive, overlays: [SystemUiOverlay.bottom]); // To hide android status bar
    super.initState();
  }

  @override
  void dispose(){
    super.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);  // to re-show bars
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: !_showInterface ? null : buildAppBar(),
      body: widget.file.pagesCount > 0 ? ReaderGallery(file: widget.file, axis: _axis, onTap: onTapAction) : Center(child: Container(),),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Text(
        widget.file.name,
        style: const TextStyle(fontSize: 14),
      ),
      automaticallyImplyLeading: false,
      actions: [
        IconButton(
          icon: _icon,
          onPressed: () {
            setState(() {switchScrollDirection();});
          },
        )
      ],
      // backgroundColor: Colors.black,
    );
  }

  void onTapAction() {
    setState(() {
      _showInterface = !_showInterface;
    });
    if (_showInterface){
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive, overlays: [SystemUiOverlay.bottom]);
    }
  }

  void switchScrollDirection(){
    if (_axis == Axis.vertical) {
      _axis = Axis.horizontal;
      _icon = const Icon(Icons.stay_current_landscape);
    } else {
      _axis = Axis.vertical;
      _icon = const Icon(Icons.stay_current_portrait);
    }
  }
}