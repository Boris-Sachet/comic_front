import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

import '../../model/file.dart';

class Reader extends StatefulWidget {
  const Reader({super.key, required this.file});
  final File file;

  @override
  _ReaderState createState() => _ReaderState();

}

class _ReaderState extends State<Reader> {
  late bool _showAppBar;
  Axis _axis = Axis.vertical;
  Icon _icon = Icon(Icons.stay_current_portrait);

  @override
  void initState() {
    _showAppBar = true;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: !_showAppBar ? null : AppBar(
        title: Text(
          widget.file.name,
          style: const TextStyle(fontSize: 14),
        ),
        actions: [
          IconButton(
            icon: _icon,
            onPressed: () {
              setState(() {
                if (_axis == Axis.vertical) {
                  _axis = Axis.horizontal;
                  _icon = const Icon(Icons.stay_current_landscape);
                } else {
                  _axis = Axis.vertical;
                  _icon = const Icon(Icons.stay_current_portrait);
                }
              });
            },
          )
        ],
        // backgroundColor: Colors.black,
      ),
      body: widget.file.pagesCount > 0 ? CustomScrollView(
        scrollDirection: _axis,
        slivers: [
          SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: PhotoView(
                          imageProvider: CachedNetworkImageProvider(widget.file.pagesUrl[index]),
                          onTapDown: (context, details, controllerValue) {
                                // Hide app bar on scroll down
                                setState(() {_showAppBar = !_showAppBar;});
                              },
                          onTapUp: (context, details, controllerValue) {
                            // Show app bar on scroll down
                            setState(() {_showAppBar = !_showAppBar;});
                          },
                          backgroundDecoration: const BoxDecoration(color: Colors.black),
                        ),
                      ),
                      Positioned(
                        right: -1,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "$index / ${widget.file.pagesCount}",
                            style: const TextStyle(color: Colors.white),
                          )
                        )
                      )
                    ],
                  ),
                );
              },
              childCount: widget.file.pagesCount
              ),
          )
        ],
      ) : Center(child: Container(),),
    );
  }
}