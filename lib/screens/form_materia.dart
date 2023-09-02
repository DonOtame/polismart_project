import 'package:flutter/material.dart';
import 'package:polismart_project/models/materia.dart';
import 'package:polismart_project/providers/materia_provider.dart';
import 'package:polismart_project/widgets/color_picker.dart';
import 'package:polismart_project/widgets/horario_input.dart';

class IngresoMateriaScreen extends StatefulWidget {
  @override
  _IngresoMateriaScreenState createState() => _IngresoMateriaScreenState();
}

class _IngresoMateriaScreenState extends State<IngresoMateriaScreen> {
  bool isFirstHorario = true;
  Color selectedColor = Colors.blue;
  TextEditingController nombreController = TextEditingController();
  TextEditingController profesorController = TextEditingController();
  TextEditingController aulaController = TextEditingController();

  String? selectedDay;
  TimeOfDay? selectedStartTime;
  TimeOfDay? selectedEndTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Ingresar Materia',
          style: TextStyle(
            color: Color(0xFFD9CE9A),
          ),
        ),
        iconTheme: const IconThemeData(
          color: Color(0xFFD9CE9A),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: nombreController,
                decoration:
                    const InputDecoration(labelText: 'Nombre de la Materia'),
              ),
              TextFormField(
                controller: profesorController,
                decoration: const InputDecoration(labelText: 'Profesor'),
              ),
              TextFormField(
                controller: aulaController,
                decoration: const InputDecoration(labelText: 'Aula'),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 16.0),
                child: Text(
                  'Color',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ColorPickerWidget(
                selectedColor: selectedColor,
                onColorChanged: _onColorChanged,
              ),
              const Padding(
                padding: EdgeInsets.only(top: 16.0),
                child: Text(
                  'Horario',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              HorarioInputWidget(
                onHorarioChanged: _onHorarioChanged,
              ),
              const SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Crea un objeto Horario con los valores seleccionados
          final horario = Horario(
            diaSemana: selectedDay ?? "NO",
            horaInicio: selectedStartTime?.format(context) ?? "NO",
            horaFin: selectedEndTime?.format(context) ?? "NO",
          );

          // Crea un objeto Materia con los datos del formulario
          final materia = Materia(
            nombre: nombreController.text,
            color: selectedColor.toString(), // Convierte el color en una cadena
            profesor: profesorController.text,
            aula: aulaController.text,
            horario: horario, // Asigna el horario creado
          );

          // Llama al método para agregar la materia a Firebase Firestore
          await MateriaProvider().agregarMateria(materia);

          // Limpia los controladores después de guardar la materia
          nombreController.clear();
          profesorController.clear();
          aulaController.clear();
          setState(
            () {
              selectedDay = null;
              selectedStartTime = null;
              selectedEndTime = null;
            },
          );
        },
        foregroundColor: const Color(0xFFD9CE9A),
        child: const Icon(Icons.save),
      ),
    );
  }

  void _onColorChanged(Color color) {
    setState(() {
      selectedColor = color;
    });
  }

  void _onHorarioChanged(
      String? day, TimeOfDay? startTime, TimeOfDay? endTime) {
    setState(() {
      selectedDay = day;
      selectedStartTime = startTime;
      selectedEndTime = endTime;
    });
  }
}
