import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proyek_akhir_semester/DetailBook/Models/comment.dart';

class CommentNotifier extends StateNotifier<List<Comment>> {
  CommentNotifier() : super([]);

  void addComment(Comment comment) {
    state = [...state, comment];
  }

  void removeComment(int index) {
    state = List.from(state)..removeAt(index);
  }

  List<Comment> getCommentsByBookId(int bookId) {
    return state.where((comment) => comment.bookId == bookId).toList();
  }
}

final commentNotifierProvider = StateNotifierProvider<CommentNotifier, List<Comment>>(
  (ref) => CommentNotifier(),
);
