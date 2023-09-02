import 'package:firebase_core/firebase_core.dart';
import 'package:polismart_project/providers/materia_provider.dart';

class FirebaseService {
  static Future<void> initializeFirebase() async {
    await Firebase.initializeApp();
  }
}

final materiaProvider = MateriaProvider();
