import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:polismart_project/models/materia.dart';

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
