import 'dart:io';

import 'package:cv_builder/ui/shared/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:image_cropper/image_cropper.dart';
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

    if (widget.initialValue != null && widget.initialValue!.startsWith('https')) {
      decorationImage = DecorationImage(image: NetworkImage(widget.initialValue!), fit: BoxFit.cover);
    }

    if (widget.initialValue != null && !widget.initialValue!.startsWith('https')) {
      decorationImage = DecorationImage(image: FileImage(File(widget.initialValue!)), fit: BoxFit.cover);
    }

    if (_image != null) {
      decorationImage = DecorationImage(image: FileImage(_image!), fit: BoxFit.cover);
    }

    return GestureDetector(
      onTap: _pickAndCropImage,
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
            child: decorationImage == null ? const Icon(FeatherIcons.user, size: 50, color: Colors.black38) : null,
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

  Future<void> _pickAndCropImage() async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File? croppedFile = await _cropImage(File(pickedFile.path));
      setState(() {
        _image = croppedFile;
      });
      widget.onImagePicked?.call(_image!);
    }
  }

  Future<File?> _cropImage(File imageFile) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: context.l10n.cropImageTitle,
            toolbarColor: Colors.white,
            toolbarWidgetColor: context.colors.secondary,
            hideBottomControls: false,
            lockAspectRatio: true, // Permite ajuste livre
            aspectRatioPresets: [
              CropAspectRatioPreset.square,
            ]),
        IOSUiSettings(
          title: context.l10n.cropImageTitle,
          aspectRatioLockEnabled: true, // Permite ajustes livres
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
          ],
        ),
      ],
    );

    return croppedFile != null ? File(croppedFile.path) : null;
  }
}
