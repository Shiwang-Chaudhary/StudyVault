import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:study_vault/core/config/app_font_size.dart';
import 'package:study_vault/core/widgets/custom_text.dart';
import 'package:study_vault/features/notes/data/notes_query_params.dart';
import 'package:study_vault/features/notes/presentation/screens/note_detail_screen.dart';
import 'package:study_vault/features/notes/presentation/widgets/pdf_container.dart';
import 'package:study_vault/features/notes/presentation/widgets/sub_tab.dart';
import 'package:study_vault/features/notes/providers/filtered_notes_notifier.dart';

class UploaderNotesSection extends ConsumerWidget {
  final String userId;
  const UploaderNotesSection({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesProvider = ref.watch(
      filteredNotesProvider(NotesQueryParams(userId: userId)),
    );
    return notesProvider.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) =>
          Center(child: CustomText(text: error.toString())),
      data: (notesResponse) {
        final notes = notesResponse.notes;
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const CustomText(
                  text: "Notes by name",
                  size: FontSizes.xxl,
                  weight: FontWeight.w600,
                ),

                Row(
                  children: [
                    SubTab(isSelected: true, title: "Top rated"),
                    SubTab(title: "Recent", isSelected: false),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 10),
            if (notes.isEmpty)
              const Center(
                child: CustomText(
                  text: "No notes uploaded yet.",
                  size: FontSizes.lg,
                ),
              ),
            // Notes
            Expanded(
              child: ListView.builder(
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NoteDetailScreen(
                            note: notes[index],
                            totalNotes: notesResponse.totalNotes,
                          ),
                        ),
                      );
                    },
                    child: PdfContainer(note: notes[index]),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
