import 'package:flutter/material.dart';

class IngresoMateriaScreen extends StatefulWidget {
  @override
  _IngresoMateriaScreenState createState() => _IngresoMateriaScreenState();
}

class _IngresoMateriaScreenState extends State<IngresoMateriaScreen> {
  List<HorarioInput> horarios = [];
  String selectedDay = 'Lunes';
  TimeOfDay selectedStartTime = TimeOfDay.now();
  TimeOfDay selectedEndTime = TimeOfDay.now();
  bool isFirstHorario = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Ingresar Materia',
          style: TextStyle(
            color: Color(0xFFD9CE9A), // Color del texto
          ),
        ),
        iconTheme: IconThemeData(
          color:
              Color(0xFFD9CE9A), // Cambia el color de la flecha de retorno aquí
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Nombre de la Materia'),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Profesor'),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Aula'),
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
                _buildHorarioInput(i),
                if (i < horarios.length - 1) Divider(),
              ],
              SizedBox(height: 16.0),
              _buildAgregarHorarioButton(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Agregar funcionalidad para guardar la materia en Firestore
        },
        foregroundColor: Color(0xFFD9CE9A), // Cambia el color del icono aquí
        child: Icon(Icons.save),
      ),
    );
  }

  Widget _buildHorarioInput(int index) {
    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField<String>(
            value: selectedDay,
            onChanged: (newValue) {
              setState(() {
                selectedDay = newValue!;
              });
            },
            items: <String>[
              'Lunes',
              'Martes',
              'Miércoles',
              'Jueves',
              'Viernes',
              'Sábado',
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
        Expanded(
          child: TextButton(
            onPressed: () async {
              final selectedTime = await showTimePicker(
                context: context,
                initialTime: selectedStartTime,
              );
              if (selectedTime != null) {
                setState(() {
                  selectedStartTime = selectedTime;
                });
              }
            },
            child: Text(selectedStartTime.format(context)),
          ),
        ),
        Expanded(
          child: TextButton(
            onPressed: () async {
              final selectedTime = await showTimePicker(
                context: context,
                initialTime: selectedEndTime,
              );
              if (selectedTime != null) {
                setState(() {
                  selectedEndTime = selectedTime;
                });
              }
            },
            child: Text(selectedEndTime.format(context)),
          ),
        ),
        if (!isFirstHorario || horarios.length > 1)
          IconButton(
            onPressed: () {
              setState(() {
                horarios.removeAt(index);
              });
            },
            icon: Icon(
              Icons.delete,
              color: Colors.red,
            ),
          ),
      ],
    );
  }

  Widget _buildAgregarHorarioButton() {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFF0F2440),
          shape: BoxShape.circle,
        ),
        child: IconButton(
          onPressed: () {
            setState(() {
              horarios.add(HorarioInput());
              isFirstHorario = false;
            });
          },
          icon: Icon(
            Icons.add,
            size: 32.0,
            color: Color(0xFFD9CE9A),
          ),
        ),
      ),
    );
  }
}

class HorarioInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox();
  }
}
