import 'package:flutter/material.dart';
import 'package:polismart_project/screens/form_materia.dart';
import 'package:polismart_project/widgets/horarios_widget.dart';
import 'package:polismart_project/widgets/materia_content.dart';
import 'package:polismart_project/widgets/documentos_widget.dart';
import 'package:polismart_project/widgets/tareas_widget.dart';

class PoliSmartScreen extends StatefulWidget {
  const PoliSmartScreen({Key? key});

  @override
  _PoliSmartScreenState createState() => _PoliSmartScreenState();
}

class _PoliSmartScreenState extends State<PoliSmartScreen> {
  int _currentIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'POLI-Smart',
          style: TextStyle(color: const Color(0xFFD9CE9A)),
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
                      ? buildDocumentosContent()
                      : _buildEmptyPage(),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Materias',
            backgroundColor: Color(0xFF0F2440),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule),
            label: 'Horarios',
            backgroundColor: Color(0xFF0F2440),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Tareas',
            backgroundColor: Color(0xFF0F2440),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attachment),
            label: 'Documentos',
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

  Widget _buildEmptyPage() {
    return const Center(
      child: Text('Esta página está vacía.'),
    );
  }
}
