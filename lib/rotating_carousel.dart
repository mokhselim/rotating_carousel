import 'package:flutter/material.dart';
import 'package:rotating_carousel/render.dart';

import 'panel_container.dart';

class RotatingCarousel extends StatefulWidget {
  final double width;
  final double height;
  final List<Widget> panels;
  final double minRatio;
  final double overlapRatio;
  final int animationDurationInMilliseconds;
  const RotatingCarousel({
    Key? key,
    this.minRatio = 0.9,
    this.overlapRatio = 0.1,
    this.animationDurationInMilliseconds = 350,
    required this.width,
    required this.height,
    required this.panels,
  }) : super(key: key);

  @override
  State<RotatingCarousel> createState() => _RotatingCarouselState();
}

class _RotatingCarouselState extends State<RotatingCarousel>
    with TickerProviderStateMixin {
  late int amount;
  bool isRight = true;
  late int middleIndex;
  late double panelMaxWidth;
  late List<double> initOffsets;
  late List<Widget> statefulPanels;
  late List<double> currentOffsets;
  late List<double> initialResizeFactors;
  late List<double> currentResizeFactors;
  late AnimationController _animationController;
  @override
  void initState() {
    super.initState();
    initValues();
  }

  @override
  void didUpdateWidget(RotatingCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    initValues();
  }

  initValues() {
    statefulPanels = widget.panels;
    amount = widget.panels.length;
    middleIndex = ((amount) / 2).ceil() - 1;
    panelMaxWidth = getMaxWidth();
    initResizeDimensions();
    currentResizeFactors = initialResizeFactors;
    initOffsets = initializeOffset(initialResizeFactors);
    _animationController = AnimationController(
        vsync: this,
        duration:
            Duration(milliseconds: widget.animationDurationInMilliseconds));
    currentOffsets = initOffsets;
    _animationController.addListener(() => animate());
  }

  @override
  reassemble() {
    super.reassemble();
    initValues();
  }

  initResizeDimensions() {
    if (amount == 1) {
      initialResizeFactors = [1];
    } else if (amount == 2) {
      initialResizeFactors = [widget.minRatio, 1];
    } else {
      var gap = (1 - widget.minRatio) / (middleIndex);
      assert(gap < widget.minRatio, "Increase your min Factor and hot restart");
      List<double> resizers = List<double>.filled(amount, 1);
      for (var index = middleIndex - 1; index >= 0; index--) {
        resizers[index] = resizers[index + 1] - gap;
      }
      for (var index = middleIndex + 1; index < amount; index++) {
        resizers[index] = resizers[index - 1] - gap;
      }
      initialResizeFactors = resizers;
    }
  }

  double getMaxWidth() {
    return widget.width /
        (((1 - widget.overlapRatio) *
                (((widget.minRatio + 1) * ((amount) / 2)) - 1)) +
            1);
  }

  List<double> initializeOffset(List<double> resizeFactors) {
    List<double> offsets = List<double>.filled(amount, 0);
    offsets[0] = 0;
    for (var amountIndex = 1; amountIndex < amount; amountIndex++) {
      if (amountIndex <= middleIndex) {
        offsets[amountIndex] = offsets[amountIndex - 1] +
            (resizeFactors[amountIndex - 1] *
                panelMaxWidth *
                (1 - widget.overlapRatio));
      } else {
        offsets[amountIndex] = offsets[amountIndex - 1] +
            (resizeFactors[amountIndex - 1] * panelMaxWidth) -
            ((resizeFactors[amountIndex] * panelMaxWidth) *
                widget.overlapRatio);
      }
    }
    return offsets;
  }

  @override
  Widget build(BuildContext context) {
    List<PanelContainer> constrainedWidgets = [];
    for (var panelIndex = 0; panelIndex < amount; panelIndex++) {
      constrainedWidgets.add(PanelContainer(
        maxWidth: panelMaxWidth,
        maxHeight: widget.height,
        panel: statefulPanels[panelIndex],
        leftOffset: currentOffsets[panelIndex],
        ratio: currentResizeFactors[panelIndex],
        rightSide: panelIndex > middleIndex,
      ));
    }
    return GestureDetector(
      onPanUpdate: (details) async {
        setState(() {
          isRight = details.delta.dx > 0;
        });
        await _animationController.forward();
      },
      child: Center(
        child: Container(
          width: widget.width,
          height: widget.height,
          color: Colors.transparent,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Center(
              child: MultiWidgetCardRenderObjectWidget(
                children: rearrange(constrainedWidgets),
              ),
            ),
          ),
        ),
      ),
    );
  }

  animate() {
    var percent = _animationController.value;
    var newOffsets = [];
    var newFactors = [];
    // currentResizeFactors
    for (var index = 0; index < currentOffsets.length; index++) {
      late int next;
      if (isRight) {
        next = (index + 1) % currentOffsets.length;
      } else {
        next = (currentOffsets.length + index - 1) % currentOffsets.length;
      }
      newOffsets.add(((initOffsets[next] - initOffsets[index]) * percent +
              initOffsets[index])
          .abs());
      newFactors.add(
          ((initialResizeFactors[next] - initialResizeFactors[index]) *
                      percent +
                  initialResizeFactors[index])
              .abs());
    }
    // print(newOffsets);
    if (_animationController.isCompleted) {
      _animationController.reset();
      var panelsShiftedLeft = List<dynamic>.filled(currentOffsets.length, null);
      for (var index = 0; index < amount; index++) {
        late int next;
        if (isRight) {
          next = (index + 1) % amount;
        } else {
          next = (amount + index - 1) % amount;
        }
        panelsShiftedLeft[next] = statefulPanels[index];
      }
      setState(() {
        currentOffsets = [...initOffsets];
        statefulPanels = [...panelsShiftedLeft];
        currentResizeFactors = [...initialResizeFactors];
      });
    } else {
      setState(() {
        currentResizeFactors = [...newFactors];
        currentOffsets = [...newOffsets];
      });
    }
  }

  List<Widget> rearrange(List<PanelContainer> panelContainers) {
    List<PanelContainer> rearranged = [];
    for (var currentIndex = 0; currentIndex < middleIndex; currentIndex++) {
      if (isRight) {
        rearranged
            .add(panelContainers[panelContainers.length - 1 - currentIndex]);
        rearranged.add(panelContainers[currentIndex]);
      } else {
        rearranged.add(panelContainers[currentIndex]);
        rearranged
            .add(panelContainers[panelContainers.length - 1 - currentIndex]);
      }
    }
    if (amount % 2 == 0) {
      rearranged.add(panelContainers[middleIndex + 1]);
    }
    return rearranged..add(panelContainers[middleIndex]);
  }
}
