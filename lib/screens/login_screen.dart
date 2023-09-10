import 'package:flutter/material.dart';
import 'package:polismart_project/screens/POLI-Smart_screen.dart';
import 'package:polismart_project/widgets/login_textfied.dart';
import 'package:polismart_project/widgets/logo_widget.dart';
import 'package:provider/provider.dart';
import 'package:polismart_project/providers/auth_provider.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          SizedBox(height: 20.0),
          buildLogo(),
          SizedBox(height: 20.0),
          buildForm(context),
          SizedBox(height: 32.0),
          buildSignInButton(context),
        ],
      ),
    );
  }

  Widget buildForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
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
        ],
      ),
    );
  }

  Widget buildSignInButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        onPressed: () => _signIn(context),
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
        duration: const Duration(seconds: 1),
      ),
    );
  }

  Future<void> _signIn(BuildContext context) async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

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
