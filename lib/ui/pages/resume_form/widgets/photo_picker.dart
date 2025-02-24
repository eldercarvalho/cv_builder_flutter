import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../../shared/extensions/extensions.dart';

class PhotoPicker extends StatefulWidget {
  const PhotoPicker({
    super.key,
    this.onImagePicked,
    required this.initialValue,
    this.onDelete,
  });

  final String? initialValue;
  final Function(File image)? onImagePicked;
  final Function()? onDelete;

  @override
  State<PhotoPicker> createState() => _PhotoPickerState();
}

class _PhotoPickerState extends State<PhotoPicker> {
  File? _image;

  @override
  void didUpdateWidget(covariant PhotoPicker oldWidget) {
    if (widget.initialValue != oldWidget.initialValue) {
      if (widget.initialValue != null && widget.initialValue!.startsWith('https')) {
        _image = null;
      }

      if (widget.initialValue != null && !widget.initialValue!.startsWith('https')) {
        _image = File(widget.initialValue!);
      }
    }
    super.didUpdateWidget(oldWidget);
  }

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
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(60),
              image: decorationImage,
            ),
            child: decorationImage == null
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            FeatherIcons.camera,
                            color: Colors.grey.shade600,
                            size: 32,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            context.l10n.addPhoto,
                            style: context.textTheme.labelMedium?.copyWith(height: 1.2),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  )
                : null,
          ),
          if (decorationImage != null)
            Positioned(
              right: 4,
              bottom: 4,
              child: GestureDetector(
                onTap: () {
                  setState(() => _image = null);
                  widget.onDelete?.call();
                },
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: context.colors.surface,
                    border: Border.all(color: context.colors.error, width: 1),
                  ),
                  child: Icon(
                    FeatherIcons.trash2,
                    size: 16,
                    color: context.colors.error,
                  ),
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
      if (croppedFile != null) {
        setState(() {
          _image = croppedFile;
        });

        widget.onImagePicked?.call(_image!);
      }
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
