import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../domain/models/models.dart';
import '../../../../ui/shared/extensions/extensions.dart';
import '../view_model/resume_preview_view_model.dart';
import 'color_option.dart';

class CustomBottomSheet extends StatelessWidget {
  const CustomBottomSheet({
    super.key,
    required this.oldTheme,
    required this.onCancel,
    required this.onSave,
  });

  final ResumeTheme oldTheme;
  final Function() onCancel;
  final Function() onSave;

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ResumePreviewViewModel>();
    final theme = viewModel.resume!.theme;
    // Melhorar a lógica de cores para tirar o background da lista de cores no tema singleLayout
    final colorsWithoutBackground =
        theme.primaryColors.where((color) => color.type != ResumeColorType.background).toList();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(color: context.colors.surface),
      child: ListenableBuilder(
        listenable: viewModel,
        builder: (context, _) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(context.l10n.customizeColors, style: context.textTheme.titleLarge),
              theme.singleLayout ? const SizedBox(height: 24) : const SizedBox(height: 8),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      if (theme.singleLayout)
                        Wrap(
                          spacing: 16,
                          runSpacing: 16,
                          children: List.generate(
                            colorsWithoutBackground.length,
                            (index) {
                              final resumeColor = colorsWithoutBackground[index];
                              final defaultColor =
                                  ResumeTheme.getByTemplate(viewModel.resume!.template).primaryColors[index];
                              return ColorOption(
                                text: _getColorName(context, resumeColor.type),
                                defaultValue: defaultColor.value.toColor(),
                                value: resumeColor.value.toColor(),
                                onChanged: (color) {
                                  final newTheme = theme.copyWith(
                                    primaryColors: theme.primaryColors.setColor(resumeColor.type, color.toHex()),
                                  );
                                  viewModel.updateTheme(newTheme);
                                },
                              );
                            },
                          ),
                        ),
                      if (!theme.singleLayout)
                        ExpansionTile(
                          tilePadding: const EdgeInsets.all(0),
                          title: Text(context.l10n.column1, style: context.textTheme.titleMedium),
                          dense: true,
                          initiallyExpanded: true,
                          childrenPadding: const EdgeInsets.only(bottom: 16),
                          children: [
                            Wrap(
                              spacing: 16,
                              runSpacing: 16,
                              children: List.generate(
                                theme.primaryColors.length,
                                (index) {
                                  final resumeColor = theme.primaryColors[index];
                                  final defaultColor =
                                      ResumeTheme.getByTemplate(viewModel.resume!.template).primaryColors[index];
                                  return ColorOption(
                                    text: _getColorName(context, resumeColor.type),
                                    defaultValue: defaultColor.value.toColor(),
                                    value: resumeColor.value.toColor(),
                                    onChanged: (color) {
                                      final newTheme = theme.copyWith(
                                        primaryColors: theme.primaryColors.setColor(resumeColor.type, color.toHex()),
                                      );
                                      viewModel.updateTheme(newTheme);
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      if (!theme.singleLayout) const Divider(),
                      if (!theme.singleLayout)
                        ExpansionTile(
                          tilePadding: const EdgeInsets.all(0),
                          title: Text(context.l10n.column2, style: context.textTheme.titleMedium),
                          dense: true,
                          initiallyExpanded: true,
                          childrenPadding: const EdgeInsets.only(bottom: 16),
                          children: [
                            Wrap(
                              spacing: 16,
                              runSpacing: 16,
                              children: List.generate(
                                theme.secondaryColors.length,
                                (index) {
                                  final resumeColor = theme.secondaryColors[index];
                                  final defaultColor =
                                      ResumeTheme.getByTemplate(viewModel.resume!.template).secondaryColors[index];
                                  return ColorOption(
                                    text: _getColorName(context, resumeColor.type),
                                    defaultValue: defaultColor.value.toColor(),
                                    value: resumeColor.value.toColor(),
                                    onChanged: (color) {
                                      final newTheme = theme.copyWith(
                                        secondaryColors:
                                            theme.secondaryColors.setColor(resumeColor.type, color.toHex()),
                                      );
                                      viewModel.updateTheme(newTheme);
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
              // const Divider(),
              const SizedBox(height: 6),
              SafeArea(
                top: false,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: onCancel,
                      child: Text(context.l10n.cancel),
                    ),
                    if (viewModel.resume!.theme != oldTheme) ...[
                      const SizedBox(width: 16),
                      FilledButton(
                        onPressed: onSave,
                        child: Text(context.l10n.save),
                      ),
                    ]
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _getColorName(BuildContext context, ResumeColorType type) {
    switch (type) {
      case ResumeColorType.background:
        return context.l10n.backgroundColor;
      case ResumeColorType.title:
        return context.l10n.titleColor;
      case ResumeColorType.text:
        return context.l10n.textColor;
      case ResumeColorType.link:
        return context.l10n.linkColor;
      case ResumeColorType.icon:
        return context.l10n.iconColor;
      case ResumeColorType.divider:
        return context.l10n.dividerColor;
    }
  }
}
