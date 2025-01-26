import 'package:cv_builder/ui/shared/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class FinishedPage extends StatelessWidget {
  const FinishedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/images/mascot.svg',
              height: 200,
            ),
            const SizedBox(height: 20),
            Text(
              'Your resume has been successfully created!',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Text(
              'You can now download your resume in PDF format.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 30),
            CbButton(
              onPressed: () => Navigator.of(context).pop(),
              text: 'Back to home',
            ),
          ],
        ),
      ),
    );
  }
}
