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
  static const MaterialColor customPrimaryColor = MaterialColor(
    0xFF0F2440, // Color personalizado
    <int, Color>{
      50: Color(0xFF0F2440),
      100: Color(0xFF0F2440),
      200: Color(0xFF0F2440),
      300: Color(0xFF0F2440),
      400: Color(0xFF0F2440),
      500: Color(0xFF0F2440),
      600: Color(0xFF0F2440),
      700: Color(0xFF0F2440),
      800: Color(0xFF0F2440),
      900: Color(0xFF0F2440),
    },
  );
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
          primarySwatch: customPrimaryColor,
        ),
        home: LoginScreen(),
        //home: PoliSmartScreen(),
      ),
    );
  }
}
