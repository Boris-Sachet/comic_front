import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:comic_front/services/service_file.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:photo_view/photo_view.dart';

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
      body: widget.file.pagesCount > 0 ? buildCarouselSlider() : Center(child: Container(),),
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

  CarouselSlider buildCarouselSlider() {
    final double height = MediaQuery.of(context).size.height;
    return CarouselSlider.builder(
        itemCount: widget.file.pagesCount,
        itemBuilder: (context, index, pageViewIndex) => Center(
          child: PhotoView(
            imageProvider: CachedNetworkImageProvider(widget.file.pagesUrl[index]),
            onTapDown: (context, details, controllerValue) {
              // Hide app bar on scroll down
              setState(() {_showAppBar = !_showAppBar;});
            },
            backgroundDecoration: const BoxDecoration(color: Colors.black),
          ),
        ),
        options: CarouselOptions(
          autoPlay: false,
          enableInfiniteScroll: false,
          viewportFraction: 1.0,
          enlargeCenterPage: false,
          height: height,
          clipBehavior: Clip.hardEdge,
          pageSnapping: true,
          scrollDirection: _axis,
          initialPage: widget.file.currentPage,
          scrollPhysics: const PageScrollPhysics(),
          onPageChanged: onPageChange,
        )
    );
  }

  void onPageChange(int index, CarouselPageChangedReason changeReason) {
    widget.file.currentPage = index;
    prefetchNextImage(index);
    ServiceFile.setCurrentPage(widget.file, index);
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

  void prefetchNextImage(int index){
    if (index < widget.file.pagesCount - 1) {
      DefaultCacheManager().downloadFile(widget.file.pagesUrl[index+1]);
    }
  }
}