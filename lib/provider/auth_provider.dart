import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proyek_akhir_semester/models/user.dart';
class AuthUserNotifier extends StateNotifier<User?> {
  AuthUserNotifier() : super(null);

  void setUserData(User userData) {
    state = userData;
  }

  void clearUserData() {
    state = null;
  }
}

final authProvider = StateNotifierProvider<AuthUserNotifier, User?>((ref) {
  return AuthUserNotifier();
});