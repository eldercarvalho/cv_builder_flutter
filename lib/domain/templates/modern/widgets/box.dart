import 'package:pdf/widgets.dart';

class Box extends StatelessWidget {
  Box({required this.child});

  final Widget child;

  @override
  Widget build(Context context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: child,
    );
  }
}
