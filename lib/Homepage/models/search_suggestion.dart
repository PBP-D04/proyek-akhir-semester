class SearchSuggestion {
  final bool isHistory;
  final String text;
  final String? historyId;
  const SearchSuggestion({required this.isHistory, required this.text, required this.historyId});
}