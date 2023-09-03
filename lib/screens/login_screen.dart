import 'package:flutter/material.dart';
import 'package:polismart_project/screens/POLI-Smart_screen.dart';
import 'package:polismart_project/widgets/login_textfied.dart';
import 'package:polismart_project/widgets/logo_widget.dart';
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

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      key: _scaffoldKey,
      body: ListView(
        children: [
          SizedBox(height: 20.0),
          buildLogo(),
          SizedBox(height: 20.0),
          buildTextField(
            controller: emailController,
            labelText: 'Correo electrónico',
            prefixIcon: Icons.email,
          ),
          buildTextField(
            controller: passwordController,
            labelText: 'Contraseña',
            prefixIcon: Icons.lock,
            obscureText: true,
          ),
          SizedBox(height: 32.0),
          buildSignInButton(context, authProvider),
        ],
      ),
    );
  }

  Widget buildSignInButton(BuildContext context, AuthProvider authProvider) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        onPressed: () => _signIn(context, authProvider),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0F2440),
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
              color: Colors.white,
              fontSize: 16.0,
            ),
          ),
        ),
      ),
    );
  }

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
      try {
        await authProvider.signInWithEmailAndPassword(email, password);
        final authStatus = authProvider.authStatus;
        if (authStatus == AuthStatus.Success) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => PoliSmartScreen(),
            ),
          );
          _showSnackBar(context, 'Inicio de sesión exitoso');
        } else if (authStatus == AuthStatus.Error) {
          _showSnackBar(
            context,
            'Error al iniciar sesión. Comprueba tus credenciales.',
          );
        }
      } catch (e) {
        _showSnackBar(
            context, 'Error al iniciar sesión. Comprueba tus credenciales.');
      }
    }
  }
}
