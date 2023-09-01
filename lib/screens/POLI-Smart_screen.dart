import 'package:flutter/material.dart';

class PoliSmartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('POLI-Smart'), // Nombre de la aplicación
        actions: [
          // Botón de búsqueda
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Implementa la lógica para abrir el panel de búsqueda
              // Puedes utilizar un showModalBottomSheet o Navigator para navegar a una pantalla de búsqueda.
            },
          ),
          // Botón de agregar
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Implementa la lógica para abrir la pantalla de agregar
              // Puedes utilizar Navigator para navegar a la pantalla correspondiente.
            },
          ),
        ],
      ),
      body: const Center(
        child: Text(
            'Contenido de la pantalla'), // Puedes agregar el contenido de tu pantalla aquí
      ),
      drawer: Drawer(
        // Menú desplegable
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
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
              title: const Text('Pantalla 1'), // Nombre de la pantalla 1
              onTap: () {
                // Implementa la lógica para navegar a la pantalla 1
                // Puedes utilizar Navigator para navegar.
              },
            ),
            ListTile(
              title: const Text('Pantalla 2'), // Nombre de la pantalla 2
              onTap: () {
                // Implementa la lógica para navegar a la pantalla 2
                // Puedes utilizar Navigator para navegar.
              },
            ),
            // Agrega más elementos de menú según sea necesario
          ],
        ),
      ),
    );
  }
}
