import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:polismart_project/models/tarea.dart';
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
              final listaTareas = tareas
                  .map((tarea) => Tarea(
                        titulo: tarea['titulo'] ?? '',
                        descripcion: tarea['descripcion'] ?? '',
                        fechaCreacion: tarea['fechaCreacion'] ?? '',
                        fechaFin: tarea['fechaFin'] ?? '',
                        estado: tarea['estado'] ?? false,
                      ))
                  .toList();

              return ListView.builder(
                itemCount: listaTareas.length,
                itemBuilder: (context, index) {
                  final tarea = listaTareas[index];

                  return construirTareaCard(tarea);
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

  Widget construirTareaCard(Tarea tarea) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(tarea.titulo),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                'Descripción: ${tarea.estado ? "${tarea.descripcion} (Completada)" : tarea.descripcion}'),
            Text('Fecha de Creación: ${tarea.fechaCreacion}'),
            Text('Fecha de Finalización: ${tarea.fechaFin}'),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.check_circle,
                  color: tarea.estado ? Colors.green : Colors.grey),
              onPressed: () {
                setState(() {
                  _actualizarEstadoTarea(tarea, !tarea.estado);
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                _eliminarTarea(tarea.titulo);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _eliminarTarea(String tituloTarea) {
    FirebaseFirestore.instance
        .collection('materias')
        .doc(widget.nombreMateria)
        .collection('tareas')
        .doc(tituloTarea)
        .delete();
  }

  void _abrirFormTarea(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FormTarea(nombreMateria: widget.nombreMateria),
      ),
    );
  }

  void _actualizarEstadoTarea(Tarea tarea, bool estado) {
    FirebaseFirestore.instance
        .collection('materias')
        .doc(widget.nombreMateria)
        .collection('tareas')
        .doc(tarea.titulo)
        .update({'estado': estado});
  }
}
