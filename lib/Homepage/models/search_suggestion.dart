class SearchSuggestion {
  final bool isHistory;
  final String text;
  final String? historyId;
  final int? bookId;
  const SearchSuggestion({required this.isHistory, required this.text, required this.historyId, required this.bookId});
}