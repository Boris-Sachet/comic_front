import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:comic_front/services/service_file.dart';
import 'package:comic_front/views/reader/widgets/reader_gallery.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../../model/file.dart';

class Reader extends StatefulWidget {
  const Reader({super.key, required this.file});
  final File file;

  @override
  ReaderState createState() => ReaderState();

}

class ReaderState extends State<Reader> {
  late bool _showAppBar;
  Axis _axis = Axis.horizontal;
  Icon _icon = const Icon(Icons.stay_current_landscape);

  @override
  void initState() {
    _showAppBar = false;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: !_showAppBar ? null : buildAppBar(),
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
      _showAppBar = !_showAppBar;
    });
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