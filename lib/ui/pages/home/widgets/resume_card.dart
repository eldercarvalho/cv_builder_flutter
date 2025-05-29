import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

import '../../../../domain/models/resume.dart';
import '../../../shared/extensions/extensions.dart';

class ResumeCard extends StatefulWidget {
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
  State<ResumeCard> createState() => _ResumeCardState();
}

class _ResumeCardState extends State<ResumeCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 1.0, end: 1.5).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose(); // Libera recursos da animação
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final updatedAt = widget.resume.updatedAt ?? widget.resume.createdAt;

    return GestureDetector(
      onTap: !widget.isLoading ? widget.onTap : null,
      child: Stack(
        children: [
          AnimatedOpacity(
            duration: const Duration(milliseconds: 500),
            opacity: widget.isLoading ? 0.4 : 1,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: context.colors.surfaceBright,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 2,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(widget.resume.resumeName, style: context.textTheme.titleMedium),
                        ),
                        if (!widget.isLoading)
                          PopupMenuButton<String>(
                            onSelected: widget.onMenuSelected,
                            child: const SizedBox(
                              height: 26,
                              width: 26,
                              child: Icon(FeatherIcons.moreVertical),
                            ),
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                value: 'edit',
                                child: Row(
                                  children: [
                                    Icon(FeatherIcons.edit, size: 18, color: context.colors.primary),
                                    const SizedBox(width: 8),
                                    Text(context.l10n.edit),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                value: 'share',
                                child: Row(
                                  children: [
                                    Icon(FeatherIcons.share2, size: 20, color: context.colors.primary),
                                    const SizedBox(width: 8),
                                    Text(context.l10n.finishedFormShare),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                value: 'export',
                                child: Row(
                                  children: [
                                    Icon(FeatherIcons.upload, size: 20, color: context.colors.primary),
                                    const SizedBox(width: 8),
                                    Text(context.l10n.export),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                value: 'delete',
                                child: Row(
                                  children: [
                                    Icon(FeatherIcons.trash2, size: 20, color: context.colors.error),
                                    const SizedBox(width: 8),
                                    Text(context.l10n.delete),
                                  ],
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    height: 160,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: context.colors.outline.withValues(alpha: 0.6)),
                      image: DecorationImage(
                        alignment: Alignment.topCenter,
                        image: CachedNetworkImageProvider(widget.resume.thumbnail!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      context.l10n.homeResumeCardUpdatedAt(updatedAt.toSimpleDate()),
                      style: context.textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (widget.isLoading)
            Positioned.fill(
              child: Center(
                child: AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _animation.value,
                      child: Icon(
                        FeatherIcons.trash2,
                        size: 40,
                        color: context.colors.error,
                      ),
                    );
                  },
                ),
              ),
            )
        ],
      ),
    );
  }
}
