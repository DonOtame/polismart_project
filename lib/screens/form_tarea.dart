import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Para formatear la fecha
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
  DateTime _fechaFin = DateTime.now(); // Fecha de Finalización seleccionada
  final bool _estado = false; // El estado se configura como true por defecto

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
            // Campo de fecha de finalización con botón para abrir el selector
            Row(
              children: [
                Icon(Icons.calendar_today),
                SizedBox(width: 10), // Espacio entre el icono y el texto
                Text(
                  'Fecha de Finalización:',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(width: 10), // Espacio entre el texto y la fecha
                Text(
                  '${DateFormat('dd/MM/yyyy').format(_fechaFin)}',
                  style: TextStyle(fontSize: 16),
                ),
                Spacer(), // Espacio entre la fecha y el borde derecho
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    _seleccionarFecha(context);
                  },
                ),
              ],
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

  // Función para abrir el selector de fecha
  Future<void> _seleccionarFecha(BuildContext context) async {
    final DateTime? fechaSeleccionada = await showDatePicker(
      context: context,
      initialDate: _fechaFin,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (fechaSeleccionada != null && fechaSeleccionada != _fechaFin) {
      setState(() {
        _fechaFin = fechaSeleccionada;
      });
    }
  }

  void _guardarTarea() {
    final titulo = _tituloController.text;
    final descripcion = _descripcionController.text;
    final fechaCreacion = DateFormat('dd/MM/yyyy').format(DateTime.now());
    final fechaFin = DateFormat('dd/MM/yyyy').format(_fechaFin);

    // Validar que los campos no estén vacíos
    if (titulo.isEmpty || descripcion.isEmpty || fechaFin.isEmpty) {
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
        .doc(tarea
            .titulo); // El título de la tarea se utiliza como identificador

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
    super.dispose();
  }
}
