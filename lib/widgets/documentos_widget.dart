import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher_string.dart';

Widget buildDocumentosContent() {
  return StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance.collection('materias').snapshots(),
    builder: (context, snapshot) {
      if (snapshot.hasError ||
          snapshot.connectionState == ConnectionState.waiting) {
        return buildLoadingErrorWidget(snapshot);
      }

      final materiasDocs = snapshot.data!.docs;

      return ListView.builder(
        itemCount: materiasDocs.length,
        itemBuilder: (context, index) {
          final materiaData =
              materiasDocs[index].data() as Map<String, dynamic>;
          final materiaNombre = materiaData['nombre'];

          final documentosCollection =
              materiasDocs[index].reference.collection('documentos');

          return StreamBuilder<QuerySnapshot>(
            stream: documentosCollection.snapshots(),
            builder: (context, documentosSnapshot) {
              if (documentosSnapshot.hasError ||
                  documentosSnapshot.connectionState ==
                      ConnectionState.waiting) {
                return Container();
              }

              final documentosDocs = documentosSnapshot.data!.docs;

              if (documentosDocs.isEmpty) {
                return Container();
              }

              return buildMateriaCard(materiaNombre, documentosCollection);
            },
          );
        },
      );
    },
  );
}

Widget buildMateriaCard(
    String materiaNombre, CollectionReference documentosCollection) {
  return Card(
    elevation: 3,
    margin: const EdgeInsets.all(10),
    child: Column(
      children: [
        ListTile(
          title: Text(
            materiaNombre,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        buildDocumentosList(documentosCollection),
      ],
    ),
  );
}

Widget buildDocumentosList(CollectionReference documentosCollection) {
  return StreamBuilder<QuerySnapshot>(
    stream: documentosCollection.snapshots(),
    builder: (context, documentosSnapshot) {
      if (documentosSnapshot.hasError ||
          documentosSnapshot.connectionState == ConnectionState.waiting) {
        return buildLoadingErrorWidget(documentosSnapshot);
      }

      final documentosDocs = documentosSnapshot.data!.docs;

      if (documentosDocs.isEmpty) {
        return const Center(child: Text('No hay documentos disponibles.'));
      }

      return Column(
        children: documentosDocs.map((documentoDoc) {
          final documentoData = documentoDoc.data() as Map<String, dynamic>;
          final tipo = documentoData['tipo'];
          final titulo = documentoData['titulo'] ?? 'Sin título';
          final url = documentoData['url'];

          return buildDocumentosCard(tipo, titulo, url);
        }).toList(),
      );
    },
  );
}

Widget buildLoadingErrorWidget(AsyncSnapshot<QuerySnapshot> snapshot) {
  return Center(
    child: snapshot.hasError
        ? Text('Error: ${snapshot.error}')
        : const CircularProgressIndicator(),
  );
}

Widget buildDocumentosCard(String tipo, String titulo, String url) {
  final tipoIconos = {
    'Teoria': Icons.book,
    'Pruebas': Icons.assignment,
    'Tareas': Icons.assignment_turned_in,
    'Formulario': Icons.folder,
  };

  final icono = tipoIconos[tipo] ?? Icons.folder;

  return Card(
    elevation: 3,
    margin: const EdgeInsets.all(10),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icono,
                color: const Color(0xFF0F2440),
                size: 32,
              ),
              const SizedBox(width: 16),
              Text(
                'Tipo: $tipo',
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Título: $titulo',
            style: const TextStyle(
              fontSize: 22,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _launchURL(url),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: const Color(0xFF0F2440),
            ),
            child: const Text(
              'Ver Documento',
              style: TextStyle(
                fontSize: 18,
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
