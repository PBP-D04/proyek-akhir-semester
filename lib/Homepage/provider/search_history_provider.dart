import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proyek_akhir_semester/Homepage/models/history.dart';

class HistoryNotifier extends StateNotifier<List<History>> {
  HistoryNotifier() : super([]);

  void addHistory(String searchText) {
    final newHistory = History(text: searchText, time: DateTime.now());
    state = [...state, newHistory];
  }
  void addHistoryWithId(String searchText, String historyId){
    final newHistory = History(text: searchText, time: DateTime.now(), historyId: historyId);
    state = [...state, newHistory];
  }

  void addHistorywithObject(History history){
    state = [...state,history];
  }
  void setAllHistory(List<History> histories){
    state = histories;
  }
  void removeHistory(String id){
    state =  state.where((history) => history.historyId != id).toList();
  }

  void clearHistory() {
    state = [];
  }
}

final historyProvider = StateNotifierProvider<HistoryNotifier, List<History>>((ref) {
  return HistoryNotifier();
});