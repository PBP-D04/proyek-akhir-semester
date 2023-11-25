enum SortingType {
  terbaru,
  terlama,
  rating,
  ulasan,
}
SortingType convertToSortingType(String value) {
  switch (value) {
    case 'Terbaru':
      return SortingType.terbaru;
    case 'Terlama':
      return SortingType.terlama;
    case 'Rating':
      return SortingType.rating;
    case 'Sering Diulas':
      return SortingType.ulasan;
    default:
      throw Exception('Unknown value: $value');
  }
}


extension SortingTypeExtension on SortingType {
  String get value {
    switch (this) {
      case SortingType.terbaru:
        return 'Terbaru';
      case SortingType.terlama:
        return 'Terlama';
      case SortingType.rating:
        return 'Rating';
      case SortingType.ulasan:
        return 'Sering Diulas';
      default:
        return '';
    }
  }
}