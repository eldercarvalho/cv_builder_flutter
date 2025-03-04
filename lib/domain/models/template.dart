import 'package:equatable/equatable.dart';

class Template extends Equatable {
  final String name;
  final String imagePath;

  const Template({
    required this.name,
    required this.imagePath,
  });

  @override
  List<Object?> get props => [name, imagePath];
}
