import 'package:cv_builder/ui/shared/extensions/context.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'widgets/widgets.dart';

class ResumeFormPage extends StatefulWidget {
  const ResumeFormPage({super.key});

  @override
  State<ResumeFormPage> createState() => _ResumeFormPageState();

  static const route = '/home/resume-form';

  static Future<Object?> push(BuildContext context) async {
    return await context.push(route);
  }
}

class _ResumeFormPageState extends State<ResumeFormPage> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        if (_pageController.page == 0) {
          Navigator.of(context).pop();
        } else {
          _pageController.previousPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.l10n.newResume),
        ),
        body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _pageController,
          children: [
            ResumeInfoForm(onNext: _onNext),
            const PersonalInfoForm(),
          ],
        ),
      ),
    );
  }

  void _onNext() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}
