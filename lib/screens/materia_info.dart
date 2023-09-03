import 'package:flutter/material.dart';
import 'package:polismart_project/models/materia.dart';
import 'package:polismart_project/services/firebase_tareas.dart';
import 'package:polismart_project/services/firebase_deleteMateria.dart';
import 'package:polismart_project/widgets/detalles.dart';
import 'package:polismart_project/widgets/material.dart';
import 'package:polismart_project/widgets/tareas.dart';

class DetalleMateriaScreen extends StatefulWidget {
  final String nombreMateria;

  DetalleMateriaScreen({required this.nombreMateria});

  @override
  _DetalleMateriaScreenState createState() => _DetalleMateriaScreenState();
}

class _DetalleMateriaScreenState extends State<DetalleMateriaScreen> {
  int _selectedIndex = 0; // Índice de la pestaña seleccionada

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.nombreMateria,
          style: TextStyle(
            color: Color(0xFFD9CE9A),
          ),
        ),
        iconTheme: const IconThemeData(
          color: Color(0xFFD9CE9A),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              final confirmacionEliminacion =
                  await confirmDeleteMateria(context, widget.nombreMateria);
              if (confirmacionEliminacion) {
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
      body: _selectedIndex == 0
          ? buildDetalles(obtenerDetallesDeFirebase(
              widget.nombreMateria)) // Contenido de la pestaña Detalles
          : _selectedIndex == 1
              ? TareasWidget(
                  nombreMateria:
                      widget.nombreMateria) // Contenido de la pestaña Tareas
              : buildMaterialClase(
                  context,
                  widget
                      .nombreMateria), // Contenido de la pestaña Material de Clase
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFF0F2440),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.details),
            label: 'Detalles',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Tareas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.class_),
            label: 'Material de Clase',
          ),
        ],
        selectedItemColor: const Color(0xFFD9CE9A),
        unselectedItemColor: const Color(0xFFD9CE9A),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  // Función para cambiar de pestaña al tocar un ítem en el BottomNavigationBar
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
