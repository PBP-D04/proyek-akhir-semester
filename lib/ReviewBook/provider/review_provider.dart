import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proyek_akhir_semester/models/review.dart';

class ReviewListNotifier extends StateNotifier<Map<int, Review>> {
  ReviewListNotifier() : super({});

  void addOrUpdateReview(Review review) {
    state[review.id] = review;
    state = {...state}; // Menggunakan spread operator untuk memicu pembaruan state
    print('GACORRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR');
  }

  void updateReview(Review updatedReview) {
    state = state.map((key, value) {
      return MapEntry(key, value.id == updatedReview.id ? updatedReview : value);
    });
  }

  void removeReview(int reviewId) {
    state = Map.fromEntries(state.entries.where((entry) => entry.value.id != reviewId));
  }

  void setAll(Map<int, Review> newReviewMap) {
    state = newReviewMap;
  }
}

final reviewListProvider =
StateNotifierProvider<ReviewListNotifier, Map<int, Review>>(
      (ref) => ReviewListNotifier(),
);
