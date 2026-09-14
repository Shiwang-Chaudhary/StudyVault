import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:study_vault/core/config/app_colors.dart';
import 'package:study_vault/core/config/app_font_size.dart';
import 'package:study_vault/core/helperFunc/date_time_format.dart';
import 'package:study_vault/core/helperFunc/get_inital_char.dart';
import 'package:study_vault/core/widgets/custom_text.dart';
import 'package:study_vault/features/auth/providers/user_profile_provider.dart';

class ProfileSection extends ConsumerWidget {
  const ProfileSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileProvider = ref.watch(userProfileProvider);
    return profileProvider.when(
      loading: () =>
          Center(child: CircularProgressIndicator(color: AppColors.info)),
      error: (error, stackTrace) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline),
            const SizedBox(height: 8),
            CustomText(text: error.toString()),
          ],
        ),
      ),
      data: (user) {
        final date = formatJoinedDate(user.createdAt);
        Map<String, dynamic> containerData = {
          "Bookmarks": user.totalBookmarks,
          "Rating": user.avgRating,
          "Notes": user.totalNotes,
        };
        final items = containerData.entries.toList();
        return Column(
          children: [
            const SizedBox(height: 10),
            CircleAvatar(
              radius: 45,
              backgroundColor: AppColors.primaryMuted,
              child: CustomText(
                text: getInitials(user.name),
                size: FontSizes.hero,
                color: AppColors.borderFocused,
              ),
            ),
            const SizedBox(height: 10),
            CustomText(
              text: user.name,
              size: FontSizes.xxl,
              weight: FontWeight.w600,
            ),
            CustomText(
              text: "${user.college} | ${user.branch}",
              size: FontSizes.lg,
              weight: FontWeight.w400,
              color: AppColors.textSecondary,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 1),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 1,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryMuted,
                    // border: Border.all(color: AppColors.primary, width: 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomText(
                    text: user.semester ?? "NULL",
                    size: FontSizes.md,
                    weight: FontWeight.w400,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 10),
                CustomText(
                  text: date,
                  size: FontSizes.md,
                  weight: FontWeight.w400,
                  color: AppColors.textTertiary,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                items.length,
                (index) => Expanded(
                  child: Container(
                    height: 76,
                    margin: const EdgeInsets.only(top: 10, left: 6, right: 6),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        // horizontal: 8.0,
                        vertical: 8.0,
                      ),
                      child: Column(
                        children: [
                          CustomText(
                            text: items[index].value.toString(),
                            size: FontSizes.xxl,
                            color: AppColors.textPrimary,
                          ),
                          CustomText(
                            text: items[index].key,
                            size: FontSizes.md,
                            weight: FontWeight.w400,
                            color: AppColors.textSecondary,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
