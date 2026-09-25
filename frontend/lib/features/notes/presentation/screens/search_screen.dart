import 'dart:async';
import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bounce/bounce.dart';
import 'package:flutter/material.dart';
import 'package:study_vault/core/config/app_colors.dart';
import 'package:study_vault/core/config/app_font_size.dart';
import 'package:study_vault/core/widgets/custom_text.dart';
import 'package:study_vault/core/widgets/custom_text_field.dart';
import 'package:study_vault/features/notes/data/notes_query_params.dart';
import 'package:study_vault/features/notes/data/models/notes_response_model.dart';
import 'package:study_vault/features/notes/presentation/screens/note_detail_screen.dart';
import 'package:study_vault/features/notes/presentation/widgets/lottie_search_container.dart';
import 'package:study_vault/features/notes/presentation/widgets/pdf_container.dart';
import 'package:study_vault/features/notes/presentation/widgets/recent_search_element.dart';
import 'package:study_vault/features/notes/presentation/widgets/search_skeleton_loader.dart';
import 'package:study_vault/features/notes/providers/filtered_notes_notifier.dart';
import 'package:study_vault/features/notes/providers/search_query_provider.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  late final ScrollController _scrollController;
  Timer? _debounce;

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      final searchQuery = ref.read(searchQueryProvider);
      if (_scrollController.position.extentAfter < 200) {
        log("****************Bottom of Listview****************");
        ref
            .read(
              filteredNotesProvider(
                NotesQueryParams(search: searchQuery),
              ).notifier,
            )
            .fetchMoreNotes();
      }
    });
    super.initState();
  }

  void onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(Duration(milliseconds: 400), () {
      final query = value.trim();
      if (query.isEmpty) {
        ref.read(searchQueryProvider.notifier).state = "";
        return;
      }
      if (query == ref.read(searchQueryProvider)) return;
      ref.read(searchQueryProvider.notifier).state = value;
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchQuery = ref.watch(searchQueryProvider);
    final isSearching = searchQuery.isNotEmpty;
    final searchData = ref.watch(
      filteredNotesProvider(NotesQueryParams(search: searchQuery)),
    );

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            AppBar(
              title: const CustomText(
                text: "Search Screen",
                size: FontSizes.xxl,
                weight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            CustomTextField(
              hintText: "Search notes, subjects, colleges",
              controller: _searchController,
              onChanged: onSearchChanged,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: isSearching
                  ? _buildResults(context, searchData)
                  : LottieSearchContainer(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentSearches() {
    return ListView(
      children: const [
        CustomText(
          text: "Recent Searches",
          size: FontSizes.xl,
          weight: FontWeight.w600,
        ),
        SizedBox(height: 10),
        RecentSearchElement(searchText: "Deadlocks"),
        SizedBox(height: 5),
        RecentSearchElement(searchText: "Normalization"),
        SizedBox(height: 5),
        RecentSearchElement(searchText: "Threads"),
      ],
    );
  }

  Widget _buildResults(
    BuildContext context,
    AsyncValue<NotesResponse> searchData,
  ) {
    return searchData.when(
      loading: () => const Center(child: SearchSkeletonLoader()),
      error: (error, stackTrace) => Center(
        child: CustomText(text: error.toString(), color: Colors.red),
      ),
      data: (data) {
        if (data.notes.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.search_off,
                  size: 40,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(height: 10),
                CustomText(
                  text: 'No notes found for "${_searchController.text}"',
                  color: AppColors.textSecondary,
                  size: FontSizes.lg,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }
        final notes = data.notes;
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: '${data.totalNotes} result${notes.length == 1 ? "" : "s"}',
              color: AppColors.textSecondary,
              size: FontSizes.md,
              weight: FontWeight.w600,
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: notes.length + (data.isLoadingMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == notes.length) {
                    return const Center(
                      child: CircularProgressIndicator(color: AppColors.info),
                    );
                  }
                  final note = notes[index];
                  return Bounce(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => NoteDetailScreen(
                            note: note,
                            totalNotes: note.user.totalNotes,
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
