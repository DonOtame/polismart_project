import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:polismart_project/screens/form_tarea.dart';

class TareasWidget extends StatefulWidget {
  final String nombreMateria;

  TareasWidget({required this.nombreMateria});

  @override
  _TareasWidgetState createState() => _TareasWidgetState();
}

class _TareasWidgetState extends State<TareasWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 20),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('materias')
                .doc(widget.nombreMateria)
                .collection('tareas')
                .orderBy('estado', descending: false)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              }

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

                  final descripcionConEstado =
                      estado ? '$descripcion (Completada)' : descripcion;

                  return Card(
                    elevation: 3,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                              setState(() {
                                estado = !estado;
                                _actualizarEstadoTarea(tarea, estado);
                              });
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
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
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            _abrirFormTarea(context);
          },
          child: const Text('Agregar Tarea'),
        ),
      ],
    );
  }

  void _eliminarTarea(DocumentSnapshot tarea) {
    tarea.reference.delete();
  }

  void _abrirFormTarea(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FormTarea(nombreMateria: widget.nombreMateria),
      ),
    );
  }

  void _actualizarEstadoTarea(DocumentSnapshot tarea, bool estado) {
    tarea.reference.update({'estado': estado});
  }
}
