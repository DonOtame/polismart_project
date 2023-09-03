import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MaterialClaseList extends StatelessWidget {
  final String nombreMateria;

  MaterialClaseList({required this.nombreMateria});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('materias')
          .doc(nombreMateria)
          .collection('material')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text('No hay materiales de clase disponibles.'),
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
      margin: EdgeInsets.all(8),
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
        child: ListTile(
          title: Text(
            'Tipo: $tipo',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text('Título: $titulo'),
        ),
      ),
    );
  }
}
