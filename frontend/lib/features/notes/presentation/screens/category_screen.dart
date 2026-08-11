import 'dart:developer';

import 'package:bounce/bounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study_vault/core/config/app_colors.dart';
import 'package:study_vault/core/config/app_font_size.dart';
import 'package:study_vault/core/widgets/custom_text.dart';
import 'package:study_vault/features/notes/data/notes_query_params.dart';
import 'package:study_vault/features/notes/presentation/screens/note_detail_screen.dart';
import 'package:study_vault/features/notes/presentation/widgets/pdf_container.dart';
import 'package:study_vault/features/notes/providers/filtered_notifier.dart';

class CategoryScreen extends ConsumerStatefulWidget {
  final String categoryName;
  const CategoryScreen({super.key, required this.categoryName});

  @override
  ConsumerState<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends ConsumerState<CategoryScreen> {
  late final ScrollController _scrollController;
  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        ref
            .read(
              filteredNotesProvider(
                NotesQueryParams(subject: widget.categoryName),
              ).notifier,
            )
            .fetchMoreNotes();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final subjectNotifer = ref.watch(
      filteredNotesProvider(NotesQueryParams(subject: widget.categoryName)),
    );
    return subjectNotifer.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) =>
          Scaffold(body: Center(child: Text(error.toString()))),
      data: (data) {
        return Scaffold(
          appBar: AppBar(
            title: CustomText(
              text: widget.categoryName,
              size: FontSizes.xxl,
              weight: FontWeight.w600,
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CustomText(
                          text: data.totalNotes.toString(),
                          color: AppColors.primary,
                          size: FontSizes.xl,
                          weight: FontWeight.w600,
                        ),
                        const SizedBox(width: 4),
                        CustomText(
                          text: "notes found",
                          color: AppColors.textSecondary,
                          size: FontSizes.xl,
                          weight: FontWeight.w400,
                        ),
                      ],
                    ),
                    // CustomText(
                    //   text: "Semester IV",
                    //   color: AppColors.textSecondary,
                    //   size: FontSizes.xl,
                    //   weight: FontWeight.w400,
                    // ),
                  ],
                ),
                Divider(
                  color: AppColors.textSecondary,
                  thickness: 1,
                  height: 20,
                ),
                if (data.notes.isEmpty)
                  Expanded(
                    child: Center(
                      child: CustomText(
                        text: "No notes exist for ${widget.categoryName}",
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount:
                          data.notes.length + (data.isLoadingMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == data.notes.length) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.info,
                            ),
                          );
                        }
                        final notes = data.notes;
                        final note = notes[index];
                        log("note: ${note.title}");
                        return Bounce(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    NoteDetailScreen(note: note),
                              ),
                            );
                          },
                          child: PdfContainer(note: note),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
