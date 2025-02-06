import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';

import '../../../../domain/models/resume.dart';
import '../../../shared/extensions/extensions.dart';
import '../../resume_form/resume_form_page.dart';
import '../view_model/resume_preview_view_model.dart';
import 'edit_drawer_item.dart';

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
          EditDrawerItem(
            icon: FeatherIcons.fileText,
            title: context.l10n.resumeAbout,
            onTap: () => _navToForm(context, resume!, ResumeFormPageStep.resumeInfo, viewModel),
          ),
          EditDrawerItem(
            icon: FeatherIcons.user,
            title: context.l10n.profile,
            onTap: () => _navToForm(context, resume!, ResumeFormPageStep.personalInfo, viewModel),
          ),
          EditDrawerItem(
            icon: FeatherIcons.mapPin,
            title: context.l10n.address,
            onTap: () => _navToForm(context, resume!, ResumeFormPageStep.address, viewModel),
          ),
          EditDrawerItem(
            icon: FeatherIcons.phone,
            title: context.l10n.contact,
            onTap: () => _navToForm(context, resume!, ResumeFormPageStep.contact, viewModel),
          ),
          EditDrawerItem(
            icon: FeatherIcons.target,
            title: context.l10n.objective,
            onTap: () => _navToForm(context, resume!, ResumeFormPageStep.objective, viewModel),
          ),
          EditDrawerItem(
            icon: FeatherIcons.share2,
            title: context.l10n.socialNetwork(2),
            onTap: () => _navToForm(context, resume!, ResumeFormPageStep.socialNetworks, viewModel),
          ),
          EditDrawerItem(
            icon: FeatherIcons.briefcase,
            title: context.l10n.experience(1),
            onTap: () => _navToForm(context, resume!, ResumeFormPageStep.experience, viewModel),
          ),
          EditDrawerItem(
            icon: FeatherIcons.award,
            title: context.l10n.education(1),
            onTap: () => _navToForm(context, resume!, ResumeFormPageStep.education, viewModel),
          ),
          EditDrawerItem(
            icon: FeatherIcons.star,
            title: context.l10n.skills(2),
            onTap: () => _navToForm(context, resume!, ResumeFormPageStep.skills, viewModel),
          ),
          EditDrawerItem(
            icon: FeatherIcons.flag,
            title: context.l10n.languages(2),
            onTap: () => _navToForm(context, resume!, ResumeFormPageStep.languages, viewModel),
          ),
          EditDrawerItem(
            icon: FeatherIcons.award,
            title: context.l10n.certifications(2),
            onTap: () => _navToForm(context, resume!, ResumeFormPageStep.certifications, viewModel),
          ),
        ],
      ),
    );
  }

  void _navToForm(
    BuildContext context,
    Resume resume,
    ResumeFormPageStep step,
    ResumePreviewViewModel viewModel,
  ) async {
    await ResumeFormPage.push(
      context,
      params: ResumeFormParams(resume: resume, step: step),
    );
    viewModel.getResume.execute(resume.id);
  }
}
