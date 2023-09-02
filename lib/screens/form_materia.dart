// screens/ingreso_materia.dart

import 'package:flutter/material.dart';
import 'package:polismart_project/models/materia.dart';
import 'package:polismart_project/services/firebase_service.dart';

class IngresoMateriaScreen extends StatefulWidget {
  @override
  _IngresoMateriaScreenState createState() => _IngresoMateriaScreenState();
}

class _IngresoMateriaScreenState extends State<IngresoMateriaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _profesorController = TextEditingController();
  final _aulaController = TextEditingController();
  final _horarios = <Horario>[]; // Lista de horarios

  void _agregarHorario() {
    setState(() {
      _horarios.add(Horario(diaSemana: '', horaInicio: '', horaFin: ''));
    });
  }

  void _eliminarHorario(int index) {
    setState(() {
      _horarios.removeAt(index);
    });
  }

  void _guardarMateria() {
    if (_formKey.currentState!.validate()) {
      final nuevaMateria = Materia(
        nombre: _nombreController.text,
        color: '', // Aquí puedes establecer el color si es necesario.
        profesor: _profesorController.text,
        aula: _aulaController.text,
        horarios: _horarios,
      );

      materiaProvider.agregarMateria(nuevaMateria).then((_) {
        // Materia agregada con éxito, puedes realizar alguna acción adicional.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Materia agregada con éxito')),
        );
      }).catchError((error) {
        // Manejo de errores
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al agregar la materia: $error')),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ingresar Materia'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: _nombreController,
                decoration: InputDecoration(labelText: 'Nombre de la materia'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, ingresa el nombre de la materia';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _profesorController,
                decoration: InputDecoration(labelText: 'Profesor'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, ingresa el nombre del profesor';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _aulaController,
                decoration: InputDecoration(labelText: 'Aula'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, ingresa el nombre del aula';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              Text('Horarios:'),
              Column(
                children: _horarios.asMap().entries.map((entry) {
                  final index = entry.key;
                  final horario = entry.value;
                  return Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(labelText: 'Día'),
                          onChanged: (value) {
                            horario.diaSemana = value;
                          },
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          decoration:
                              InputDecoration(labelText: 'Hora de inicio'),
                          onChanged: (value) {
                            horario.horaInicio = value;
                          },
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(labelText: 'Hora de fin'),
                          onChanged: (value) {
                            horario.horaFin = value;
                          },
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _eliminarHorario(index),
                      ),
                    ],
                  );
                }).toList(),
              ),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: _agregarHorario,
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _guardarMateria,
                child: Text('Guardar Materia'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
