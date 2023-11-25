


import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proyek_akhir_semester/Homepage/api/update_history.dart';
import 'package:proyek_akhir_semester/Homepage/models/search_suggestion.dart';
import 'package:proyek_akhir_semester/Homepage/provider/books_provider.dart';
import 'package:proyek_akhir_semester/Homepage/provider/search_history_provider.dart';
import 'package:proyek_akhir_semester/Homepage/screens/search_result_page.dart';
import 'package:proyek_akhir_semester/Homepage/util/provider_helper.dart';
import 'package:proyek_akhir_semester/Homepage/widgets/book_tile.dart';
import 'package:proyek_akhir_semester/Homepage/widgets/search_suggestion_tile.dart';
import 'package:proyek_akhir_semester/models/responsive.dart';
import 'package:proyek_akhir_semester/util/responsive_config.dart';
import 'package:proyek_akhir_semester/Homepage/models/history.dart';
import 'package:uuid/uuid.dart';
import '../models/book.dart';

class SearchPage extends ConsumerStatefulWidget{

  final String initialSearchText;
  const SearchPage({super.key, this.initialSearchText = ''});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    // TODO: implement createState
    return _SearchPageState();
  }
}
class _SearchPageState extends ConsumerState<SearchPage>{
  final SearchController _searchController = SearchController();
  String currentSearchText = '';
  ResponsiveValue responsiveValue = ResponsiveValue();

  @override
  void initState(){
    super.initState();
    _searchController.text = widget.initialSearchText;
    currentSearchText = widget.initialSearchText;
  }

  Future<void> onSubmit ()async{
    if(currentSearchText.trim().isEmpty){
      return;
    }
    History history = History(text: currentSearchText, time: DateTime.now());
    ref.read(historyProvider.notifier).addHistorywithObject(history);
    addHistory(ref, history);
    //todo: ke result page
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){
      return SearchResultPage(searchText: currentSearchText);
    }));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _searchController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final books = ref.watch(booksProvider);
    final histories = ref.watch(historyProvider);
    List<Book> bookList = books.entries
        .map((entry) => entry.value).toList();
    bookList.sort((a,b) => b.reviews.length.compareTo(a.reviews.length));
    List<Book> popularBookList = bookList.sublist(0,bookList.length > 12 ? 12 : bookList.length);
    List<Book> bookPredictions = currentSearchText.trim().isEmpty? [] : bookList.where((book) =>
        book.title.toLowerCase().contains(currentSearchText.toLowerCase())).toList();
    final List<SearchSuggestion>suggestions =
      createSuggestions(bookPredictions, currentSearchText.trim().isEmpty?histories:histories.where((history) =>
          history.text.toLowerCase().trim().contains(currentSearchText.toLowerCase().trim())
      ).toList());
    final List<SearchSuggestion> selectedSuggestions = suggestions.sublist(0, suggestions.length > 12 ? 12 : suggestions.length);
    

    responsiveValue.setResponsive(context);
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          Expanded(child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(onPressed: (){
                          Navigator.of(context).pop();
                        }, icon: const Icon(Icons.arrow_back,color: Colors.black,)),
                        Expanded(child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(child: Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [LayoutBuilder(builder: (context, constraints){
                                  return SizedBox(
                                    width: MediaQuery.of(context).size.width > 768 ? 768 : constraints.maxWidth ,
                                    height: 56,
                                    // Add padding around the search bar
                                    // Use a Material design search bar
                                    child: Padding(
                                      padding: EdgeInsets.symmetric( vertical: 8),
                                      child: LayoutBuilder(
                                        builder: (context, constraints){
                                          return SizedBox(
                                            width: MediaQuery.of(context).size.width > 768 ? 768 : constraints.maxWidth,
                                            child:  TextField(
                                              onSubmitted: (value){
                                                onSubmit();
                                              },
                                              onChanged: (value){
                                                setState(() {
                                                  currentSearchText = value;
                                                });
                                              },
                                              textAlignVertical: TextAlignVertical.bottom,
                                              controller: _searchController,
                                              decoration: InputDecoration(
                                                hintText: 'Cari di Bookphoria',
                                                // Add a clear button to the search bar
                                                suffixIcon: IconButton(
                                                  icon: Icon(Icons.clear),
                                                  onPressed: (){
                                                    _searchController.clear();
                                                    setState(() {
                                                      currentSearchText = '';
                                                    });
                                                    },
                                                ),
                                                // Add a search icon or button to the search bar
                                                prefixIcon: IconButton(
                                                  icon: Icon(Icons.search),
                                                  onPressed: () {
                                                    // Perform the search here
                                                    onSubmit();
                                                  },
                                                ),
                                                border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(20.0),
                                                ),
                                              ),
                                            ),);
                                        },
                                      ),
                                    ),
                                  );
                                },)],
                              ),
                            ))
                          ],
                        )),
                      ],
                    ),
                  ],
                )
            ),
          ))
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
              child: LayoutBuilder(builder: (context, constraints){
                return SizedBox(
                  width: MediaQuery.of(context).size.width > 1024 ? 1024 : constraints.maxWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                          padding:EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          width: MediaQuery.of(context).size.width > 1024 ? 1024 : constraints.maxWidth,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Flexible(child: ListView.builder(
                                      itemCount:selectedSuggestions.length > 6? 6 : selectedSuggestions.length,
                                      shrinkWrap: true,
                                      itemBuilder: (context,index){
                                        return SearchSuggestionWidget(searchSuggestion: selectedSuggestions.elementAt(index),
                                          currentText: currentSearchText,);
                                      }),),
                                  if(selectedSuggestions.length > 6 && getScreenSize(context) != ScreenSize.small)
                                    Flexible(child: ListView.builder(
                                        itemCount:selectedSuggestions.length-6,
                                        shrinkWrap: true,
                                        itemBuilder: (context,index){
                                          return SearchSuggestionWidget(searchSuggestion:
                                          selectedSuggestions.elementAt(index+6),
                                                currentText: currentSearchText);
                                        })),
                                  
                                ],
                              ),
                            ],
                          )
                      )
                    ],
                  ),
                );
              },
              )
          ),
          SliverToBoxAdapter(
            child: LayoutBuilder(builder: (context, constraints){
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 8),
                width: MediaQuery.of(context).size.width > 1024 ? 1024 : constraints.maxWidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      decoration:BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(10)
                      ),
                      padding:EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      width: MediaQuery.of(context).size.width > 1024 ? 1024 : constraints.maxWidth,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(width: 8,),
                              Text('Buku terpopuler', textAlign: TextAlign.left, style: TextStyle(
                                  fontSize: responsiveValue.extraTitleFontSize,
                                  fontWeight: FontWeight.bold),),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(child: ListView.builder(
                                  itemCount:popularBookList.length > 6? 6 : popularBookList.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context,index){
                                    return BookListTile(book: popularBookList.elementAt(index));
                                  }),),
                              if(popularBookList.length > 6 && getScreenSize(context) != ScreenSize.small)
                                Flexible(child: ListView.builder(
                                    itemCount:popularBookList.length-6,
                                    shrinkWrap: true,
                                    itemBuilder: (context,index){
                                      return BookListTile(book: popularBookList.elementAt(index+6));
                                    })),
                            ],
                          ),
                        ],
                      )
                    )
                  ],
                ),
              );
            },
            )
          )
        ],
      ),
    );
  }
}