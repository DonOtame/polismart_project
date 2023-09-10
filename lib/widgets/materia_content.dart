import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:polismart_project/screens/materia_info.dart';
import 'package:polismart_project/services/color_util.dart';

class MateriaCard extends StatelessWidget {
  final String nombre;
  final Color color;

  const MateriaCard({Key? key, required this.nombre, required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print('Tocaste la tarjeta $nombre');
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => DetalleMateriaScreen(nombreMateria: nombre),
          ),
        );
      },
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(20.0),
              child: const Icon(
                Icons.book,
                size: 72.0,
                color: Colors.white,
              ),
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
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildMateriasContent() {
  return StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance.collection('materias').snapshots(),
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return Center(
          child: Text('Error: ${snapshot.error}'),
        );
      }

      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      final List<QueryDocumentSnapshot> documents = snapshot.data!.docs;

      return GridView.builder(
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: documents.length,
        itemBuilder: (context, index) {
          final data = documents[index].data() as Map<String, dynamic>;
          final nombre = data['nombre'];
          final color = getColorFromFirebaseString(data['color'] as String);

          return MateriaCard(nombre: nombre, color: color);
        },
      );
    },
  );
}
