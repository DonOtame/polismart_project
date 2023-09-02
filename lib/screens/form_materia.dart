import 'package:flutter/material.dart';
import 'package:polismart_project/models/materia.dart';
import 'package:polismart_project/services/firebase_service.dart'; // Importa el proveedor de Materia

class FormIngresomateria extends StatelessWidget {
  const FormIngresomateria({Key? key}); // Corrige el constructor

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          const IconButton(
            onPressed: null,
            icon: Icon(
              Icons.search,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () {
              // Navega a la pantalla de ingreso de materia cuando se presiona el botón de agregar.
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => MateriasForm(),
                ),
              );
            },
            icon: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ],
        title: const Text('Poli-Smart'),
      ),
      body: const Center(
        child: Text('Contenido de la pantalla principal aquí'),
      ),
    );
  }
}

class MateriasForm extends StatefulWidget {
  @override
  _MateriasFormState createState() => _MateriasFormState();
}

class _MateriasFormState extends State<MateriasForm> {
  final _formKey = GlobalKey<FormState>();
  String profesor = '';
  String aula = '';
  String materia = '';
  String diasDeClase = '';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              decoration:
                  const InputDecoration(labelText: 'Nombre del Profesor'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingresa el nombre del profesor.';
                }
                return null;
              },
              onSaved: (value) {
                profesor = value!;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Aula'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingresa el número de aula.';
                }
                return null;
              },
              onSaved: (value) {
                aula = value!;
              },
            ),
            TextFormField(
              decoration:
                  const InputDecoration(labelText: 'Nombre de la Materia'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingresa el nombre de la materia.';
                }
                return null;
              },
              onSaved: (value) {
                materia = value!;
              },
            ),
            TextFormField(
              decoration:
                  const InputDecoration(labelText: 'Días de Clase y Horarios'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingresa los días de clase y horarios.';
                }
                return null;
              },
              onSaved: (value) {
                diasDeClase = value!;
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();

                  // Crea un objeto Materia con los datos ingresados.
                  final nuevaMateria = Materia(
                    nombre: materia,
                    color:
                        'color_por_defecto', // Debes proporcionar un color por defecto
                    profesor: profesor,
                    aula: aula,
                    horarios: [
                      Horario(
                        diaSemana:
                            'Lunes', // Debes obtener los días de clase y horarios de manera adecuada
                        horaInicio:
                            '09:00', // Por ejemplo, desde los TextFormField
                        horaFin: '10:30',
                      ),
                    ],
                  );

                  // Llama a la función para agregar la materia al proveedor.
                  await materiaProvider.agregarMateria(nuevaMateria);

                  // Una vez que se guarda la materia, puedes navegar de regreso a la pantalla principal.
                  Navigator.pop(context);
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }
}
