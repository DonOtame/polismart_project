import 'package:flutter/material.dart';
import 'package:polismart_project/widgets/materia_card.dart';

class PoliSmartScreen extends StatelessWidget {
  const PoliSmartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F2440),
        title: const Text(
          'POLI-Smart',
          style: TextStyle(
            color: Color(0xFFD9CE9A), // Color del texto
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
            color: Color(0xFFD9CE9A), // Color del icono del menú emergente
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
              color: Color(0xFFD9CE9A), // Color del icono de búsqueda
            ),
            onPressed: () {
              // Agregar aquí la lógica para la búsqueda.
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.add,
              color: Color(0xFFD9CE9A), // Color del icono de agregar
            ),
            onPressed: () {
              // Agregar aquí la lógica para navegar a otra pantalla.
            },
          ),
        ],
      ),
      body: MateriasList(),
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

class MateriasList extends StatelessWidget {
  final List<Map<String, dynamic>> materias = [
    {'nombre': 'Matemáticas', 'color': Colors.blue},
    {'nombre': 'Ciencias', 'color': Colors.red},
    {'nombre': 'Historia', 'color': Colors.green},
    {'nombre': 'Geografía', 'color': Colors.orange},
    {'nombre': 'Arte', 'color': Colors.purple},
    {'nombre': 'Educación Física', 'color': Colors.teal},
    // Agrega más materias con colores aquí
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: (materias.length / 2).ceil(),
      itemBuilder: (context, index) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            MateriaCard(
              nombre: materias[index * 2]['nombre'],
              iconColor: materias[index * 2]['color'],
            ),
            if ((index * 2 + 1) < materias.length)
              MateriaCard(
                nombre: materias[index * 2 + 1]['nombre'],
                iconColor: materias[index * 2 + 1]['color'],
              ),
          ],
        );
      },
    );
  }
}
