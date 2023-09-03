import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:polismart_project/screens/materia_info.dart';
import 'package:polismart_project/screens/form_materia.dart';
import 'package:polismart_project/services/color_util.dart';

class PoliSmartScreen extends StatelessWidget {
  const PoliSmartScreen({Key? key});

  // Función para obtener la lista de materias desde Firestore
  Future<List<QueryDocumentSnapshot>> fetchMateriasFromFirestore() async {
    final QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('materias').get();
    return querySnapshot.docs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'POLI-Smart',
          style: TextStyle(
            color: const Color(0xFFD9CE9A),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add,
              color: const Color(0xFFD9CE9A),
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => IngresoMateriaScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<QueryDocumentSnapshot>>(
        future: fetchMateriasFromFirestore(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          final List<QueryDocumentSnapshot> documents = snapshot.data!;

          return GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemCount: documents.length,
            itemBuilder: (context, index) {
              final data = documents[index].data() as Map<String, dynamic>;
              final nombre = data['nombre'];
              final colorString = data['color'];
              final color = getColorFromFirebaseString(colorString);

              return InkWell(
                onTap: () {
                  print('Tocaste la tarjeta $nombre');
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          DetalleMateriaScreen(nombreMateria: nombre),
                    ),
                  );
                },
                child: Card(
                  elevation: 3,
                  margin: const EdgeInsets.all(10),
                  child: AspectRatio(
                    aspectRatio: 3.0 / 4.0,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.book,
                            size: 64.0,
                            color: color,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            nombre,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
