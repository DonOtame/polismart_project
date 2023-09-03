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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String? selectedDay;
  TimeOfDay? selectedStartTime;
  TimeOfDay? selectedEndTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
                onChanged: (text) {
                  // Convierte automáticamente el texto a mayúsculas
                  nombreController.text = text.toUpperCase();
                  nombreController.selection = TextSelection.fromPosition(
                    TextPosition(offset: nombreController.text.length),
                  );
                },
              ),
              TextFormField(
                controller: profesorController,
                decoration: const InputDecoration(labelText: 'Profesor'),
                onChanged: (text) {
                  // Convierte automáticamente el texto a mayúsculas
                  profesorController.text = text.toUpperCase();
                  profesorController.selection = TextSelection.fromPosition(
                    TextPosition(offset: profesorController.text.length),
                  );
                },
              ),
              TextFormField(
                controller: aulaController,
                decoration: const InputDecoration(labelText: 'Aula'),
                onChanged: (text) {
                  // Convierte automáticamente el texto a mayúsculas
                  aulaController.text = text.toUpperCase();
                  aulaController.selection = TextSelection.fromPosition(
                    TextPosition(offset: aulaController.text.length),
                  );
                },
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
          final horario = Horario(
            diaSemana: selectedDay ?? "",
            horaInicio: selectedStartTime?.format(context) ?? "",
            horaFin: selectedEndTime?.format(context) ?? "",
          );

          final materia = Materia(
            nombre: nombreController.text,
            color: selectedColor.toString(),
            profesor: profesorController.text,
            aula: aulaController.text,
            horario: horario,
          );

          try {
            await MateriaProvider().agregarMateria(materia);
            nombreController.clear();
            profesorController.clear();
            aulaController.clear();
            setState(() {
              selectedDay = null;
              selectedStartTime = null;
              selectedEndTime = null;
            });

            // Muestra un SnackBar de éxito aquí
            final snackBar = SnackBar(
              content: Text('Materia guardada con éxito'),
              backgroundColor: Colors.green,
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);

            // Cierra el screen después de un tiempo
            Future.delayed(Duration(seconds: 2), () {
              Navigator.of(context).pop(); // Cierra el screen
            });
          } catch (error) {
            // Muestra un SnackBar de error en caso de fallo
            final snackBar = SnackBar(
              content: Text("Error al guardar la materia: $error"),
              backgroundColor: Colors.red,
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
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
