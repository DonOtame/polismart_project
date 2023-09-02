import 'package:flutter/material.dart';

class PoliSmartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F2440),
        title: const Text(
          'POLI-Smart',
          style: TextStyle(
            color: const Color(0xFFD9CE9A), // Color del texto
          ),
        ),
        leading: PopupMenuButton<String>(
          onSelected: (value) {
            // Agregar aquí la lógica para las opciones del menú emergente.
            if (value == 'apuntes') {
              // Lógica para Apuntes.
            } else if (value == 'horario') {
              // Lógica para Horario.
            } else if (value == 'materias') {
              // Lógica para Materias.
            } else if (value == 'tareas') {
              // Lógica para Tareas.
            } else if (value == 'teoria') {
              // Lógica para Teoría.
            }
          },
          icon: const Icon(
            Icons.menu,
            color:
                const Color(0xFFD9CE9A), // Color del icono del menú emergente
          ),
          color: const Color(0xFF0F2440),
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            const PopupMenuItem<String>(
              value: 'apuntes',
              textStyle: TextStyle(color: Color(0xFFD9CE9A)),
              child: Text('Apuntes'),
            ),
            const PopupMenuItem<String>(
              value: 'horario',
              textStyle: TextStyle(color: Color(0xFFD9CE9A)),
              child: Text('Horario'),
            ),
            const PopupMenuItem<String>(
              value: 'materias',
              textStyle: TextStyle(color: Color(0xFFD9CE9A)),
              child: Text('Materias'),
            ),
            const PopupMenuItem<String>(
              value: 'tareas',
              textStyle: TextStyle(color: Color(0xFFD9CE9A)),
              child: Text('Tareas'),
            ),
            const PopupMenuItem<String>(
              value: 'teoria',
              textStyle: TextStyle(color: Color(0xFFD9CE9A)),
              child: Text('Teoría'),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.search,
              color: const Color(0xFFD9CE9A), // Color del icono de búsqueda
            ),
            onPressed: () {
              // Agregar aquí la lógica para la búsqueda.
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.add,
              color: const Color(0xFFD9CE9A), // Color del icono de agregar
            ),
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
      extendBodyBehindAppBar: true, // Extiende el contenido detrás del AppBar.
      extendBody: true, // Extiende el contenido detrás del AppBar.
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.keyboard),
            label: 'Teclado',
            backgroundColor: Color(0xFF0F2440),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mic),
            label: 'Micrófono',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_enhance),
            label: 'Cámara',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check),
            label: 'Visto',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz),
            label: 'Más',
          ),
        ],
        selectedItemColor: const Color(0xFFD9CE9A),
        unselectedItemColor:
            const Color(0xFFD9CE9A), // Color de los íconos no seleccionados.
        showSelectedLabels:
            false, // Oculta las etiquetas de los íconos seleccionados.
        showUnselectedLabels:
            false, // Oculta las etiquetas de los íconos no seleccionados.
      ),
    );
  }
}
