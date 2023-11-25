import 'package:flutter_riverpod/flutter_riverpod.dart';

class WidgetRefSingleton {
  WidgetRefSingleton._privateConstructor();
  static final WidgetRefSingleton instance = WidgetRefSingleton._privateConstructor();

  WidgetRef? _ref = null;

  WidgetRef? get getRef => _ref;

  void setRef(WidgetRef value) {
    _ref = value;
  }
}