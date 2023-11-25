import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/sorting_type.dart';


class Preference {
  SortingType sortingType;
  bool isWelcomeClosed;
  String maturityRating;
  String saleabilityOption;
  String? minAvgRating;
  String minPrice;
  String maxPrice;
  String availability;
  String minYear;
  String maxYear;

  Preference({
    required this.sortingType,
    required this.isWelcomeClosed,
    required this.maturityRating,
    required this.saleabilityOption,
    required this.minAvgRating,
    required this.minPrice,
    required this.maxPrice,
    required this.availability,
    required this.minYear,
    required this.maxYear
  });
}

class PreferenceNotifier extends StateNotifier<Preference> {
  PreferenceNotifier() : super(Preference(
    sortingType: SortingType.terbaru,
    isWelcomeClosed: false,
    maturityRating: 'All',
    saleabilityOption: 'All',
    minAvgRating: 'Default',
    minPrice: '',
    maxPrice: '',
    availability: 'All',
    minYear: '',
    maxYear: ''
  ));
  // Add other update methods here for different fields

  void updateStateWith({
    String? minYear,
    String? maxYear,
    SortingType? sortingType,
    bool? isWelcomeClosed,
    String? maturityRating,
    String? saleabilityOption,
    String? minAvgRating,
    String? minPrice,
    String? maxPrice,
    String? availability,
  }) {
    state =  Preference(
      minYear: minYear ?? state.minYear,
      maxYear: maxYear ?? state.maxYear,
      sortingType: sortingType ?? state.sortingType,
      isWelcomeClosed: isWelcomeClosed ?? state.isWelcomeClosed,
      maturityRating: maturityRating ?? state.maturityRating,
      saleabilityOption: saleabilityOption ?? state.saleabilityOption,
      minAvgRating: minAvgRating ?? state.minAvgRating,
      minPrice: minPrice ?? state.minPrice,
      maxPrice: maxPrice ?? state.maxPrice,
      availability: availability ?? state.availability,
    );
  }
}

final preferenceProvider =
StateNotifierProvider<PreferenceNotifier, Preference>((ref) => PreferenceNotifier());
