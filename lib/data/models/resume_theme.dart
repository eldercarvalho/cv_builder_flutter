import 'package:equatable/equatable.dart';

import '../../domain/models/resume.dart';

class ResumeColorModel {
  final String type;
  final String value;

  const ResumeColorModel({
    required this.type,
    required this.value,
  });

  factory ResumeColorModel.fromJson(Map<String, dynamic> json) {
    return ResumeColorModel(
      type: json['type'] as String,
      value: json['value'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'value': value,
    };
  }

  ResumeColor toDomain() {
    return ResumeColor(
      type: ResumeColorType.fromString(type),
      value: value,
    );
  }

  factory ResumeColorModel.fromDomain(ResumeColor color) {
    return ResumeColorModel(
      type: color.type.name,
      value: color.value,
    );
  }
}

class ResumeThemeModel extends Equatable {
  final bool singleLayout;
  final List<ResumeColorModel> primaryColors;
  final List<ResumeColorModel> secondaryColors;

  const ResumeThemeModel({
    required this.singleLayout,
    required this.primaryColors,
    required this.secondaryColors,
  });

  factory ResumeThemeModel.fromJson(Map<String, dynamic> json, String template) {
    return ResumeThemeModel(
      singleLayout: json['singleLayout'] != null ? json['singleLayout'] as bool : getSingleLayoutByTemplate(template),
      primaryColors: List.of(json['primaryColors']).map((e) => ResumeColorModel.fromJson(e)).toList(),
      secondaryColors: List.of(json['secondaryColors']).map((e) => ResumeColorModel.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'singleLayout': singleLayout,
      'primaryColors': primaryColors.map((e) => e.toJson()).toList(),
      'secondaryColors': secondaryColors.map((e) => e.toJson()).toList(),
    };
  }

  ResumeTheme toDomain() {
    return ResumeTheme(
      singleLayout: singleLayout,
      primaryColors: primaryColors.map((e) => e.toDomain()).toList(),
      secondaryColors: secondaryColors.map((e) => e.toDomain()).toList(),
    );
  }

  factory ResumeThemeModel.fromDomain(ResumeTheme theme) {
    return ResumeThemeModel(
      singleLayout: theme.singleLayout,
      primaryColors: theme.primaryColors.map((e) => ResumeColorModel.fromDomain(e)).toList(),
      secondaryColors: theme.secondaryColors.map((e) => ResumeColorModel.fromDomain(e)).toList(),
    );
  }

  static ResumeThemeModel getByTemplate(String template) {
    switch (template) {
      case 'basic':
        return basic;
      case 'modern':
        return modern;
      default:
        return basic;
    }
  }

  static const ResumeThemeModel basic = ResumeThemeModel(
    singleLayout: true,
    primaryColors: [
      ResumeColorModel(type: 'background', value: '#FFFFFF'),
      ResumeColorModel(type: 'title', value: '#000000'),
      ResumeColorModel(type: 'text', value: '#000000'),
      ResumeColorModel(type: 'icon', value: '#000000'),
      ResumeColorModel(type: 'link', value: '#2196f3'),
      ResumeColorModel(type: 'divider', value: '#000000'),
    ],
    secondaryColors: [
      ResumeColorModel(type: 'background', value: '#FFFFFF'),
      ResumeColorModel(type: 'title', value: '#000000'),
      ResumeColorModel(type: 'text', value: '#000000'),
      ResumeColorModel(type: 'icon', value: '#000000'),
      ResumeColorModel(type: 'link', value: '#2196f3'),
      ResumeColorModel(type: 'divider', value: '#000000'),
    ],
  );

  static const ResumeThemeModel modern = ResumeThemeModel(
    singleLayout: false,
    primaryColors: [
      ResumeColorModel(type: 'background', value: '#D8DFE7'),
      ResumeColorModel(type: 'title', value: '#424242'),
      ResumeColorModel(type: 'text', value: '#424242'),
      ResumeColorModel(type: 'icon', value: '#424242'),
      ResumeColorModel(type: 'link', value: '#2196f3'),
      ResumeColorModel(type: 'divider', value: '#424242'),
    ],
    secondaryColors: [
      ResumeColorModel(type: 'background', value: '#FFFFFF'),
      ResumeColorModel(type: 'title', value: '#424242'),
      ResumeColorModel(type: 'text', value: '#424242'),
      ResumeColorModel(type: 'icon', value: '#424242'),
      ResumeColorModel(type: 'link', value: '#2196f3'),
      ResumeColorModel(type: 'divider', value: '#424242'),
    ],
  );

  static bool getSingleLayoutByTemplate(String template) {
    switch (template) {
      case 'basic':
        return basic.singleLayout;
      case 'modern':
        return modern.singleLayout;
      default:
        return basic.singleLayout;
    }
  }

  @override
  List<Object?> get props => [
        singleLayout,
        primaryColors,
        secondaryColors,
      ];
}
