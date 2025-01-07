import 'package:flutter/material.dart';

class FormContainer extends StatelessWidget {
  const FormContainer({
    super.key,
    required this.fields,
    required this.bottom,
    required this.formKey,
  });

  final List<Widget> fields;
  final Widget bottom;
  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                spacing: 20,
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
