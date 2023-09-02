import 'package:flutter/material.dart';

class HorarioInputWidget extends StatefulWidget {
  final Function(String?, TimeOfDay?, TimeOfDay?) onHorarioChanged;

  HorarioInputWidget({required this.onHorarioChanged});

  @override
  _HorarioInputWidgetState createState() => _HorarioInputWidgetState();
}

class _HorarioInputWidgetState extends State<HorarioInputWidget> {
  String? selectedDay;
  TimeOfDay? selectedStartTime;
  TimeOfDay? selectedEndTime;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: DropdownButton<String>(
            hint: Text("Día"),
            value: selectedDay,
            onChanged: (newValue) {
              setState(() {
                selectedDay = newValue;
              });
              widget.onHorarioChanged(
                  selectedDay, selectedStartTime, selectedEndTime);
            },
            items: [
              "Lunes",
              "Martes",
              "Miércoles",
              "Jueves",
              "Viernes",
              "Sábado"
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
                initialTime: selectedStartTime ?? TimeOfDay.now(),
              );
              if (selectedTime != null) {
                setState(() {
                  selectedStartTime = selectedTime;
                });
                widget.onHorarioChanged(
                    selectedDay, selectedStartTime, selectedEndTime);
              }
            },
            child: Text(
              selectedStartTime?.format(context) ?? "Inicio",
            ),
          ),
        ),
        Expanded(
          child: TextButton(
            onPressed: () async {
              final selectedTime = await showTimePicker(
                context: context,
                initialTime: selectedEndTime ?? TimeOfDay.now(),
              );
              if (selectedTime != null) {
                setState(() {
                  selectedEndTime = selectedTime;
                });
                widget.onHorarioChanged(
                    selectedDay, selectedStartTime, selectedEndTime);
              }
            },
            child: Text(
              selectedEndTime?.format(context) ?? "Fin",
            ),
          ),
        ),
      ],
    );
  }
}
