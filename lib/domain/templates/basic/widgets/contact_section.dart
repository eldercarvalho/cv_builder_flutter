import 'package:cv_builder/domain/models/resume.dart';
import 'package:cv_builder/domain/templates/texts.dart';
import 'package:cv_builder/ui/shared/extensions/datetime.dart';
import 'package:pdf/widgets.dart';

import '../../../models/resume_section.dart';
import '../../template_config.dart';
import 'persoal_info.dart';
import 'section_title.dart';
import 'social_network.dart';

List<Widget> buildContact({required Resume resume, required TemplateConfig config}) {
  final ResumeSection sectionConfig = resume.sections.contact;
  final texts = getTexts(resume.resumeLanguage!);

  final birthdayText =
      resume.birthDate != null ? '${resume.birthDate?.toSimpleDate()} - ${resume.age} ${texts.years}' : null;

  return [
    if (!sectionConfig.hideTitle) ...[
      SectionTitle(text: sectionConfig.title, config: config),
      SizedBox(height: config.titleSpace),
    ],
    PersonalInfo(text: birthdayText, icon: 'cake', marginTop: 0, config: config),
    PersonalInfo(text: resume.formattedAddress, icon: 'mapmarker', config: config),
    PersonalInfo(text: resume.phoneNumber, icon: 'phone', config: config),
    PersonalInfo(text: resume.email, icon: 'email', config: config),
    PersonalInfo(text: resume.website, icon: 'website', config: config),

    // Redes Sociais
    if (resume.socialNetworks.isNotEmpty)
      ListView.builder(
        itemCount: resume.socialNetworks.length,
        itemBuilder: (context, index) {
          final social = resume.socialNetworks[index];
          return SocialNetworkInfo(socialNetwork: social, config: config);
        },
        // separatorBuilder: (context, index) => SizedBox(height: config.lineSpace),
      ),
  ];
}
