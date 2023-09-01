import 'package:flutter/material.dart';

class PoliSmartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F2440),
        title: const Text('POLI-Smart'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Agregar aquí la lógica para la búsqueda.
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Agregar aquí la lógica para navegar a otra pantalla.
            },
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'Contenido de la pantalla POLI-Smart',
          style: TextStyle(fontSize: 24, color: Colors.black),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF0F2440),
              ),
              child: Text(
                'Menú',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: const Text('Opción 1'),
              onTap: () {
                // Agregar aquí la lógica para la opción 1.
              },
            ),
            ListTile(
              title: const Text('Opción 2'),
              onTap: () {
                // Agregar aquí la lógica para la opción 2.
              },
            ),
            // Agregar más elementos de menú según sea necesario.
          ],
        ),
      ),
    );
  }
}
