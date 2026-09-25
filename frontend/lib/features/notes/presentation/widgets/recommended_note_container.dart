import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:study_vault/core/config/app_colors.dart';
import 'package:study_vault/core/config/app_font_size.dart';
import 'package:study_vault/core/widgets/custom_text.dart';
import 'package:study_vault/features/notes/data/models/notes_model.dart';

class RecommendedPdfContainer extends StatefulWidget {
  final Note note;

  const RecommendedPdfContainer({super.key, required this.note});

  @override
  State<RecommendedPdfContainer> createState() =>
      _RecommendedPdfContainerState();
}

class _RecommendedPdfContainerState extends State<RecommendedPdfContainer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
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
          painter: _RecommendedBorderPainter(progress: _controller.value),
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
              color: const Color(0xFF7C83FF).withValues(alpha: 0.08),
              blurRadius: 14,
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
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF7C83FF).withValues(alpha: 0.18),
                    const Color(0xFF9C7CFF).withValues(alpha: 0.08),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF7C83FF).withValues(alpha: 0.22),
                ),
              ),
              child: const Icon(
                Icons.auto_awesome_rounded,
                color: Color(0xFF8C7CFF),
                size: 32,
              ),
            ),

            const SizedBox(width: 12),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Recommended badge
                  Row(
                    children: [
                      const Icon(
                        Icons.auto_awesome_rounded,
                        color: Color(0xFF8C7CFF),
                        size: 15,
                      ),
                      const SizedBox(width: 4),
                      CustomText(
                        text: "FOR YOU",
                        size: FontSizes.xs,
                        weight: FontWeight.w700,
                        color: const Color(0xFF8C7CFF),
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

class _RecommendedBorderPainter extends CustomPainter {
  final double progress;

  _RecommendedBorderPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = RRect.fromRectAndRadius(
      Offset.zero & size,
      const Radius.circular(14),
    );

    // Subtle permanent border
    final baseBorder = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = AppColors.border.withValues(alpha: 0.5);

    canvas.drawRRect(rect, baseBorder);

    // Soft glowing ray
    final glowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8)
      ..shader = SweepGradient(
        startAngle: 0,
        endAngle: math.pi * 2,
        colors: [
          Colors.transparent,
          Colors.transparent,
          const Color(0xFF7C83FF).withValues(alpha: 0.08),
          const Color(0xFF7C83FF).withValues(alpha: 0.35),
          const Color(0xFFD0CBFF).withValues(alpha: 0.8),
          const Color(0xFF7C83FF).withValues(alpha: 0.35),
          const Color(0xFF7C83FF).withValues(alpha: 0.08),
          Colors.transparent,
        ],
        stops: const [0.0, 0.35, 0.43, 0.47, 0.50, 0.53, 0.57, 0.65],
        transform: GradientRotation(progress * math.pi * 2),
      ).createShader(Offset.zero & size);

    canvas.drawRRect(rect, glowPaint);

    // Sharp light ray
    final rayPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4
      ..shader = SweepGradient(
        startAngle: 0,
        endAngle: math.pi * 2,
        colors: [
          Colors.transparent,
          Colors.transparent,
          const Color(0xFF7C83FF),
          const Color(0xFFE4E1FF),
          const Color(0xFF7C83FF),
          Colors.transparent,
        ],
        stops: const [0.0, 0.42, 0.48, 0.50, 0.52, 0.58],
        transform: GradientRotation(progress * math.pi * 2),
      ).createShader(Offset.zero & size);

    canvas.drawRRect(rect, rayPaint);
  }

  @override
  bool shouldRepaint(covariant _RecommendedBorderPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
