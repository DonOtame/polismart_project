import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:polismart_project/providers/auth_provider.dart';
import 'package:provider/provider.dart';

import 'screens/login_screen.dart';
//import 'screens/POLI-Smart_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    runApp(MyApp());
  } catch (error) {
    print('Error al inicializar Firebase: $error');
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        // Puedes agregar otros providers aquí según sea necesario.
      ],
      child: MaterialApp(
        title: 'Polismart Project',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: LoginScreen(),
        //home: PoliSmartScreen(),
      ),
    );
  }
}
