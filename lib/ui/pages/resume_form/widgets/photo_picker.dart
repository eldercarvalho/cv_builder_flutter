import 'dart:io';

import 'package:cv_builder/ui/shared/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:image_picker/image_picker.dart';

class PhotoPicker extends StatefulWidget {
  const PhotoPicker({
    super.key,
    this.onImagePicked,
    required this.initialValue,
  });

  final String? initialValue;
  final Function(File image)? onImagePicked;

  @override
  State<PhotoPicker> createState() => _PhotoPickerState();
}

class _PhotoPickerState extends State<PhotoPicker> {
  File? _image;

  @override
  Widget build(BuildContext context) {
    DecorationImage? decorationImage;

    if (widget.initialValue != null) {
      decorationImage = DecorationImage(image: NetworkImage(widget.initialValue!), fit: BoxFit.cover);
    }

    if (_image != null) {
      decorationImage = DecorationImage(image: FileImage(_image!), fit: BoxFit.cover);
    }

    return GestureDetector(
      onTap: _pickImage,
      child: Stack(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(60),
              image: decorationImage,
            ),
            child: decorationImage == null ? const Icon(FeatherIcons.user, size: 50) : null,
          ),
          Positioned(
            right: 4,
            bottom: 4,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: context.colors.primary,
              ),
              child: Icon(
                FeatherIcons.edit,
                size: 16,
                color: context.colors.onPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _pickImage() async {
    final imagePicker = ImagePicker();
    final XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);

    if (file != null) {
      _image = File(file.path);
      widget.onImagePicked?.call(_image!);
    }
  }
}
