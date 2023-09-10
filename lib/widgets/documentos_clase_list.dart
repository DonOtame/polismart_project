import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:polismart_project/services/firebase_deleteMateria.dart';
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
          return const Center(
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
                  nombreMateria: nombreMateria,
                  context: context, // Pasa el contexto
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
  final String nombreMateria;
  final BuildContext context; // Agrega el campo de contexto

  MaterialClaseCard({
    required this.tipo,
    required this.titulo,
    required this.url,
    required this.nombreMateria,
    required this.context, // Recibe el contexto
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: () async {
          final urlToLaunch = Uri.tryParse(url);
          if (urlToLaunch != null && urlToLaunch.isAbsolute) {
            if (await canLaunchUrlString(urlToLaunch.toString())) {
              await launchUrlString(urlToLaunch.toString());
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
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    tipo,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF0F2440),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(
                    tipoIconos.containsKey(tipo)
                        ? tipoIconos[tipo]
                        : Icons.folder,
                    color: const Color(0xFF0F2440),
                    size: 24,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                titulo,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () async {
                      final urlToLaunch = Uri.tryParse(url);
                      if (urlToLaunch != null && urlToLaunch.isAbsolute) {
                        if (await canLaunchUrlString(urlToLaunch.toString())) {
                          await launchUrlString(urlToLaunch.toString());
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  Text('No se puede abrir el enlace: $url'),
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
                    child: const Text(
                      'Ver Documento',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF0F2440),
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      eliminarMaterial(context, nombreMateria, url);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text(
                      'Eliminar',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Map<String, IconData> tipoIconos = {
  'Teoria': Icons.book,
  'Pruebas': Icons.assignment,
  'Tareas': Icons.assignment_turned_in,
  'Formulario': Icons.folder,
};
