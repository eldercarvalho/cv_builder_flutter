import 'package:cv_builder/ui/shared/extensions/context.dart';
import 'package:flutter/material.dart';

import '../../../shared/widgets/cb_button.dart';

class FormButtons extends StatelessWidget {
  const FormButtons({super.key, required this.onNextPressed});

  final Function() onNextPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        spacing: 20,
        children: [
          Expanded(
            child: CbButton(
              onPressed: onNextPressed,
              text: context.l10n.next,
            ),
          ),
          // Expanded(
          //   child: CbButton(
          //     onPressed: () {},
          //     text: context.l10n.save,
          //   ),
          // ),
        ],
      ),
    );
  }
}
