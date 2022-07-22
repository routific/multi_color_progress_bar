library multi_color_progress_bar;
import 'package:flutter/material.dart';
import 'package:multi_color_progress_bar/progress_segment.dart';

class MultiColorProgressBar extends StatelessWidget {
  final List<ProgressSegment> progressSegments;
  final int totalProgress;
  final Color emptyColor;
  final double edgeBorderRadius;
  final double insideBorderRadius;
  final double height;
  final double progressGap;

  const MultiColorProgressBar(
      this.progressSegments,
      this.totalProgress,
      {
        Key? key,
        this.edgeBorderRadius = 3.0,
        this.insideBorderRadius = 1.0,
        this.emptyColor = const Color.fromRGBO(234, 236, 240, 1),
        this.height = 4.0,
        this.progressGap = 1.0,
      })
      : super(key: key);

  int get _totalProgressCompleted => progressSegments.fold<int>(0, (sum, segment) => sum + segment.value);
  bool get _maxProgress => totalProgress == _totalProgressCompleted;
  double get _maxEdgeBorderRadius => _maxProgress ? edgeBorderRadius : insideBorderRadius;
  double get _emptyEdgeBorderRadius => progressSegments.isEmpty || _totalProgressCompleted == 0 ? edgeBorderRadius : insideBorderRadius;

  List<Flexible> progressParts() {
    List<Flexible> segments = [];
    if (progressSegments.isNotEmpty && _totalProgressCompleted > 0) {
      Flexible firstSegment = Flexible(
          flex: progressSegments.first.value,
          child: Container(
            margin: EdgeInsets.only(right: progressGap),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(edgeBorderRadius),
                    bottomLeft: Radius.circular(edgeBorderRadius),
                    bottomRight: Radius.circular(_maxEdgeBorderRadius),
                    topRight: Radius.circular(_maxEdgeBorderRadius)),
                color: progressSegments.first.color),
          ));
      segments.add(firstSegment);
    }
    Flexible lastSegment = Flexible(
        flex: totalProgress - _totalProgressCompleted,
        child: Container(
          margin: EdgeInsets.only(right: progressGap),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(_emptyEdgeBorderRadius),
                  bottomLeft: Radius.circular(_emptyEdgeBorderRadius),
                  bottomRight: Radius.circular(insideBorderRadius),
                  topRight: Radius.circular(insideBorderRadius)),
              color: emptyColor),
        ));

    if (progressSegments.length > 1) {
      List<ProgressSegment> middleSegments = progressSegments.sublist(1);
      for (var segment in middleSegments) {
        Flexible progressSegmentWidget = Flexible(
            flex: segment.value,
            child: Container(
              margin: EdgeInsets.only(right: progressGap),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(insideBorderRadius),
                  color: segment.color),
            ));
        segments.add(progressSegmentWidget);
      }}
    segments.add(lastSegment);
    return segments;
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return SizedBox(
      height: height,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: progressParts()
      ),
    );
  }
}

