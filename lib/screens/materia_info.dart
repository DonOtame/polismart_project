import 'package:flutter/material.dart';
import 'package:polismart_project/models/materia.dart';

class DetalleMateriaScreen extends StatelessWidget {
  final String nombreMateria;

  DetalleMateriaScreen({required this.nombreMateria});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(nombreMateria),
      ),
      body: Center(
        child: FutureBuilder<Materia>(
          future: obtenerDetallesDeFirebase(nombreMateria),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData) {
              return Text('No se encontraron detalles de la materia');
            }

            final Materia materia = snapshot.data!;
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Profesor: ${materia.profesor}'),
                Text('Aula: ${materia.aula}'),
                Text('Día de la semana: ${materia.horario.diaSemana}'),
                Text('Hora de inicio: ${materia.horario.horaInicio}'),
                Text('Hora de fin: ${materia.horario.horaFin}'),
              ],
            );
          },
        ),
      ),
    );
  }

  // Función para obtener los detalles de la materia desde Firebase o cualquier otra fuente.
  Future<Materia> obtenerDetallesDeFirebase(String nombreMateria) async {
    // Aquí puedes implementar la lógica para buscar los detalles de la materia en Firebase
    // u otra fuente de datos basándote en el nombreMateria.
    // Devuelve una instancia de Materia con los detalles correspondientes.
    return Materia(
      nombre: nombreMateria,
      color: 'Color de ejemplo',
      profesor: 'Profesor de ejemplo',
      aula: 'Aula de ejemplo',
      horario: Horario(
        diaSemana: 'Día de ejemplo',
        horaInicio: 'Hora de inicio de ejemplo',
        horaFin: 'Hora de fin de ejemplo',
      ),
    );
  }
}
