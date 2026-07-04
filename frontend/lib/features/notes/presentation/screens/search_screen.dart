import 'package:bounce/bounce.dart';
import 'package:flutter/material.dart';
import 'package:study_vault/core/config/app_colors.dart';
import 'package:study_vault/core/config/app_font_size.dart';
import 'package:study_vault/core/widgets/custom_text.dart';
import 'package:study_vault/core/widgets/custom_text_field.dart';
import 'package:study_vault/features/notes/presentation/screens/note_detail_screen.dart';
import 'package:study_vault/features/notes/presentation/widgets/pdf_container.dart';
import 'package:study_vault/features/notes/presentation/widgets/recent_search_element.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  String _query = "";

  // TODO: replace with real recent searches (e.g. from local storage/API).
  final List<String> _recentSearches = [
    "Deadlocks",
    "Normalization",
    "Threads",
  ];

  // TODO: replace with your search API results.
  List<dynamic> _results = [];
  bool _isLoading = false;

  Future<void> _search(String query) async {
    setState(() {
      _query = query;
      _isLoading = query.trim().isNotEmpty;
    });

    if (query.trim().isEmpty) {
      setState(() {
        _results = [];
        _isLoading = false;
      });
      return;
    }

    // TODO: call your search API here, e.g.
    // final response = await NotesApi.search(query);
    // setState(() { _results = response; _isLoading = false; });

    setState(() => _isLoading = false);
  }

  void _selectRecent(String term) {
    _controller.text = term;
    _controller.selection = TextSelection.fromPosition(
      TextPosition(offset: _controller.text.length),
    );
    _search(term);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSearching = _query.trim().isNotEmpty;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            const CustomText(
              text: "Search",
              size: FontSizes.display,
              weight: FontWeight.w600,
            ),
            const SizedBox(height: 12),
            CustomTextField(
              hintText: "Search notes, subjects, colleges",
              controller: _controller,
              onChanged: _search,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: isSearching ? _buildResults() : _buildRecentSearches(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentSearches() {
    if (_recentSearches.isEmpty) {
      return Center(
        child: CustomText(
          text: "No recent searches yet",
          color: AppColors.textSecondary,
          size: FontSizes.lg,
        ),
      );
    }

    return ListView(
      children: [
        const CustomText(
          text: "Recent Searches",
          size: FontSizes.xl,
          weight: FontWeight.w600,
        ),
        const SizedBox(height: 10),
        ..._recentSearches.map(
          (term) => Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: RecentSearchElement(
              searchText: term,
              onTap: () => _selectRecent(term),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResults() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_results.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off, size: 40, color: AppColors.textSecondary),
            const SizedBox(height: 10),
            CustomText(
              text: 'No notes found for "$_query"',
              color: AppColors.textSecondary,
              size: FontSizes.lg,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView(
      children: [
        CustomText(
          text:
              '${_results.length} result${_results.length == 1 ? "" : "s"} for "$_query"',
          color: AppColors.textSecondary,
          size: FontSizes.md,
          weight: FontWeight.w600,
        ),
        const SizedBox(height: 10),
        // TODO: map each item from your API response into a PdfContainer,
        // e.g. note.title, note.subject, note.rating, note.likes, note.downloads.
        ..._results.map(
          (note) => Bounce(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NoteDetailScreen(),
                ),
              );
            },
            child: const PdfContainer(),
          ),
        ),
      ],
    );
  }
}
