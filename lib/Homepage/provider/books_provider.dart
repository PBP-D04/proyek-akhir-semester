import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proyek_akhir_semester/Homepage/models/book.dart';
import 'package:proyek_akhir_semester/Homepage/models/like.dart';
import 'package:proyek_akhir_semester/Homepage/models/sorting_type.dart';

class BooksNotifier extends StateNotifier<Map<int, Book>>{
  BooksNotifier(Map<int, Book> state) : super(state);
  void addItem(Book book) {
    state = {...state, book.id: book};
  }
  void removeItem(Book book) {
    state = Map<int, Book>.from(state)..remove(book.id);
  }
  void updateItem(int id, Book book) {
    if (state.containsKey(id)) {
      state = {...state, id: book};
    }
  }
  void updateLikeStatus(int bookId, bool isLiked, int userId) {
    if (state.containsKey(bookId)) {
      Book updatedBook = state[bookId]!;
      if(isLiked){
        updatedBook.likes.add(Like(userId: userId, likedBookId: bookId, createdAt: DateTime.now()));
      } // Ubah status like pada objek buku
      else{
        updatedBook.likes.removeWhere((like) => like.userId == userId);
      }

      state = {...state, bookId: updatedBook}; // Perbarui objek buku dengan status like yang diperbarui
    }
  }

  Book? getBookById(int id) {
    return state[id];
  }
  void clearItems() {
    state = {};
  }


  List<Book> getAllItems() {
    return state.values.toList();
  }
  void setItems(Map<int, Book> newState){
    state = newState;
  }
}

final booksProvider = StateNotifierProvider<BooksNotifier, Map<int, Book>>((ref) {
  return BooksNotifier({});
});
final carouselBooksProvider = StateNotifierProvider<BooksNotifier, Map<int, Book>>((ref) {
  return BooksNotifier({});
});