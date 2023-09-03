import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:polismart_project/screens/form_materia.dart';
import 'package:polismart_project/widgets/horarios_widget.dart';
import 'package:polismart_project/widgets/materia_content.dart';
import 'package:polismart_project/widgets/material_widget.dart';
import 'package:polismart_project/widgets/tareas_widget.dart';

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
      body: _currentIndex == 0
          ? buildMateriasContent()
          : _currentIndex == 1
              ? buildHorarioContent()
              : _currentIndex == 2
                  ? buildTareasContent()
                  : _currentIndex == 3
                      ? buildMaterialesContent()
                      : _buildEmptyPage(),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.book), // Icono para Materias
            label: 'Materias',
            backgroundColor: Color(0xFF0F2440),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule), // Icono para Horarios
            label: 'Horarios',
            backgroundColor: Color(0xFF0F2440),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment), // Icono para Tareas
            label: 'Tareas',
            backgroundColor: Color(0xFF0F2440),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attachment), // Icono para Material
            label: 'Material',
            backgroundColor: Color(0xFF0F2440),
          ),
        ],
        selectedItemColor: const Color(0xFFD9CE9A),
        unselectedItemColor: const Color(0xFFD9CE9A),
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
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
