import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:polismart_project/models/materia.dart';

class MateriaProvider {
  final CollectionReference materiasCollection =
      FirebaseFirestore.instance.collection('materias');

  Future<void> agregarMateria(Materia materia) async {
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
