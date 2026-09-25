import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:study_vault/core/config/app_colors.dart';
import 'package:study_vault/core/config/app_font_size.dart';
import 'package:study_vault/core/widgets/custom_text.dart';
import 'package:study_vault/features/notes/data/models/notes_model.dart';

class TrendingPdfContainer extends StatefulWidget {
  final Note note;

  const TrendingPdfContainer({super.key, required this.note});

  @override
  State<TrendingPdfContainer> createState() => _TrendingPdfContainerState();
}

class _TrendingPdfContainerState extends State<TrendingPdfContainer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final note = widget.note;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _TrendingBorderPainter(progress: _controller.value),
          child: child,
        );
      },
      child: Container(
        height: 100,
        width: double.infinity,
        margin: const EdgeInsets.only(right: 6, bottom: 12),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            // PDF Icon
            Container(
              height: 78,
              width: 65,
              decoration: BoxDecoration(
                color: AppColors.accentCoralMuted,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.accentCoral.withValues(alpha: 0.25),
                ),
              ),
              child: const Icon(
                Icons.picture_as_pdf_rounded,
                color: AppColors.accentCoral,
                size: 34,
              ),
            ),

            const SizedBox(width: 12),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Trending badge
                  Row(
                    children: [
                      const Icon(
                        Icons.local_fire_department_rounded,
                        color: Colors.orange,
                        size: 15,
                      ),
                      const SizedBox(width: 3),
                      CustomText(
                        text: "TRENDING",
                        size: FontSizes.xs,
                        weight: FontWeight.w700,
                        color: Colors.orange,
                      ),
                    ],
                  ),

                  const SizedBox(height: 3),

                  // Title
                  CustomText(
                    text: note.title,
                    size: FontSizes.md,
                    weight: FontWeight.w600,
                    color: AppColors.textPrimary,
                    maxLines: 1,
                  ),

                  const SizedBox(height: 3),

                  // Subject
                  CustomText(
                    text: note.subject,
                    size: FontSizes.sm,
                    weight: FontWeight.w500,
                    color: AppColors.textSecondary,
                    maxLines: 1,
                  ),

                  const Spacer(),

                  // Stats
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        color: Colors.amber,
                        size: 17,
                      ),
                      const SizedBox(width: 3),
                      CustomText(
                        text: note.avgRating.toStringAsFixed(1),
                        size: FontSizes.sm,
                        weight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),

                      const SizedBox(width: 16),

                      const Icon(
                        Icons.download_rounded,
                        color: AppColors.success,
                        size: 17,
                      ),
                      const SizedBox(width: 3),
                      CustomText(
                        text: note.downloadCount.toString(),
                        size: FontSizes.sm,
                        weight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TrendingBorderPainter extends CustomPainter {
  final double progress;

  _TrendingBorderPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = RRect.fromRectAndRadius(
      Offset.zero & size,
      const Radius.circular(14),
    );

    // Normal subtle border
    final baseBorder = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = AppColors.border.withValues(alpha: 0.5);

    canvas.drawRRect(rect, baseBorder);

    // Glowing ray
    final glowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 7)
      ..shader = SweepGradient(
        startAngle: 0,
        endAngle: math.pi * 2,
        colors: [
          Colors.transparent,
          Colors.transparent,
          AppColors.accentCoral.withValues(alpha: 0.15),
          AppColors.accentCoral.withValues(alpha: 0.7),
          Colors.white,
          AppColors.accentCoral.withValues(alpha: 0.7),
          AppColors.accentCoral.withValues(alpha: 0.15),
          Colors.transparent,
        ],
        stops: const [0.0, 0.35, 0.43, 0.47, 0.50, 0.53, 0.57, 0.65],
        transform: GradientRotation(progress * math.pi * 2),
      ).createShader(Offset.zero & size);

    canvas.drawRRect(rect, glowPaint);

    // Sharp ray
    final rayPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..shader = SweepGradient(
        startAngle: 0,
        endAngle: math.pi * 2,
        colors: [
          Colors.transparent,
          Colors.transparent,
          AppColors.accentCoral,
          Colors.white,
          AppColors.accentCoral,
          Colors.transparent,
        ],
        stops: const [0.0, 0.42, 0.48, 0.50, 0.52, 0.58],
        transform: GradientRotation(progress * math.pi * 2),
      ).createShader(Offset.zero & size);

    canvas.drawRRect(rect, rayPaint);
  }

  @override
  bool shouldRepaint(covariant _TrendingBorderPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
