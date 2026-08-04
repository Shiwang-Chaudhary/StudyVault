import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:study_vault/core/config/app_colors.dart';
import 'package:study_vault/core/config/app_font_size.dart';
import 'package:study_vault/core/widgets/custom_text.dart';
import 'package:study_vault/features/notes/data/notes_model.dart';
import 'package:study_vault/features/notes/presentation/screens/note_detail_screen.dart';
import 'package:study_vault/features/notes/presentation/widgets/pdf_container.dart';
import 'package:study_vault/features/notes/providers/my_notes_notifier.dart';

class NotesSection extends ConsumerStatefulWidget {
  const NotesSection({super.key});

  @override
  ConsumerState<NotesSection> createState() => _NotesSectionState();
}

class _NotesSectionState extends ConsumerState<NotesSection> {
  late final ScrollController _scrollController;
  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        ref.read(myNotesNotifierProvider.notifier).fetchMoreNotes();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final myNotesState = ref.watch(myNotesNotifierProvider);
    return myNotesState.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(child: Text(error.toString())),
      data: (data) {
        final notes = data.notes;
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const CustomText(
                  text: "My notes",
                  size: FontSizes.xxl,
                  weight: FontWeight.w600,
                ),
                CustomText(
                  text: "${data.totalNotes} notes",
                  size: FontSizes.lg,
                  weight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ],
            ),
            const SizedBox(height: 15),
            SizedBox(
              height: 513,
              child: ListView.builder(
                controller: _scrollController,
                padding: EdgeInsets.all(0),
                itemCount: notes.length + (data.isLoadingMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == notes.length) {
                    return const Center(
                      child: CircularProgressIndicator(color: AppColors.info),
                    );
                  }
                  final Note note = notes[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => NoteDetailScreen(
                            note: note,
                            totalNotes: data.totalNotes,
                          ),
                        ),
                      );
                    },
                    child: PdfContainer(note: note),
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
