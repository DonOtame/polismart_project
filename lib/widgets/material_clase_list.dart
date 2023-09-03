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
          return CircularProgressIndicator();
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Text('No hay materiales de clase disponibles.');
        }

        final materials = snapshot.data!.docs;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Materiales de Clase:'),
            ListView.builder(
              shrinkWrap: true,
              itemCount: materials.length,
              itemBuilder: (context, index) {
                final material =
                    materials[index].data() as Map<String, dynamic>;
                final tipo = material['tipo'];
                final titulo = material['titulo'];
                final url = material['url'];

                return ListTile(
                  title: Text('Tipo: $tipo'),
                  subtitle: Text('Título: $titulo'),
                  onTap: () async {
                    final urlToLaunch = Uri.tryParse(url);
                    if (urlToLaunch != null && urlToLaunch.isAbsolute) {
                      if (await canLaunchUrl(urlToLaunch)) {
                        await launchUrl(urlToLaunch);
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
                );
              },
            ),
          ],
        );
      },
    );
  }
}
