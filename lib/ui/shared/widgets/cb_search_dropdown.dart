import 'package:cv_builder/ui/shared/extensions/extensions.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class CbSearchDropdown extends StatelessWidget {
  const CbSearchDropdown({
    super.key,
    required this.items,
    this.onChanged,
    this.controller,
    required this.label,
  });

  final String label;
  final List<String> items;
  final Function(String?)? onChanged;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<String>(
      // selectedItem: controller?.text,
      popupProps: const PopupProps.menu(
        showSearchBox: true,
      ),
      items: (filter, infiniteScrollProps) => items,
      // dropdownBuilder: dropdownBuilder,

      decoratorProps: DropDownDecoratorProps(
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          hintStyle: context.textTheme.labelLarge,
          labelStyle: context.textTheme.labelLarge,
          labelText: label,
          hintText: label,
        ),
      ),
      suffixProps: const DropdownSuffixProps(
        dropdownButtonProps: DropdownButtonProps(
          selectedIcon: Icon(FeatherIcons.chevronDown),
          iconSize: 24,
        ),
      ),
      onChanged: (value) {
        controller?.text = value!;
        onChanged?.call(value);
      },
    );
  }
}
