import 'package:flutter/material.dart';
import 'package:polismart_project/screens/form_materia.dart';

class HorarioInputWidget extends StatelessWidget {
  final String selectedDay;
  final TimeOfDay selectedStartTime;
  final TimeOfDay selectedEndTime;
  final bool isFirstHorario;
  final Function(String) onDayChanged;
  final Function(TimeOfDay) onStartTimeChanged;
  final Function(TimeOfDay) onEndTimeChanged;
  final Function() onRemoveHorario;
  final List<HorarioInput> horarios;

  HorarioInputWidget({
    required this.selectedDay,
    required this.selectedStartTime,
    required this.selectedEndTime,
    required this.isFirstHorario,
    required this.onDayChanged,
    required this.onStartTimeChanged,
    required this.onEndTimeChanged,
    required this.onRemoveHorario,
    required this.horarios,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField<String>(
            value: selectedDay,
            onChanged: (newValue) {
              onDayChanged(
                  newValue!); // Llama a la función proporcionada cuando cambia el día.
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
                onStartTimeChanged(
                    selectedTime); // Llama a la función proporcionada cuando cambia la hora de inicio.
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
                onEndTimeChanged(
                    selectedTime); // Llama a la función proporcionada cuando cambia la hora de finalización.
              }
            },
            child: Text(selectedEndTime.format(context)),
          ),
        ),
        if (!isFirstHorario || horarios.length > 1)
          IconButton(
            onPressed:
                onRemoveHorario, // Llama a la función proporcionada al eliminar el horario.
            icon: Icon(
              Icons.delete,
              color: Colors.red,
            ),
          ),
      ],
    );
  }
}
