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

Widget buildHorarioContent() => StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('materias').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final documents = snapshot.data!.docs;
        documents.sort((a, b) {
          final diaSemanaA = a['horario']['diaSemana'];
          final diaSemanaB = b['horario']['diaSemana'];
          final ordenDiaA = dayOrder[diaSemanaA] ?? 0;
          final ordenDiaB = dayOrder[diaSemanaB] ?? 0;
          return ordenDiaA.compareTo(ordenDiaB);
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

            return buildMateriaCard(
              nombre: nombre,
              diaSemana: diaSemana,
              horaInicio: horaInicio,
              horaFin: horaFin,
              aula: aula,
            );
          },
        );
      },
    );

Widget buildMateriaCard({
  required String nombre,
  required String diaSemana,
  required String horaInicio,
  required String horaFin,
  required String aula,
}) =>
    Card(
      elevation: 3,
      margin: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
        side: BorderSide(
          color: Colors.black.withOpacity(0.2), // Borde de tarjeta
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              nombre,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Día: $diaSemana',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            Text(
              'Horario: $horaInicio - $horaFin',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            Text(
              'Aula: $aula',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
