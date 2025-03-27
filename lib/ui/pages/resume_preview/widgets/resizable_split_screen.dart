import 'package:flutter/material.dart';

class ResizableSplitScreen extends StatefulWidget {
  const ResizableSplitScreen({
    super.key,
    required this.topChild,
    required this.bottomChild,
    required this.isExpanded,
  });

  final Widget topChild;
  final Widget bottomChild;
  final bool isExpanded;

  @override
  ResizableSplitScreenState createState() => ResizableSplitScreenState();
}

class ResizableSplitScreenState extends State<ResizableSplitScreen> {
  double bottomHeight = 0.0;
  double minHeight = 0.0;
  double draggableMinHeight = 200.0;
  double maxHeight = 400.0;

  @override
  void didUpdateWidget(covariant ResizableSplitScreen oldWidget) {
    if (widget.isExpanded) {
      bottomHeight = maxHeight;
    } else {
      bottomHeight = minHeight;
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        maxHeight = constraints.maxHeight * 0.6;

        return Column(
          children: [
            Expanded(child: widget.topChild),
            if (widget.isExpanded)
              GestureDetector(
                onVerticalDragUpdate: (details) {
                  setState(() {
                    bottomHeight -= details.primaryDelta!;
                    bottomHeight = bottomHeight.clamp(draggableMinHeight, maxHeight);
                  });
                },
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: 50,
                      height: 20,
                      alignment: Alignment.center,
                      child: Transform.translate(
                        offset: const Offset(0, -2),
                        child: const Icon(Icons.drag_handle, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
              ),
            // AnimatedSize(duration: duration)
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: SizedBox(
                height: bottomHeight,
                child: widget.bottomChild,
              ),
            ),
          ],
        );
      },
    );
  }
}
