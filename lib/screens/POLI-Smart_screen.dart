import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:polismart_project/screens/materia_info.dart';
import 'package:polismart_project/screens/form_materia.dart';
import 'package:polismart_project/services/color_util.dart';

class PoliSmartScreen extends StatelessWidget {
  const PoliSmartScreen({Key? key});

  Future<void> fetchDataFromFirestore() async {
    final QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('materias').get();

    querySnapshot.docs.forEach((document) {
      print(document.data());
    });
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
      body: StreamBuilder<QuerySnapshot>(
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
