import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Importa Cloud Firestore
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

  // Función para obtener los detalles de la materia desde Firebase.
  Future<Materia> obtenerDetallesDeFirebase(String nombreMateria) async {
    try {
      final QuerySnapshot materias = await FirebaseFirestore.instance
          .collection('materias')
          .where('nombre', isEqualTo: nombreMateria)
          .get();

      if (materias.docs.isNotEmpty) {
        final data = materias.docs.first.data() as Map<String, dynamic>;
        final String color = data['color'];
        final String profesor = data['profesor'];
        final String aula = data['aula'];
        final Map<String, dynamic> horarioData = data['horario'];

        final Horario horario = Horario(
          diaSemana: horarioData['diaSemana'],
          horaInicio: horarioData['horaInicio'],
          horaFin: horarioData['horaFin'],
        );

        return Materia(
          nombre: nombreMateria,
          color: color,
          profesor: profesor,
          aula: aula,
          horario: horario,
        );
      } else {
        throw Exception('La materia no fue encontrada');
      }
    } catch (e) {
      // Manejo de errores, puedes personalizarlo según tus necesidades
      print('Error al obtener detalles de la materia: $e');
      throw e;
    }
  }
}
