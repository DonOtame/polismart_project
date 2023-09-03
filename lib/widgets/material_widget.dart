import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

Widget buildMaterialesContent() {
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

      final List<QueryDocumentSnapshot> materias = snapshot.data!.docs;

      return ListView.builder(
        itemCount: materias.length,
        itemBuilder: (context, index) {
          final materiaData = materias[index].data() as Map<String, dynamic>;
          final nombreMateria = materiaData['nombre'];

          return Card(
            elevation: 3,
            margin: const EdgeInsets.all(10),
            child: Column(
              children: [
                ListTile(
                  title: Text(
                    nombreMateria,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                buildMaterialesList(
                  materias[index].reference.collection('material'),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

Widget buildMaterialesList(CollectionReference materialesCollection) {
  return StreamBuilder<QuerySnapshot>(
    stream: materialesCollection.snapshots(),
    builder: (context, materialesSnapshot) {
      if (materialesSnapshot.hasError) {
        return Center(
          child: Text('Error: ${materialesSnapshot.error}'),
        );
      }

      if (materialesSnapshot.connectionState == ConnectionState.waiting) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }

      final List<QueryDocumentSnapshot> materialesDocs =
          materialesSnapshot.data!.docs;

      return Column(
        children: materialesDocs.map((materialDoc) {
          final materialData = materialDoc.data() as Map<String, dynamic>;
          final tipo = materialData['tipo'];
          final titulo = materialData['titulo'];
          final url = materialData['url'];

          return buildMaterialCard(tipo, titulo, url);
        }).toList(),
      );
    },
  );
}

Widget buildMaterialCard(String tipo, String titulo, String url) {
  // Define un mapa que mapea tipos a iconos
  Map<String, IconData> tipoIconos = {
    'Teoria': Icons.book,
    'Pruebas': Icons.assignment,
    'Tareas': Icons.assignment_turned_in,
    'Formulario': Icons.folder,
  };

  // Obtén el icono correspondiente al tipo o utiliza uno predeterminado
  IconData? icono =
      tipoIconos.containsKey(tipo) ? tipoIconos[tipo] : Icons.folder;

  return Card(
    elevation: 3,
    margin: const EdgeInsets.all(10),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tipo: $tipo',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              Icon(
                icono,
                color: Colors.blue, // Color del icono
              ),
            ],
          ),
          Text(
            'Título: $titulo',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 8),
          TextButton(
            onPressed: () {
              _launchURL(url); // Llama a la función para abrir la URL
            },
            child: Text(
              'Ver Material',
              style: TextStyle(
                fontSize: 16,
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

void _launchURL(String url) async {
  if (await canLaunchUrlString(url)) {
    await launchUrlString(url);
  } else {
    throw 'No se pudo abrir la URL: $url';
  }
}
