import 'package:flutter/material.dart';

class PanelContainer extends StatelessWidget {
  final double maxWidth;
  final double maxHeight;
  final Widget panel;
  final double leftOffset;
  final double ratio;
  final bool rightSide;
  const PanelContainer(
      {Key? key,
      required this.maxWidth,
      required this.maxHeight,
      required this.panel,
      required this.leftOffset,
      required this.ratio,
      required this.rightSide})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: leftOffset),
      child: SizedBox(
        width: maxWidth * ratio,
        height: maxHeight,
        // decoration:
        //     BoxDecoration(border: Border.all(color: Colors.red, width: 1)),
        child: Align(
          alignment: Alignment
              .center, // rightSide ? Alignment.centerRight : Alignment.centerLeft,
          child: SizedBox(
            width: maxWidth * ratio,
            height: maxHeight * ratio,
            child: panel,
          ),
        ),
      ),
    );
  }
}
