import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/auth_service.dart';
import '../services/secure_storage_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  final SecureStorageService _storage =
      SecureStorageService();

  bool isLoading = false;
  String? errorMessage;

  Future<bool> register({
    required String firstName,
    required String lastName,
    required String location,
    required DateTime birthDate,
    required String email,
    required String password,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final user = await _authService.register(
        firstName: firstName,
        lastName: lastName,
        location: location,
        birthDate: birthDate,
        email: email,
        password: password,
      );

      await _storage.saveUserId(user.uid);

      return true;
    } on FirebaseAuthException catch (e) {
      errorMessage = e.message ?? 'Erreur d’inscription';
      return false;
    } catch (e) {
      errorMessage = 'Une erreur est survenue.';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final credential = await _authService.login(
        email: email,
        password: password,
      );

      await _storage.saveUserId(
        credential.user!.uid,
      );

      return true;
    } on FirebaseAuthException catch (e) {
      errorMessage = e.message ?? 'Erreur de connexion';
      return false;
    } catch (e) {
      errorMessage = 'Une erreur est survenue.';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> forgotPassword(String email) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _authService.forgotPassword(email);
      return true;
    } on FirebaseAuthException catch (e) {
      errorMessage = e.message ?? 'Erreur d’envoi';
      return false;
    } catch (e) {
      errorMessage = 'Une erreur est survenue.';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    await _storage.clearUserId();
    notifyListeners();
  }
}