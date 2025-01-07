import 'dart:io';

import 'package:cv_builder/ui/shared/extensions/datetime.dart';
import 'package:flutter/material.dart';

import '../../../../domain/models/resume.dart';

class ResumeCard extends StatelessWidget {
  const ResumeCard({
    super.key,
    required this.resume,
    required this.onTap,
  });

  final Resume resume;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 150,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.grey.shade300),
                image: DecorationImage(
                  alignment: Alignment.topCenter,
                  image: FileImage(File(resume.thumbnail!)),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(resume.resumeName, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Atualizado em: ${resume.createdAt.toSimpleDate()}', style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
