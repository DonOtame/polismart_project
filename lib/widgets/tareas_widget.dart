import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TareaCard extends StatelessWidget {
  final String title;
  final Widget content;

  const TareaCard({Key? key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: const Color(0xFF0F2440),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          content,
        ],
      ),
    );
  }
}

Widget buildTareaCard(Map<String, dynamic> tareaData) {
  final estado = tareaData['estado'];
  if (estado == false) {
    final titulo = tareaData['titulo'];
    final descripcion = tareaData['descripcion'];
    final fechaCreacion = tareaData['fechaCreacion'];
    final fechaFin = tareaData['fechaFin'];

    return _buildTaskCard(
      titulo,
      'Descripción: $descripcion',
      'Fecha de Creación: $fechaCreacion',
      'Fecha de Fin: $fechaFin',
      'Estado: Pendiente',
      Colors.black,
      Colors.red,
    );
  } else {
    return const SizedBox.shrink();
  }
}

Widget _buildTaskCard(String title, String description, String creationDate,
    String endDate, String state, Color titleColor, Color stateColor) {
  return Card(
    elevation: 3,
    margin: const EdgeInsets.all(10),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15.0),
      side: BorderSide(
        color: Colors.black.withOpacity(0.2),
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 8),
          _buildInfoRow(description),
          _buildInfoRow(creationDate),
          _buildInfoRow(endDate),
          _buildInfoRow(state, color: stateColor),
        ],
      ),
    ),
  );
}

Widget _buildInfoRow(String label, {Color color = Colors.black}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Text(
      label,
      style: TextStyle(
        fontSize: 16,
        color: color,
      ),
    ),
  );
}

Widget buildTareaList(CollectionReference tareaCollection) {
  return StreamBuilder<QuerySnapshot>(
    stream: tareaCollection.where('estado', isEqualTo: false).snapshots(),
    builder: (context, tareaSnapshot) {
      if (tareaSnapshot.hasError ||
          tareaSnapshot.connectionState == ConnectionState.waiting) {
        return CircularProgressIndicator();
      }

      final tareaDocuments = tareaSnapshot.data!.docs;

      return Column(
        children: tareaDocuments
            .map((tareaDoc) =>
                buildTareaCard(tareaDoc.data() as Map<String, dynamic>))
            .toList(),
      );
    },
  );
}

Widget buildMateriaCard(QueryDocumentSnapshot materiaDocument) {
  final tareaCollection = FirebaseFirestore.instance
      .collection('materias/${materiaDocument.id}/tareas');

  return StreamBuilder<QuerySnapshot>(
    stream: tareaCollection.snapshots(),
    builder: (context, tareaSnapshot) {
      if (tareaSnapshot.hasError ||
          tareaSnapshot.connectionState == ConnectionState.waiting) {
        return CircularProgressIndicator();
      }

      final tareaDocuments = tareaSnapshot.data!.docs;

      return tareaDocuments.any((tareaDoc) => tareaDoc['estado'] == false)
          ? TareaCard(
              title: materiaDocument['nombre'],
              content: buildTareaList(tareaCollection),
            )
          : const SizedBox.shrink();
    },
  );
}

Widget buildTareasContent() {
  return StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance.collection('materias').snapshots(),
    builder: (context, snapshot) {
      if (snapshot.hasError ||
          snapshot.connectionState == ConnectionState.waiting) {
        return CircularProgressIndicator();
      }

      final documents = snapshot.data!.docs;

      return ListView.builder(
        itemCount: documents.length,
        itemBuilder: (context, index) => buildMateriaCard(documents[index]),
      );
    },
  );
}
