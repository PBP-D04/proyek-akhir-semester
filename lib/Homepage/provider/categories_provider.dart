import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoriesState{
  final String currentSelectedCategory;
  final List<String> categories;
  const CategoriesState({required this.currentSelectedCategory, required this.categories});
}
final categoriesProvider = StateProvider<CategoriesState>((ref) => CategoriesState(currentSelectedCategory: 'All', categories: [], ));