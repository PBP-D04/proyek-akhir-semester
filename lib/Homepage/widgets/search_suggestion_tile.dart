import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proyek_akhir_semester/Homepage/api/update_history.dart';
import 'package:proyek_akhir_semester/Homepage/models/history.dart';
import 'package:proyek_akhir_semester/Homepage/provider/search_history_provider.dart';
import 'package:proyek_akhir_semester/Homepage/screens/search_result_page.dart';
import '../models/search_suggestion.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

class SearchSuggestionWidget extends ConsumerWidget {
  final SearchSuggestion searchSuggestion;
  final String currentText;

  SearchSuggestionWidget({required this.searchSuggestion, required this.currentText});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      titleAlignment: ListTileTitleAlignment.threeLine,
      leading: searchSuggestion.isHistory ? Icon(Icons.history) : Icon(Icons.book),
      title:_buildHighlightedText(searchSuggestion.text, currentText),
      onTap: () async {
        print('aku diklik');
        if(searchSuggestion.isHistory){
            //todo: ke result page
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){
            return SearchResultPage(searchText: searchSuggestion.text);
          }));
        }
        else{ // ini suggestion untuk buku
          History history = History(text: searchSuggestion.text, time: DateTime.now(), historyId: uuid.v4() );
          ref.read(historyProvider.notifier).addHistorywithObject(history);
          addHistory(ref, history);
          //todo: implement ke page detail book untuk buku tersebut
        }
      },
      trailing: searchSuggestion.isHistory ? IconButton(icon: Icon(Icons.close_rounded),onPressed: () async {
        final histories =  ref.watch(historyProvider);
        List<History> history = histories.where((element) => element.historyId == searchSuggestion.historyId!).toList();
        if(history.isNotEmpty){
          deleteHistory(history[0]);
        }
        ref.read(historyProvider.notifier).removeHistory(searchSuggestion.historyId!);
      },) : null,

    );
  }

  Widget _buildHighlightedText(String text, String currentText) {
    final matches = _findAllMatches(text, currentText);

    if (matches.isEmpty) {
      return Text(text, style: TextStyle(color: Colors.black),);
    }

    final List<TextSpan> textSpans = [];
    int start = 0;

    for (final match in matches) {
      if (start < match.start) {
        textSpans.add(
          TextSpan(
            text: text.substring(start, match.start),
            style: TextStyle(
              color: Colors.black
            )
          ),
        );
      }

      textSpans.add(
        TextSpan(
          text: text.substring(match.start, match.end),
          style: TextStyle(color: Colors.indigoAccent.shade700),
        ),
      );

      start = match.end;
    }

    if (start < text.length) {
      textSpans.add(
        TextSpan(
          text: text.substring(start),
          style: TextStyle(color: Colors.black)
        ),
      );
    }

    return RichText(text: TextSpan(children: textSpans));
  }

  List<RegExpMatch> _findAllMatches(String text, String currentText) {
    final regExp = RegExp(currentText, caseSensitive: false);
    return regExp.allMatches(text).toList();
  }
}
