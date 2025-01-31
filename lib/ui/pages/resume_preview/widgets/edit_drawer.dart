import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';

import '../../../../domain/models/resume.dart';
import '../../../shared/extensions/extensions.dart';
import '../../resume_form/resume_form_page.dart';
import '../view_model/resume_preview_view_model.dart';

class EditDrawer extends StatelessWidget {
  const EditDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ResumePreviewViewModel>();
    final resume = viewModel.resume;

    return Drawer(
      child: ListView(
        children: [
          const SizedBox(height: 20),
          ListTile(
            leading: const Icon(FeatherIcons.fileText),
            title: const Text('Sobre o Currículo'),
            onTap: () => _navToForm(context, resume!, ResumeFormPageStep.resumeInfo),
          ),
          ListTile(
            leading: const Icon(FeatherIcons.user),
            title: Text(context.l10n.personalInfo),
            onTap: () => _navToForm(context, resume!, ResumeFormPageStep.personalInfo),
          ),
          ListTile(
            leading: const Icon(FeatherIcons.mapPin),
            title: Text(context.l10n.address),
            onTap: () => _navToForm(context, resume!, ResumeFormPageStep.address),
          ),
          ListTile(
            leading: const Icon(FeatherIcons.phone),
            title: Text(context.l10n.contact),
            onTap: () => _navToForm(context, resume!, ResumeFormPageStep.contact),
          ),
          ListTile(
            leading: const Icon(FeatherIcons.checkCircle),
            title: Text(context.l10n.objective),
            onTap: () => _navToForm(context, resume!, ResumeFormPageStep.objective),
          ),
          ListTile(
            leading: const Icon(FeatherIcons.share2),
            title: Text(context.l10n.socialNetwork(2)),
            onTap: () => _navToForm(context, resume!, ResumeFormPageStep.socialNetworks),
          ),
          ListTile(
            leading: const Icon(FeatherIcons.barChart),
            title: Text(context.l10n.experience),
            onTap: () => _navToForm(context, resume!, ResumeFormPageStep.experience),
          ),
          ListTile(
            leading: const Icon(FeatherIcons.award),
            title: Text(context.l10n.education),
            onTap: () => _navToForm(context, resume!, ResumeFormPageStep.education),
          ),
          ListTile(
            leading: const Icon(FeatherIcons.star),
            title: Text(context.l10n.skills),
            onTap: () => _navToForm(context, resume!, ResumeFormPageStep.skills),
          ),
          ListTile(
            leading: const Icon(FeatherIcons.flag),
            title: Text(context.l10n.languages),
            onTap: () => _navToForm(context, resume!, ResumeFormPageStep.languages),
          ),
          ListTile(
            leading: const Icon(FeatherIcons.award),
            title: Text(context.l10n.certifications),
            onTap: () => _navToForm(context, resume!, ResumeFormPageStep.certifications),
          ),
        ],
      ),
    );
  }

  void _navToForm(BuildContext context, Resume resume, ResumeFormPageStep step) {
    ResumeFormPage.push(
      context,
      params: ResumeFormParams(resume: resume, step: step),
    );
  }
}
