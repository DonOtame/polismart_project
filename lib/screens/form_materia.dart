import 'package:flutter/material.dart';
import 'package:polismart_project/models/materia.dart';
import 'package:polismart_project/widgets/color_picker.dart';
import 'package:polismart_project/widgets/horario_input.dart';
import 'package:polismart_project/providers/materia_provider.dart';

void main() {
  runApp(MaterialApp(
    home: IngresoMateriaScreen(),
  ));
}

class IngresoMateriaScreen extends StatefulWidget {
  @override
  _IngresoMateriaScreenState createState() => _IngresoMateriaScreenState();
}

class _IngresoMateriaScreenState extends State<IngresoMateriaScreen> {
  final _materiaProvider = MateriaProvider();
  List<HorarioInput> horarios = [];
  String selectedDay = 'Lunes';
  TimeOfDay selectedStartTime = TimeOfDay.now();
  TimeOfDay selectedEndTime = TimeOfDay.now();
  bool isFirstHorario = true;
  Color selectedColor = Colors.blue;
  TextEditingController nombreController = TextEditingController();
  TextEditingController profesorController = TextEditingController();
  TextEditingController aulaController = TextEditingController();

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
          iconTheme: IconThemeData(
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
                      InputDecoration(labelText: 'Nombre de la Materia'),
                ),
                TextFormField(
                  controller: profesorController,
                  decoration: InputDecoration(labelText: 'Profesor'),
                ),
                TextFormField(
                  controller: aulaController,
                  decoration: InputDecoration(labelText: 'Aula'),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
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
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    'Horario',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                for (var i = 0; i < horarios.length; i++) ...[
                  HorarioInputWidget(
                    selectedDay: selectedDay,
                    selectedStartTime: selectedStartTime,
                    selectedEndTime: selectedEndTime,
                    isFirstHorario: isFirstHorario,
                    onDayChanged: _onDayChanged,
                    onStartTimeChanged: _onStartTimeChanged,
                    onEndTimeChanged: _onEndTimeChanged,
                    onRemoveHorario: () => _onRemoveHorario(i),
                    horarios: [],
                  ),
                  if (i < horarios.length - 1) Divider(),
                ],
                SizedBox(height: 16.0),
                _buildAgregarHorarioButton(),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            // Crear una instancia de Materia con los datos ingresados
            final nuevaMateria = Materia(
              nombre: nombreController.text,
              color: selectedColor.toString(),
              profesor: profesorController.text,
              aula: aulaController.text,
              horarios: horarios
                  .map((horario) => Horario(
                        diaSemana: horario.selectedDay,
                        horaInicio: horario.selectedStartTime.toString(),
                        horaFin: horario.selectedEndTime.toString(),
                      ))
                  .toList(),
            );

            await _materiaProvider.agregarMateria(nuevaMateria);

            nombreController.clear();
            profesorController.clear();
            aulaController.clear();
            horarios.clear();
          },
          foregroundColor: Color(0xFFD9CE9A),
          child: Icon(Icons.save),
        ));
  }

  Widget _buildAgregarHorarioButton() {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFF0F2440),
          shape: BoxShape.circle,
        ),
        child: IconButton(
          onPressed: _addHorario,
          icon: Icon(
            Icons.add,
            size: 32.0,
            color: Color(0xFFD9CE9A),
          ),
        ),
      ),
    );
  }

  void _onColorChanged(Color color) {
    setState(() {
      selectedColor = color;
    });
  }

  void _onDayChanged(String newValue) {
    setState(() {
      selectedDay = newValue;
    });
  }

  void _onStartTimeChanged(TimeOfDay newValue) {
    setState(() {
      selectedStartTime = newValue;
    });
  }

  void _onEndTimeChanged(TimeOfDay newValue) {
    setState(() {
      selectedEndTime = newValue;
    });
  }

  void _addHorario() {
    setState(() {
      horarios.add(HorarioInput());
      isFirstHorario = false;
    });
  }

  void _onRemoveHorario(int index) {
    setState(() {
      horarios.removeAt(index);
    });
  }
}

class HorarioInput extends StatelessWidget {
  final String selectedDay;
  final TimeOfDay? selectedStartTime;
  final TimeOfDay? selectedEndTime;

  HorarioInput({
    this.selectedDay = 'Lunes',
    this.selectedStartTime,
    this.selectedEndTime,
  });

  @override
  Widget build(BuildContext context) {
    // Implementa la construcción del widget usando los valores proporcionados.
    return SizedBox();
  }
}
