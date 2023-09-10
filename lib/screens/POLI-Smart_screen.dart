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

  final List<Widget> _pages = [
    buildMateriasContent(),
    buildHorarioContent(),
    buildTareasContent(),
    buildDocumentosContent(),
  ];

  final List<BottomNavigationBarItem> _bottomNavBarItems = const [
    BottomNavigationBarItem(
      icon: Icon(Icons.book),
      label: 'Materias',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.schedule),
      label: 'Horarios',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.assignment),
      label: 'Tareas',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.attachment),
      label: 'Documentos',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'POLI-Smart',
          style: TextStyle(color: Color(0xFFD9CE9A)),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add,
              color: Color(0xFFD9CE9A),
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
      body: _pages[_currentIndex],
      bottomNavigationBar: Theme(
        data: ThemeData(
          canvasColor: const Color(0xFF0F2440),
        ),
        child: BottomNavigationBar(
          items: _bottomNavBarItems,
          selectedItemColor: const Color(0xFFD9CE9A),
          unselectedItemColor: const Color(0xFFD9CE9A),
          currentIndex: _currentIndex,
          onTap: _onTabTapped,
        ),
      ),
    );
  }
}
