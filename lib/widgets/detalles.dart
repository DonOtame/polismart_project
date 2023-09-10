import 'package:flutter/material.dart';
import 'package:polismart_project/models/materia.dart';

Widget buildDetalles(Future<Materia> futureMateria) {
  return FutureBuilder<Materia>(
    future: futureMateria,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else if (snapshot.hasError) {
        return buildError('Error: ${snapshot.error}', Colors.red);
      } else if (!snapshot.hasData) {
        return buildError(
          'No se encontraron detalles de la materia',
          Colors.black54,
          fontStyle: FontStyle.italic,
        );
      }

      final Materia materia = snapshot.data!;
      final detalles = {
        'Profesor': materia.profesor,
        'Aula': materia.aula,
        'Día de la semana': materia.horario.diaSemana,
        'Hora de inicio': materia.horario.horaInicio,
        'Hora de fin': materia.horario.horaFin,
      };

      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: detalles.entries.map((entry) {
            return buildDetalleTile(entry.key, entry.value);
          }).toList(),
        ),
      );
    },
  );
}

Widget buildDetalleTile(String title, String subtitle) {
  return ListTile(
    title: Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    ),
    subtitle: Text(
      subtitle,
      style: const TextStyle(fontSize: 18),
    ),
  );
}

Widget buildError(String message, Color textColor, {FontStyle? fontStyle}) {
  return Center(
    child: Text(
      message,
      style: TextStyle(
        color: textColor,
        fontSize: 18,
        fontWeight: FontWeight.bold,
        fontStyle: fontStyle,
      ),
    ),
  );
}
