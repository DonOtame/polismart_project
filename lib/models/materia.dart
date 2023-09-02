class Materia {
  final String nombre;
  final String color;
  final String profesor;
  final String aula;
  final Horario horario;

  Materia({
    required this.nombre,
    required this.color,
    required this.profesor,
    required this.aula,
    required this.horario,
  });
}

class Horario {
  late final String diaSemana;
  late final String horaInicio;
  late final String horaFin;

  Horario({
    required this.diaSemana,
    required this.horaInicio,
    required this.horaFin,
  });
}
