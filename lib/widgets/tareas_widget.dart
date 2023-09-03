import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Widget buildMateriaCard(QueryDocumentSnapshot materiaDocument) {
  final materiaData = materiaDocument.data() as Map<String, dynamic>;
  final nombreMateria = materiaData['nombre'];
  final tareaCollection = FirebaseFirestore.instance
      .collection('materias/${materiaDocument.id}/tareas');

  return CustomCard(
    title: nombreMateria,
    content: buildTareaList(tareaCollection),
  );
}

Widget buildTareaCard(Map<String, dynamic> tareaData) {
  final titulo = tareaData['titulo'];
  final descripcion = tareaData['descripcion'];
  final fechaCreacion = tareaData['fechaCreacion'];
  final fechaFin = tareaData['fechaFin'];
  final estado = tareaData['estado'];

  return CustomCard(
    title: titulo,
    content: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Descripción: $descripcion',
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
        Text(
          'Fecha de Creación: $fechaCreacion',
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
        Text(
          'Fecha de Fin: $fechaFin',
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
        Text(
          'Estado: ${estado ? "Completada" : "Pendiente"}',
          style: TextStyle(
              fontSize: 16, color: estado ? Colors.green : Colors.red),
        ),
      ],
    ),
  );
}

class CustomCard extends StatelessWidget {
  final String title;
  final Widget content;

  CustomCard({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          content,
        ],
      ),
    );
  }
}

Widget buildTareaList(CollectionReference tareaCollection) {
  return StreamBuilder<QuerySnapshot>(
    stream: tareaCollection.snapshots(),
    builder: (context, tareaSnapshot) {
      if (tareaSnapshot.hasError) {
        return Center(
          child: Text('Error: ${tareaSnapshot.error}'),
        );
      }

      if (tareaSnapshot.connectionState == ConnectionState.waiting) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }

      final List<QueryDocumentSnapshot> tareaDocuments =
          tareaSnapshot.data!.docs;

      return Column(
        children: tareaDocuments.map((tareaDoc) {
          return buildTareaCard(tareaDoc.data() as Map<String, dynamic>);
        }).toList(),
      );
    },
  );
}

Widget buildTareasContent() {
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

      return ListView.builder(
        itemCount: documents.length,
        itemBuilder: (context, index) {
          return buildMateriaCard(documents[index]);
        },
      );
    },
  );
}
