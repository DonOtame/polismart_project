import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher_string.dart';

class DocumentoClaseList extends StatelessWidget {
  final String nombreMateria;

  DocumentoClaseList({required this.nombreMateria});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('materias')
          .doc(nombreMateria)
          .collection('documentos')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final materials = snapshot.data!.docs;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListView.builder(
              shrinkWrap: true,
              itemCount: materials.length,
              itemBuilder: (context, index) {
                final material =
                    materials[index].data() as Map<String, dynamic>;
                final tipo = material['tipo'];
                final titulo = material['titulo'];
                final url = material['url'];

                return MaterialClaseCard(
                  tipo: tipo,
                  titulo: titulo,
                  url: url,
                );
              },
            ),
          ],
        );
      },
    );
  }
}

class MaterialClaseCard extends StatelessWidget {
  final String tipo;
  final String titulo;
  final String url;

  MaterialClaseCard({
    required this.tipo,
    required this.titulo,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.all(10),
      child: InkWell(
        onTap: () async {
          final urlToLaunch = Uri.tryParse(url);
          if (urlToLaunch != null && urlToLaunch.isAbsolute) {
            if (await canLaunch(urlToLaunch.toString())) {
              await launch(urlToLaunch.toString());
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('No se puede abrir el enlace: $url'),
                ),
              );
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('El URL no es válido: $url'),
              ),
            );
          }
        },
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
                    tipoIconos.containsKey(tipo)
                        ? tipoIconos[tipo]
                        : Icons.folder,
                    color: Colors.blue,
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
                onPressed: () async {
                  final urlToLaunch = Uri.tryParse(url);
                  if (urlToLaunch != null && urlToLaunch.isAbsolute) {
                    if (await canLaunch(urlToLaunch.toString())) {
                      await launch(urlToLaunch.toString());
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('No se puede abrir el enlace: $url'),
                        ),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('El URL no es válido: $url'),
                      ),
                    );
                  }
                },
                child: Text(
                  'Ver Documento',
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
      ),
    );
  }
}

void _launchURL(String url) async {
  if (await canLaunchUrlString(url)) {
    await launchUrlString(url);
  } else {
    throw 'No se pudo abrir la URL: $url';
  }
}

// Define un mapa que mapea tipos a iconos
Map<String, IconData> tipoIconos = {
  'Teoria': Icons.book,
  'Pruebas': Icons.assignment,
  'Tareas': Icons.assignment_turned_in,
  'Formulario': Icons.folder,
};
