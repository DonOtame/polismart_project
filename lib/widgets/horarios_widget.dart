import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Map<String, int> dayOrder = {
  'Lunes': 1,
  'Martes': 2,
  'Miércoles': 3,
  'Jueves': 4,
  'Viernes': 5,
  'Sábado': 6,
  'Domingo': 7,
};

Widget buildHorarioContent() {
  return StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance.collection('materias').snapshots(),
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return Center(
          child: Text('Error: ${snapshot.error}'),
        );
      }

      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }

      final List<QueryDocumentSnapshot> documents = snapshot.data!.docs;

      documents.sort((a, b) {
        final diaSemanaA = a['horario']['diaSemana'];
        final diaSemanaB = b['horario']['diaSemana'];
        final ordenDiaA = dayOrder[diaSemanaA];
        final ordenDiaB = dayOrder[diaSemanaB];

        if (ordenDiaA != null && ordenDiaB != null) {
          return ordenDiaA.compareTo(ordenDiaB);
        }

        return 0;
      });

      return ListView.builder(
        itemCount: documents.length,
        itemBuilder: (context, index) {
          final data = documents[index].data() as Map<String, dynamic>;
          final nombre = data['nombre'];
          final horarioData = data['horario'] as Map<String, dynamic>;
          final diaSemana = horarioData['diaSemana'];
          final horaInicio = horarioData['horaInicio'];
          final horaFin = horarioData['horaFin'];
          final aula = data['aula'];

          return Card(
            elevation: 3,
            margin: const EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nombre,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Día: $diaSemana',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    'Horario: $horaInicio - $horaFin',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    'Aula: $aula',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
