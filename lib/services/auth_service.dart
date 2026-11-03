import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  // INSCRIPTION
  Future<UserModel> register({
    required String firstName,
    required String lastName,
    required String location,
    required DateTime birthDate,
    required String email,
    required String password,
  }) async {
    // 1. Créer le compte Firebase
    UserCredential credential =
        await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    User firebaseUser = credential.user!;

    // 2. Enregistrer les informations supplémentaires
    UserModel user = UserModel(
      uid: firebaseUser.uid,
      firstName: firstName.trim(),
      lastName: lastName.trim(),
      location: location.trim(),
      birthDate: birthDate,
      email: email.trim(),
    );

    // 3. Enregistrer le profil dans Firestore
    await _firestore
        .collection('users')
        .doc(firebaseUser.uid)
        .set(user.toMap());

    return user;
  }

  // CONNEXION
  Future<UserCredential> login({
    required String email,
    required String password,
  }) async {
    return await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  // MOT DE PASSE OUBLIÉ
  Future<void> forgotPassword(String email) async {
    await _auth.sendPasswordResetEmail(
      email: email.trim(),
    );
  }

  // DÉCONNEXION
  Future<void> logout() async {
    await _auth.signOut();
  }

  // UTILISATEUR ACTUEL
  User? get currentUser => _auth.currentUser;

  // ÉTAT DE CONNEXION
  Stream<User?> get authStateChanges =>
      _auth.authStateChanges();
}