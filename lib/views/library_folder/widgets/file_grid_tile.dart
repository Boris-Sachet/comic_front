import 'package:cached_network_image/cached_network_image.dart';
import 'package:comic_front/views/reader/reader.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../../model/file.dart';
import '../../../model/library.dart';

/// Create a GridList tile for a File object
class FileGridTile extends StatefulWidget {
  final Library library;
  final File file;
  final List<File> selectedFiles;
  final Color infoBackgroundColor;
  final Color infoBackgroundSelectedColor;
  final double infoBackgroundColorOpacity;
  final double titlePadding;
  final double titleFontSizeFactor;
  final int titleMaxLines;
  final double progressLineHeight;
  final Color progressLineColor;
  final Color progressLineReadColor;
  final Color progressLineBgColor;
  final double progressLineBgColorOpacity;
  final double progressLineFontSizeFactor;
  final String placeholder;
  final Function select;
  final Function unselect;

  const FileGridTile({
    super.key,
    required this.library,
    required this.file,
    required this.selectedFiles,
    this.infoBackgroundColor = Colors.black54,
    this.infoBackgroundSelectedColor = Colors.orange,
    this.infoBackgroundColorOpacity = 0.7,
    this.titlePadding = 1,
    this.titleFontSizeFactor = 0.8,
    this.titleMaxLines = 2,
    this.progressLineHeight = 7.0,
    this.progressLineColor = Colors.orange,
    this.progressLineReadColor = Colors.green,
    this.progressLineBgColor = Colors.grey,
    this.progressLineBgColorOpacity = 0.2,
    this.progressLineFontSizeFactor = 0.5,
    this.placeholder = "assets/icons/comic.png",
    required this.select,
    required this.unselect,
  });

  @override
  FileGridTileState createState() => FileGridTileState();
}

class FileGridTileState extends State<FileGridTile>{
  bool isSelected = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GridTile(
        footer: Container(
            color: widget.selectedFiles.contains(widget.file) ? widget.infoBackgroundSelectedColor.withOpacity(widget.infoBackgroundColorOpacity) : widget.infoBackgroundColor.withOpacity(widget.infoBackgroundColorOpacity),
            width: double.maxFinite,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Column(
                  children: [
                    // Title
                    titleRow(context, constraints, widget.file),
                    // Reading progress
                    progressRow(context, constraints, widget.file),
                  ],
                );
              },
            )
        ),
        child: InkWell(
          onTap: onTapAction,
          onLongPress: onLongPressAction,
          child: CachedNetworkImage(
            imageUrl: widget.file.coverUrl,
            placeholder: (context, url) => Image.asset(widget.placeholder),
            errorWidget: (context, url, error) => Image.asset(widget.placeholder),
          ),
        )
    );
  }

  /// Select the file
  void onLongPressAction() {
    if (!widget.selectedFiles.contains(widget.file)){
      widget.select(widget.file);
    }
  }

  /// If file is selected, unselect it. Else if there is already a file selected select it. Else open it in the reader
  void onTapAction() {
    if (widget.selectedFiles.contains(widget.file)){
      widget.unselect(widget.file);
    } else if (widget.selectedFiles.isNotEmpty) {
      widget.select(widget.file);
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Reader(file: widget.file)));
    }
  }

  /// Generate a row for the title
  Row titleRow(BuildContext context, BoxConstraints constraints, File file) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: widget.titlePadding, right: widget.titlePadding),
              child: Text(
                file.name,
                style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: widget.titleFontSizeFactor),
                overflow: TextOverflow.ellipsis,
                maxLines: widget.titleMaxLines,
                softWrap: false,
              ),
            )
        ),
      ],
    );
  }

  /// Generate a row for the progress bar
  Row progressRow(BuildContext context, BoxConstraints constraints, File file) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        LinearPercentIndicator(
          width: constraints.maxWidth,
          lineHeight: widget.progressLineHeight,
          percent: file.currentPage / (file.pagesCount - 1),
          progressColor: file.read ? widget.progressLineReadColor : widget.progressLineColor,
          backgroundColor: widget.progressLineBgColor.withOpacity(widget.progressLineBgColorOpacity),
          center: Text(
            file.currentPage == 0 ? "${file.pagesCount}" : "${file.currentPage + 1}/${file.pagesCount}",
            style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: widget.progressLineFontSizeFactor),
          ),
        ),
      ],
    );
  }
}