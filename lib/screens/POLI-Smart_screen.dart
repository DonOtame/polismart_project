import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:polismart_project/screens/materia_info.dart';
import 'package:polismart_project/screens/form_materia.dart';
import 'package:polismart_project/services/color_util.dart';
import 'package:polismart_project/widgets/materia_content.dart';

class PoliSmartScreen extends StatefulWidget {
  const PoliSmartScreen({Key? key});

  @override
  _PoliSmartScreenState createState() => _PoliSmartScreenState();
}

class _PoliSmartScreenState extends State<PoliSmartScreen> {
  int _currentIndex = 0;

  // Función para cambiar la página actual
  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Future<void> fetchDataFromFirestore() async {
    final QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('materias').get();

    querySnapshot.docs.forEach((document) {
      print(document.data());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'POLI-Smart',
          style: TextStyle(
            color: const Color(0xFFD9CE9A),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add,
              color: const Color(0xFFD9CE9A),
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => IngresoMateriaScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body:
          _currentIndex == 0 // Mostrar el contenido en la página de "Materias"
              ? buildMateriasContent()
              : _buildEmptyPage(), // Otras páginas (por ahora vacías)
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color(0xFFD9CE9A),
        unselectedItemColor: const Color(0xFFD9CE9A),
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.book), // Icono para Materias
            label: 'Materias',
            backgroundColor: Color(0xFF0F2440),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule), // Icono para Horarios
            label: 'Horarios',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment), // Icono para Tareas
            label: 'Tareas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attachment), // Icono para Material
            label: 'Material',
          ),
        ],
      ),
    );
  }

  // Función para mostrar páginas vacías (para Horarios, Tareas y Material)
  Widget _buildEmptyPage() {
    return Center(
      child: Text('Esta página está vacía.'),
    );
  }
}
