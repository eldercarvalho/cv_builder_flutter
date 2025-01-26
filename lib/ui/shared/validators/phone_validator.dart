import 'text_field_validator.dart';

final areaCodesByLocale = {
  'BR': [
    11,
    12,
    13,
    14,
    15,
    16,
    17,
    18,
    19,
    21,
    22,
    24,
    27,
    28,
    31,
    32,
    33,
    34,
    35,
    37,
    38,
    41,
    42,
    43,
    44,
    45,
    46,
    47,
    48,
    49,
    51,
    53,
    54,
    55,
    61,
    62,
    63,
    64,
    65,
    66,
    67,
    68,
    69,
    71,
    73,
    74,
    75,
    77,
    79,
    81,
    82,
    83,
    84,
    85,
    86,
    87,
    88,
    89,
    91,
    92,
    93,
    94,
    95,
    96,
    97,
    98,
    99
  ],
};

class PhoneValidator extends TextFieldValidator {
  PhoneValidator({
    required this.country,
    required String errorText,
    bool? validateIf,
  }) : super(errorText, validateIf);

  final String country;

  @override
  bool isValid(String? value) {
    if (country == 'BR' && value!.length == 14) {
      final areaCode = int.parse(value.substring(3, 5));
      final digit = int.parse(value.substring(5, 6));

      if (!areaCodesByLocale[country]!.contains(areaCode)) return false;
      if (digit != 9) return false;

      return true;
    }

    return true;
  }
}
