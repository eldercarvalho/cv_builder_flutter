import 'package:flutter/material.dart';

class FormContainer extends StatelessWidget {
  const FormContainer({
    super.key,
    required this.fields,
    required this.bottom,
  });

  final List<Widget> fields;
  final Widget bottom;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                spacing: 16,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: fields,
              ),
            ),
          ),
        ),
        bottom,
      ],
    );
  }
}
