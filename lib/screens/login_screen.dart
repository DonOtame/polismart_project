import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:polismart_project/providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _signIn(BuildContext context, AuthProvider authProvider) async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    if (email.isNotEmpty && password.isNotEmpty) {
      await authProvider.signInWithEmailAndPassword(email, password);
      final authStatus = authProvider.authStatus;
      if (authStatus == AuthStatus.Success) {
        _showSnackBar(context, 'Inicio de sesión exitoso');
      } else if (authStatus == AuthStatus.Error) {
        _showSnackBar(
            context, 'Error al iniciar sesión. Comprueba tus credenciales.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      key: _scaffoldKey, // Clave para el ScaffoldMessenger
      body: ListView(
        // Cambiamos SingleChildScrollView por ListView
        children: [
          const SizedBox(height: 20.0), // Espacio arriba de la imagen
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Image.network(
              'https://firebasestorage.googleapis.com/v0/b/polismart-6f6ee.appspot.com/o/logo.png?alt=media&token=10ca46a6-b6f8-4046-b8c0-457c1ee70bb6',
              width: 200.0, // Ajusta el ancho según tus necesidades
              height: 200.0, // Ajusta la altura según tus necesidades
            ),
          ),
          const SizedBox(height: 20.0), // Espacio debajo de la imagen
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Correo electrónico',
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: 'Contraseña',
                prefixIcon: Icon(Icons.lock),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
              ),
              obscureText: true,
            ),
          ),
          const SizedBox(height: 32.0),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () => _signIn(context, authProvider),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F2440), // Color del botón
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                child: const Text(
                  'Iniciar sesión',
                  style: TextStyle(
                    color: Colors.white, // Color del texto del botón
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
