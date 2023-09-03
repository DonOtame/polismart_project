import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:polismart_project/models/materia.dart';
import 'package:polismart_project/screens/form_materialclase.dart';
import 'package:polismart_project/screens/form_tarea.dart';
import 'package:polismart_project/services/firebase_tareas.dart';
import 'package:polismart_project/services/firebase_deleteMateria.dart';
import 'package:polismart_project/widgets/material_clase_list.dart';

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
          ? _buildDetalles() // Contenido de la pestaña Detalles
          : _selectedIndex == 1
              ? _buildTareas(context) // Contenido de la pestaña Tareas
              : _buildMaterialClase(
                  context), // Contenido de la pestaña Material de Clase
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

// Implementa el contenido de la pestaña Tareas
  Widget _buildTareas(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 20),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            // Escuchar cambios en la colección de tareas en tiempo real
            stream: FirebaseFirestore.instance
                .collection('materias')
                .doc(widget.nombreMateria)
                .collection('tareas')
                .orderBy('estado', descending: false)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              }

              // Si no hay datos o las tareas están vacías, mostrar un mensaje
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Text('No hay tareas'),
                );
              }

              // Si hay tareas, mostrar la lista de tareas
              final tareas = snapshot.data!.docs;
              return ListView.builder(
                itemCount: tareas.length,
                itemBuilder: (context, index) {
                  final tarea = tareas[index];
                  final titulo = tarea['titulo'] ?? '';
                  final descripcion = tarea['descripcion'] ?? '';
                  final fechaCreacion = tarea['fechaCreacion'] ?? '';
                  final fechaFin = tarea['fechaFin'] ?? '';
                  bool estado = tarea['estado'] ?? false;

                  // Agregar "Completada" a la descripción si la tarea está completa
                  final descripcionConEstado =
                      estado ? '$descripcion (Completada)' : descripcion;

                  return Card(
                    elevation: 3,
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      title: Text(titulo),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Descripción: $descripcionConEstado'),
                          Text('Fecha de Creación: $fechaCreacion'),
                          Text('Fecha de Finalización: $fechaFin'),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.check_circle,
                                color: estado ? Colors.green : Colors.grey),
                            onPressed: () {
                              // Cambiar el estado de la tarea (completa/incompleta)
                              setState(() {
                                estado = !estado;
                                _actualizarEstadoTarea(tarea, estado);
                              });
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              // Eliminar la tarea
                              _eliminarTarea(tarea);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            _abrirFormTarea(context);
          },
          child: Text('Agregar Tarea'),
        ),
      ],
    );
  }

// Implementa el contenido de la pestaña Material de Clase
  Widget _buildMaterialClase(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          MaterialClaseList(
            nombreMateria: widget.nombreMateria,
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
              onPressed: () {
                _abrirFormMaterial(context);
              },
              child: Text('Agregar Material'),
            ),
          ),
        ],
      ),
    );
  }

  void _abrirFormMaterial(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            FormMaterialClase(nombreMateria: widget.nombreMateria),
      ),
    );
  }

  // Función para cambiar el estado de una tarea
  void _actualizarEstadoTarea(DocumentSnapshot tarea, bool estado) {
    tarea.reference.update({'estado': estado});
  }

// Función para eliminar una tarea
  void _eliminarTarea(DocumentSnapshot tarea) {
    tarea.reference.delete();
  }

  void _abrirFormTarea(BuildContext context) {
    // Navegar a la pantalla de formulario de tareas y pasar el nombre de la materia
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FormTarea(nombreMateria: widget.nombreMateria),
      ),
    );
  }
}
