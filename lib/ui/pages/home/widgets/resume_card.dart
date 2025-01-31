import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

import '../../../../domain/models/resume.dart';
import '../../../shared/extensions/extensions.dart';

class ResumeCard extends StatelessWidget {
  const ResumeCard({
    super.key,
    required this.resume,
    required this.isLoading,
    required this.onTap,
    required this.onMenuSelected,
  });

  final Resume resume;
  final bool isLoading;
  final Function() onTap;
  final Function(String) onMenuSelected;

  @override
  Widget build(BuildContext context) {
    final updatedAt = resume.updatedAt ?? resume.createdAt;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: context.colors.surfaceBright,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(resume.resumeName, style: const TextStyle(fontSize: 18)),
                ),
                PopupMenuButton<String>(
                  onSelected: onMenuSelected,
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(FeatherIcons.edit),
                          SizedBox(width: 8),
                          Text('Editar'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(FeatherIcons.trash2),
                          SizedBox(width: 8),
                          Text('Excluir'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: context.colors.outline),
                    image: isLoading
                        ? null
                        : DecorationImage(
                            alignment: Alignment.topCenter,
                            image: CachedNetworkImageProvider(resume.thumbnail!),
                            fit: BoxFit.cover,
                          ),
                  ),
                  child: isLoading ? const Center(child: CircularProgressIndicator()) : null,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text('Atualizado em: ${updatedAt.toSimpleDate()}', style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
