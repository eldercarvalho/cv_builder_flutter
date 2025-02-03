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
    final ResumePreviewViewModel viewModel = context.read();
    final resume = viewModel.resume;

    return Drawer(
      child: ListView(
        children: [
          const SizedBox(height: 20),
          ListTile(
            leading: Icon(FeatherIcons.fileText, color: context.colors.primary),
            title: Text('Sobre o Currículo', style: context.textTheme.labelLarge),
            onTap: () => _navToForm(context, resume!, ResumeFormPageStep.resumeInfo),
          ),
          ListTile(
            leading: Icon(FeatherIcons.user, color: context.colors.primary),
            title: Text(context.l10n.profile, style: context.textTheme.labelLarge),
            onTap: () => _navToForm(context, resume!, ResumeFormPageStep.personalInfo),
          ),
          ListTile(
            leading: Icon(FeatherIcons.mapPin, color: context.colors.primary),
            title: Text(context.l10n.address, style: context.textTheme.labelLarge),
            onTap: () => _navToForm(context, resume!, ResumeFormPageStep.address),
          ),
          ListTile(
            leading: Icon(FeatherIcons.phone, color: context.colors.primary),
            title: Text(context.l10n.contact, style: context.textTheme.labelLarge),
            onTap: () => _navToForm(context, resume!, ResumeFormPageStep.contact),
          ),
          ListTile(
            leading: Icon(FeatherIcons.checkCircle, color: context.colors.primary),
            title: Text(context.l10n.objective, style: context.textTheme.labelLarge),
            onTap: () => _navToForm(context, resume!, ResumeFormPageStep.objective),
          ),
          ListTile(
            leading: Icon(FeatherIcons.share2, color: context.colors.primary),
            title: Text(context.l10n.socialNetwork(2), style: context.textTheme.labelLarge),
            onTap: () => _navToForm(context, resume!, ResumeFormPageStep.socialNetworks),
          ),
          ListTile(
            leading: Icon(FeatherIcons.briefcase, color: context.colors.primary),
            title: Text(context.l10n.experience, style: context.textTheme.labelLarge),
            onTap: () => _navToForm(context, resume!, ResumeFormPageStep.experience),
          ),
          ListTile(
            leading: Icon(FeatherIcons.award, color: context.colors.primary),
            title: Text(context.l10n.education, style: context.textTheme.labelLarge),
            onTap: () => _navToForm(context, resume!, ResumeFormPageStep.education),
          ),
          ListTile(
            leading: Icon(FeatherIcons.star, color: context.colors.primary),
            title: Text(context.l10n.skills, style: context.textTheme.labelLarge),
            onTap: () => _navToForm(context, resume!, ResumeFormPageStep.skills),
          ),
          ListTile(
            leading: Icon(FeatherIcons.flag, color: context.colors.primary),
            title: Text(context.l10n.languages, style: context.textTheme.labelLarge),
            onTap: () => _navToForm(context, resume!, ResumeFormPageStep.languages),
          ),
          ListTile(
            leading: Icon(FeatherIcons.award, color: context.colors.primary),
            title: Text(context.l10n.certifications, style: context.textTheme.labelLarge),
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
