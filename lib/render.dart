import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/vector_math_64.dart';

class MultiWidgetCardRenderObjectWidget extends MultiChildRenderObjectWidget {
  const MultiWidgetCardRenderObjectWidget(
      {Key? key, required List<Widget> children})
      : super(key: key, children: children);

  @override
  RenderMyExample createRenderObject(BuildContext context) {
    return RenderMyExample();
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant RenderObject renderObject) {
    (renderObject as RenderMyExample).reassemble();
    super.updateRenderObject(context, renderObject);
  }
}

class MyExampleParentData extends ContainerBoxParentData<RenderBox> {}

class RenderMyExample extends RenderBox
    with ContainerRenderObjectMixin<RenderBox, MyExampleParentData> {
  late Iterator<Offset> offsetXs;

  RenderMyExample();

  @override
  void setupParentData(RenderObject child) {
    if (child.parentData is! MyExampleParentData) {
      child.parentData = MyExampleParentData();
    }
  }

  @override
  void performLayout() {
    size = constraints.biggest;

    for (var child = firstChild; child != null; child = childAfter(child)) {
      child.layout(
        constraints.copyWith(maxHeight: size.height),
      );
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    for (var child = firstChild; child != null; child = childAfter(child)) {
      context.paintChild(child, offset);
    }
  }
}
