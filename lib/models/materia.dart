class Materia {
  final String nombre;
  final String color;
  final String profesor;
  final String aula;
  final List<Horario> horarios;

  Materia({
    required this.nombre,
    required this.color,
    required this.profesor,
    required this.aula,
    required this.horarios,
  });
}

class Horario {
  final String diaSemana;
  final String horaInicio;
  final String horaFin;

  Horario({
    required this.diaSemana,
    required this.horaInicio,
    required this.horaFin,
  });
}
