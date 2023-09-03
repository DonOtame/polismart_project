import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:polismart_project/models/tarea.dart';

class FormTarea extends StatefulWidget {
  final String nombreMateria;

  FormTarea({required this.nombreMateria});

  @override
  _FormTareaState createState() => _FormTareaState();
}

class _FormTareaState extends State<FormTarea> {
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _fechaCreacionController =
      TextEditingController();
  final TextEditingController _fechaFinController = TextEditingController();
  final bool _estado = true; // El estado se configura como true por defecto

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Tarea a ${widget.nombreMateria}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _tituloController,
              decoration: InputDecoration(labelText: 'Título de la Tarea'),
            ),
            TextField(
              controller: _descripcionController,
              decoration: InputDecoration(labelText: 'Descripción de la Tarea'),
            ),
            TextField(
              controller: _fechaCreacionController,
              decoration: InputDecoration(labelText: 'Fecha de Creación'),
            ),
            TextField(
              controller: _fechaFinController,
              decoration: InputDecoration(labelText: 'Fecha de Finalización'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _guardarTarea();
              },
              child: Text('Guardar Tarea'),
            ),
          ],
        ),
      ),
    );
  }

  void _guardarTarea() {
    final titulo = _tituloController.text;
    final descripcion = _descripcionController.text;
    final fechaCreacion = _fechaCreacionController.text;
    final fechaFin = _fechaFinController.text;

    // Validar que los campos no estén vacíos
    if (titulo.isEmpty ||
        descripcion.isEmpty ||
        fechaCreacion.isEmpty ||
        fechaFin.isEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Por favor, complete todos los campos.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Aceptar'),
              ),
            ],
          );
        },
      );
      return;
    }

    // Crear una instancia de Tarea con los datos ingresados
    final tarea = Tarea(
      titulo: titulo,
      descripcion: descripcion,
      fechaCreacion: fechaCreacion,
      fechaFin: fechaFin,
      estado: _estado,
    );

    // Guardar la tarea en Firebase Firestore
    final tareaRef = FirebaseFirestore.instance
        .collection('materias')
        .doc(widget.nombreMateria)
        .collection('tareas')
        .doc();

    tareaRef.set({
      'titulo': tarea.titulo,
      'descripcion': tarea.descripcion,
      'fechaCreacion': tarea.fechaCreacion,
      'fechaFin': tarea.fechaFin,
      'estado': tarea.estado,
    }).then((value) {
      Navigator.of(context).pop(); // Cerrar la pantalla de formulario
    }).catchError((error) {
      print('Error al guardar la tarea: $error');
      // Mostrar un mensaje de error en caso de que ocurra un error al guardar la tarea
    });
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _descripcionController.dispose();
    _fechaCreacionController.dispose();
    _fechaFinController.dispose();
    super.dispose();
  }
}
