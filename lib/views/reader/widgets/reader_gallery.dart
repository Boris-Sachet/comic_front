import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../../../model/file.dart';
import '../../../services/service_file.dart';

class ReaderGallery extends StatelessWidget {
  final File file;
  final Function? onTap;
  final Axis axis;

  const ReaderGallery({
    super.key,
    required this.file,
    required this.axis,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    PageController controller = PageController(initialPage: file.currentPage, keepPage: false);
    return PhotoViewGallery.builder(
      itemCount: file.pagesCount,
      builder: (context, index) {
        return PhotoViewGalleryPageOptions(
          imageProvider: CachedNetworkImageProvider(file.pagesUrl[index]),
          minScale: PhotoViewComputedScale.contained * 1,
          maxScale: PhotoViewComputedScale.contained * 4,
          onTapDown: (context, details, controllerValue) {
            // Set parent state and execute whatever the parent needs to do
            onTap != null ? onTap!() : null;
          },
        );
      },
      scrollDirection: axis,
      pageController: controller,
      onPageChanged: onPageChange,
      scrollPhysics: const BouncingScrollPhysics(),
      backgroundDecoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
      ),
    );
  }

  void onPageChange(int index) {
    file.currentPage = index;
    prefetchNextImage(index);
    ServiceFile.setCurrentPage(file, index);
  }

  void prefetchNextImage(int index){
    if (index < file.pagesCount - 1) {
      DefaultCacheManager().downloadFile(file.pagesUrl[index+1]);
    }
  }
}