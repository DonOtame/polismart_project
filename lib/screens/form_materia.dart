import 'package:flutter/material.dart';

class FormIngresomateria extends StatelessWidget {
  const FormIngresomateria({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: const [
            IconButton(
              onPressed: null,
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
            ),
            IconButton(
                onPressed: null,
                icon: Icon(
                  Icons.add,
                  color: Colors.white,
                ))
          ],
          title: Text('Poli-Smart'),
        ),
        body: MateriasForm());
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
              decoration: InputDecoration(labelText: 'Nombre del Profesor'),
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
              decoration: InputDecoration(labelText: 'Aula'),
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
              decoration: InputDecoration(labelText: 'Nombre de la Materia'),
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
                  InputDecoration(labelText: 'Días de Clase y Horarios'),
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
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  // Aquí puedes guardar la información en una base de datos o realizar otras acciones con los datos ingresados.
                  // Por ejemplo, puedes imprimirlos en la consola.
                  print('Nombre del Profesor: $profesor');
                  print('Aula: $aula');
                  print('Nombre de la Materia: $materia');
                  print('Días de Clase y Horarios: $diasDeClase');
                }
              },
              child: Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }
}
