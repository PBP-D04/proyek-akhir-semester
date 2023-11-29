import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proyek_akhir_semester/models/review.dart';

class ReviewListNotifier extends StateNotifier<List<Review>> {
  ReviewListNotifier() : super([]);

  void addReview(Review review) {
    state = [...state, review];
  }

  void updateReview(Review updatedReview) {
    state = state.map((review) {
      return review.id == updatedReview.id ? updatedReview : review;
    }).toList();
  }

  void removeReview(int reviewId) {
    state = state.where((review) => review.id != reviewId).toList();
  }
}

final reviewListProvider = StateNotifierProvider<ReviewListNotifier, List<Review>>(
  (ref) => ReviewListNotifier(),
);
