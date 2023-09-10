import 'package:flutter/material.dart';
import 'package:polismart_project/services/firebase_tareas.dart';
import 'package:polismart_project/services/firebase_deleteMateria.dart';
import 'package:polismart_project/widgets/detalles.dart';
import 'package:polismart_project/widgets/documentos.dart';
import 'package:polismart_project/widgets/tareas.dart';

class DetalleMateriaScreen extends StatefulWidget {
  late final String nombreMateria;

  DetalleMateriaScreen({required this.nombreMateria});

  @override
  _DetalleMateriaScreenState createState() => _DetalleMateriaScreenState();
}

class _DetalleMateriaScreenState extends State<DetalleMateriaScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.nombreMateria,
          style: const TextStyle(
            color: Color(0xFFD9CE9A),
          ),
        ),
        iconTheme: const IconThemeData(
          color: Color(0xFFD9CE9A),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
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
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return buildDetalles(obtenerDetallesDeFirebase(widget.nombreMateria));
      case 1:
        return TareasWidget(nombreMateria: widget.nombreMateria);
      case 2:
        return buildDocumentosClase(context, widget.nombreMateria);
      default:
        return Container();
    }
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      backgroundColor: const Color(0xFF0F2440),
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
          label: 'Documentos',
        ),
      ],
      selectedItemColor: const Color(0xFFD9CE9A),
      unselectedItemColor: const Color(0xFFD9CE9A),
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
