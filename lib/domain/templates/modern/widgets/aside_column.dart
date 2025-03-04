import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

class InfoColumn extends StatelessWidget {
  InfoColumn({
    required this.children,
    required this.width,
    required this.height,
    this.color = PdfColors.white,
    this.padding = EdgeInsets.zero,
  });

  final List<Widget> children;
  final EdgeInsets padding;
  final double width;
  final double height;
  final PdfColor color;

  @override
  Widget build(Context context) {
    return Partition(
      width: width,
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }
}
