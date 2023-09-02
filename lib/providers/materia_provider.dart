import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:polismart_project/models/materia.dart';

class MateriaProvider {
  final CollectionReference materiasCollection =
      FirebaseFirestore.instance.collection('materias');

  Future<void> agregarMateria(Materia materia) async {
    // Validar que los campos no estén vacíos o nulos
    if (materia.nombre.isEmpty ||
        materia.color.isEmpty ||
        materia.profesor.isEmpty ||
        materia.aula.isEmpty ||
        materia.horario.diaSemana.isEmpty ||
        materia.horario.horaInicio.isEmpty ||
        materia.horario.horaFin.isEmpty) {
      throw Exception('Todos los campos deben estar llenos');
    }

    // Si pasa las validaciones, guardar la materia en Firebase Firestore
    await materiasCollection.doc(materia.nombre).set({
      'nombre': materia.nombre,
      'color': materia.color,
      'profesor': materia.profesor,
      'aula': materia.aula,
      'horario': {
        'diaSemana': materia.horario.diaSemana,
        'horaInicio': materia.horario.horaInicio,
        'horaFin': materia.horario.horaFin,
      },
    });
  }
}
