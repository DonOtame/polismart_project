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
      'horarios': materia.horarios.map((horario) {
        return {
          'diaSemana': horario.diaSemana,
          'horaInicio': horario.horaInicio,
          'horaFin': horario.horaFin,
        };
      }).toList(),
    });
  }
}
