import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Importa Cloud Firestore
import 'package:polismart_project/models/materia.dart';

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
      ),
      body: _selectedIndex == 0
          ? _buildDetalles() // Contenido de la pestaña Detalles
          : _selectedIndex == 1
              ? _buildTareas() // Contenido de la pestaña Tareas
              : _buildMaterialClase(), // Contenido de la pestaña Material de Clase
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

  // Implementa el contenido de la pestaña Detalles
  Widget _buildDetalles() {
    return FutureBuilder<Materia>(
      future: obtenerDetallesDeFirebase(widget.nombreMateria),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return _buildError('Error: ${snapshot.error}', Colors.red);
        } else if (!snapshot.hasData) {
          return _buildError(
            'No se encontraron detalles de la materia',
            Colors.black54,
            fontStyle: FontStyle.italic,
          );
        }

        final Materia materia = snapshot.data!;
        final detalles = {
          'Profesor': materia.profesor,
          'Aula': materia.aula,
          'Día de la semana': materia.horario.diaSemana,
          'Hora de inicio': materia.horario.horaInicio,
          'Hora de fin': materia.horario.horaFin,
        };

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: detalles.entries.map((entry) {
              return _buildDetalleTile(entry.key, entry.value);
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _buildDetalleTile(String title, String subtitle) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 18),
      ),
    );
  }

  Widget _buildError(String message, Color textColor, {FontStyle? fontStyle}) {
    return Center(
      child: Text(
        message,
        style: TextStyle(
          color: textColor,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          fontStyle: fontStyle,
        ),
      ),
    );
  }

  Future<Materia> obtenerDetallesDeFirebase(String nombreMateria) async {
    try {
      final QuerySnapshot materias = await FirebaseFirestore.instance
          .collection('materias')
          .where('nombre', isEqualTo: nombreMateria)
          .get();

      if (materias.docs.isNotEmpty) {
        final data = materias.docs.first.data() as Map<String, dynamic>;
        final String color = data['color'];
        final String profesor = data['profesor'];
        final String aula = data['aula'];
        final Map<String, dynamic> horarioData = data['horario'];

        final Horario horario = Horario(
          diaSemana: horarioData['diaSemana'],
          horaInicio: horarioData['horaInicio'],
          horaFin: horarioData['horaFin'],
        );

        return Materia(
          nombre: nombreMateria,
          color: color,
          profesor: profesor,
          aula: aula,
          horario: horario,
        );
      } else {
        throw Exception('La materia no fue encontrada');
      }
    } catch (e) {
      // Manejo de errores, puedes personalizarlo según tus necesidades
      print('Error al obtener detalles de la materia: $e');
      throw e;
    }
  }

  // Implementa el contenido de la pestaña Tareas
  Widget _buildTareas() {
    // Contenido de la pestaña Tareas (puedes personalizarlo)
    return Center(
      child: Text('Contenido de la pestaña Tareas'),
    );
  }

  // Implementa el contenido de la pestaña Material de Clase
  Widget _buildMaterialClase() {
    // Contenido de la pestaña Material de Clase (puedes personalizarlo)
    return Center(
      child: Text('Contenido de la pestaña Material de Clase'),
    );
  }
}
