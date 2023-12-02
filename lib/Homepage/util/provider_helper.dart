
import 'dart:math';
import 'package:proyek_akhir_semester/Homepage/provider/preference_provider.dart';

import '../models/book.dart';
import '../models/sorting_type.dart';
import '../models/search_suggestion.dart';
import '../models/history.dart';


List<SearchSuggestion> createSuggestions (List<Book> books, List<History> history){
  List<SearchSuggestion> suggestions = [];

  // Menambahkan riwayat pencarian ke dalam daftar saran
  suggestions.addAll(
    history.map((hist) => SearchSuggestion(
        isHistory: true,
        text: hist.text,
        historyId: hist.historyId,
      bookId: null
    )),
  );
  // Menambahkan buku ke dalam daftar saran
  suggestions.addAll(
    books.map((book) => SearchSuggestion(
      isHistory: false,
      text: book.title,
      historyId: null,
      bookId: book.id
    )),
  );


  return suggestions;
}

class OffsetSingleton {
  OffsetSingleton._privateConstructor();
  static final OffsetSingleton instance = OffsetSingleton._privateConstructor();

  double _offset = 0.0;

  double get offset => _offset;

  void setOffset(double value) {
    _offset = value;
  }
}

List<Book> sorting(SortingType type, List<Book> books) {
  List<Book> sortedBooks = List.from(books);

  switch (type) {
    case SortingType.terbaru:
      sortedBooks.sort((a, b) => DateTime.parse(b.userPublishTime)
          .compareTo(DateTime.parse(a.userPublishTime)));
      break;
    case SortingType.terlama:
      sortedBooks.sort((a, b) => DateTime.parse(a.userPublishTime)
          .compareTo(DateTime.parse(b.userPublishTime)));
      break;
    case SortingType.ulasan:
      sortedBooks.sort((a, b) => b.reviews.length.compareTo(a.reviews.length));
      break;
    case SortingType.rating:
      sortedBooks.sort((a, b) => b.calculateAverageStars().compareTo(a.calculateAverageStars()));
      break;
  // Tambahkan kasus lainnya sesuai kebutuhan sorting
    default:
      break;
  }
  return sortedBooks;
}


List<Book> filterBooks (List<Book> books, String selectedCategory, Preference preference) {

  print(preference.saleabilityOption);

  bool checkMaturity(String rating, Book book)=> rating.toLowerCase() == 'all'? true :
    rating.toLowerCase() == 'mature'? book.maturityRating.toLowerCase() == 'mature' :
    book.maturityRating.toLowerCase() != 'mature'; //FIX
  bool checkSaleability(String saleability, Book book)=> saleability.toLowerCase() == 'all'? true:
    saleability.toLowerCase() == 'paid purchase'? book.saleability == true : book.saleability == false; // FIX
  bool checkMinAvgRating(String rating, Book book)=> rating.toLowerCase() == 'default'? true :
      book.calculateAverageStars() >= double.parse(rating); // FIX
  bool checkAvailability(String availability, Book book) => availability.toLowerCase() == 'all'? true :
      availability.toLowerCase() == 'PDF'? book.pdfAvailable : book.pdfAvailable;// FIX
  bool checkMinPrice(String minPrice,Book book) => book.price == null? true : book.price!.isEmpty? true :
  double.parse(minPrice) <= double.parse(book.price!);
  bool checkMaxPrice(String maxPrice,Book book) => book.price == null? true : book.price!.isEmpty? true :
  double.parse(maxPrice) >= double.parse(book.price!);
  bool checkMaxYear(String maxYear, Book book) =>  book.publishedDate == null? true : book.publishedDate!.isEmpty? true:
  DateTime.parse(maxYear+'-12-31').compareTo(DateTime.parse(book.publishedDate!)) >= 0;
  bool checkMinYear(String minYear, Book book) =>  book.publishedDate == null? true : book.publishedDate!.isEmpty? true:
  DateTime.parse(minYear+'-01-01').compareTo(DateTime.parse(book.publishedDate!)) <= 0;

  Function checkMaxYearVar = checkMaxYear;
  Function checkMinYearVar = checkMinYear;
  Function checkMinPriceVar = checkMinPrice;
  Function checkMaxPriceVar = checkMaxPrice;

  if(preference.minYear.isEmpty){
    checkMinYearVar = (a,b)=> true;
  }
  if(preference.maxYear.isEmpty){
    checkMaxYearVar =(a,b)=> true;
  }
  if(preference.minPrice.isEmpty){
    checkMinPriceVar = (a,b)=> true;
  }
  if(preference.maxPrice.isEmpty){
    checkMaxPriceVar = (a,b) => true;
  }
  switch(selectedCategory){
    case 'All':
      return books.where((book) => checkMaxPriceVar(preference.maxPrice, book)  == true&&
          checkMinPriceVar(preference.minPrice, book) == true  &&
          checkMaxYearVar(preference.maxYear, book) == true &&
          checkMinYearVar(preference.minYear, book) == true &&
          checkAvailability(preference.availability, book) == true &&
          checkMinAvgRating(preference.minAvgRating!, book) == true &&
          checkSaleability(preference.saleabilityOption, book) == true &&
          checkMaturity(preference.maturityRating, book) == true).toList();

    default:
      return books.where((book) => book.categories.contains(selectedCategory) &&
          checkMaxPriceVar(preference.maxPrice, book)  == true&&
          checkMinPriceVar(preference.minPrice, book) == true  &&
          checkMaxYearVar(preference.maxYear, book) == true &&
          checkMinYearVar(preference.minYear, book) == true &&
          checkAvailability(preference.availability, book) == true &&
          checkMinAvgRating(preference.minAvgRating!, book) == true &&
          checkSaleability(preference.saleabilityOption, book) == true &&
          checkMaturity(preference.maturityRating, book) == true
      ).toList();
  }
}

Map<int, Book> takeFiveRandomSamples(Map<int, Book> map) {
  Random random = Random();
  List<Book> list = map.values.toList();
  List<Book> resultList = List.from(list);

  if (resultList.length <= 5) {
    return Map.from(map);
  }

  resultList.shuffle(random);
  resultList = resultList.sublist(0, 5);
  Map<int, Book> resultMap = {};

  for (var i = 0; i < resultList.length; i++) {
    resultMap[resultList[i].id] = resultList[i];
  }

  return resultMap;
}