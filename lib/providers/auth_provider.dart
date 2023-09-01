import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum AuthStatus {
  Initial, // Estado inicial
  Success, // Autenticación exitosa
  Error, // Error en la autenticación
}

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  AuthStatus _authStatus = AuthStatus.Initial; // Estado inicial

  User? get user => _user;
  AuthStatus get authStatus => _authStatus; // Getter para el estado

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _user = userCredential.user;
      _authStatus = AuthStatus.Success; // Autenticación exitosa
      notifyListeners();
    } catch (e) {
      print(e.toString());
      _authStatus = AuthStatus.Error; // Error en la autenticación
    }
    notifyListeners();
  }

  Future<void> signOut() async {
    await _auth.signOut();
    _user = null;
    _authStatus =
        AuthStatus.Initial; // Vuelve al estado inicial al cerrar sesión
    notifyListeners();
  }
}
