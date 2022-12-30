import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../../model/file.dart';
import '../../../services/service_library.dart';

/// Create a GridList tile for a File object
class FileGridTile extends StatelessWidget {
  final File file;
  final Color infoBackgroundColor;
  final double infoBackgroundColorOpacity;
  final double titlePadding;
  final double titleFontSizeFactor;
  final int titleMaxLines;
  final double progressLineHeight;
  final Color progressLineColor;
  final Color progressLineBgColor;
  final double progressLineBgColorOpacity;
  final double progressLineFontSizeFactor;


  const FileGridTile({
    super.key,
    required this.file,
    this.infoBackgroundColor = Colors.black54,
    this.infoBackgroundColorOpacity = 0.7,
    this.titlePadding = 1,
    this.titleFontSizeFactor = 0.8,
    this.titleMaxLines = 2,
    this.progressLineHeight = 7.0,
    this.progressLineColor = Colors.orange,
    this.progressLineBgColor = Colors.grey,
    this.progressLineBgColorOpacity = 0.2,
    this.progressLineFontSizeFactor = 0.5,
  });

  /// Generate a row for the title
  Row titleRow(BuildContext context, BoxConstraints constraints, File file) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: titlePadding, right: titlePadding),
              child: Text(
                file.name,
                style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: titleFontSizeFactor),
                overflow: TextOverflow.ellipsis,
                maxLines: titleMaxLines,
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
          lineHeight: progressLineHeight,
          percent: file.currentPage / file.pagesCount,
          progressColor: progressLineColor,
          backgroundColor: progressLineBgColor.withOpacity(progressLineBgColorOpacity),
          center: Text(
            "${file.currentPage}/${file.pagesCount}",
            style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: progressLineFontSizeFactor),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GridTile(
      footer: Container(
          color: infoBackgroundColor.withOpacity(infoBackgroundColorOpacity),
          width: double.maxFinite,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                children: [
                  // Title
                  titleRow(context, constraints, file),
                  // Reading progress
                  progressRow(context, constraints, file),
                ],
              );
            },
          )
      ),
      // child: const Text("Placeholder"),
      child: FadeInImage(
        image: NetworkImage(ServiceLibrary.getFileCoverUrl(file.id)),
        placeholder: const AssetImage("assets/icons/comic.png"),
      ),
    );
  }

}