import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:polismart_project/models/materia.dart';

class DetalleMateriaScreen extends StatefulWidget {
  final String nombreMateria;

  DetalleMateriaScreen({required this.nombreMateria});

  @override
  _DetalleMateriaScreenState createState() => _DetalleMateriaScreenState();
}

class _DetalleMateriaScreenState extends State<DetalleMateriaScreen> {
  int _selectedIndex = 0;
  bool _isDeleting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.nombreMateria,
          style: TextStyle(
            color: const Color(0xFFD9CE9A),
          ),
        ),
        iconTheme: const IconThemeData(
          color: const Color(0xFFD9CE9A),
        ),
      ),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButton: _isDeleting
          ? null
          : FloatingActionButton(
              onPressed: () {
                _confirmDeleteMateria(context);
              },
              child: Icon(Icons.delete),
            ),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return _buildDetalles();
      case 1:
        return _buildTareas();
      case 2:
        return _buildMaterialClase();
      default:
        return Container(); // Puedes personalizar el caso por defecto
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
          label: 'Material de Clase',
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
      print('Error al obtener detalles de la materia: $e');
      throw e;
    }
  }

  Widget _buildTareas() {
    return Center(
      child: Text('Contenido de la pestaña Tareas'),
    );
  }

  Widget _buildMaterialClase() {
    return Center(
      child: Text('Contenido de la pestaña Material de Clase'),
    );
  }

  Future<void> _confirmDeleteMateria(BuildContext context) async {
    final confirmDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar eliminación'),
          content: Text('¿Estás seguro de que deseas eliminar esta materia?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: Text('Eliminar'),
              onPressed: () async {
                try {
                  await FirebaseFirestore.instance
                      .collection('materias')
                      .where('nombre', isEqualTo: widget.nombreMateria)
                      .get()
                      .then((querySnapshot) {
                    querySnapshot.docs.forEach((doc) {
                      doc.reference.delete();
                    });
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('La materia se ha eliminado con éxito'),
                    ),
                  );

                  Navigator.of(context).pop(true);
                } catch (e) {
                  print('Error al eliminar la materia: $e');
                  Navigator.of(context).pop(false);
                }
              },
            ),
          ],
        );
      },
    );

    if (confirmDelete == true) {
      Navigator.of(context).pop();
    }
  }
}
