import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:study_vault/core/constans/college_branches.dart';
import 'package:study_vault/features/auth/providers/user_profile_provider.dart';
import 'package:study_vault/features/notes/presentation/screens/category_screen.dart';
import 'package:study_vault/features/notes/presentation/widgets/sub_tab.dart';

class HomeScreenTabBar extends ConsumerWidget {
  const HomeScreenTabBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedSubjects = ref.watch(
      userProfileProvider.select((profile) => profile.value?.subjects ?? []),
    );
    return SizedBox(
      height: 40,
      child: ListView.builder(
        // itemCount: AppConstants.mvpSubjectsByBranch["CSE"]!.length,
        itemCount: selectedSubjects.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return SubTab(
            title: selectedSubjects[index],
            isSelected: true,
            onTap: () {
              print("Selected: ${selectedSubjects[index]}");
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      CategoryScreen(categoryName: selectedSubjects[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
