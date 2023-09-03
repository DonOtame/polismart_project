import 'package:flutter/material.dart';
import 'package:polismart_project/screens/form_materia.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:polismart_project/screens/materia_info.dart';

class PoliSmartScreen extends StatelessWidget {
  const PoliSmartScreen({Key? key});

  Color getColorFromFirebaseString(String colorString) {
    final match = RegExp(r'0x([0-9a-fA-F]+)').firstMatch(colorString);
    if (match != null) {
      final hexColor =
          match.group(1); // Usar el grupo 1 para obtener el valor hexadecimal
      final int? colorValue = int.tryParse(hexColor!, radix: 16);
      if (colorValue != null) {
        return Color(colorValue);
      }
    }
    // Valor predeterminado en caso de que no se pueda analizar el color.
    return Colors.green;
  }

  Future<void> fetchDataFromFirestore() async {
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('materias') // Reemplaza con el nombre de tu colección
        .get();

    // Itera a través de los documentos y muestra los datos en la consola
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
            color: Color(0xFFD9CE9A), // Color del texto
          ),
        ),
        leading: PopupMenuButton<String>(
          onSelected: (value) {
            // Agregar aquí la lógica para las opciones del menú emergente.
            if (value == 'apuntes') {
              // Lógica para Apuntes.
            } else if (value == 'horario') {
              // Lógica para Horario.
            } else if (value == 'materias') {
              // Lógica para Materias.
            } else if (value == 'tareas') {
              // Lógica para Tareas.
            } else if (value == 'teoria') {
              // Lógica para Teoría.
            }
          },
          icon: const Icon(
            Icons.menu,
            color: Color(0xFFD9CE9A), // Color del icono del menú emergente
          ),
          color: const Color(0xFF0F2440),
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            const PopupMenuItem<String>(
              value: 'apuntes',
              textStyle: TextStyle(color: Color(0xFFD9CE9A)),
              child: Text('Apuntes'),
            ),
            const PopupMenuItem<String>(
              value: 'horario',
              textStyle: TextStyle(color: Color(0xFFD9CE9A)),
              child: Text('Horario'),
            ),
            const PopupMenuItem<String>(
              value: 'materias',
              textStyle: TextStyle(color: Color(0xFFD9CE9A)),
              child: Text('Materias'),
            ),
            const PopupMenuItem<String>(
              value: 'tareas',
              textStyle: TextStyle(color: Color(0xFFD9CE9A)),
              child: Text('Tareas'),
            ),
            const PopupMenuItem<String>(
              value: 'teoria',
              textStyle: TextStyle(color: Color(0xFFD9CE9A)),
              child: Text('Teoría'),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add,
              color: Color(0xFFD9CE9A), // Color del icono de agregar
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
      body: SingleChildScrollView(
        child: StreamBuilder<QuerySnapshot>(
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
                crossAxisCount: 2, // Dos tarjetas por fila
              ),
              itemCount: documents.length,
              itemBuilder: (context, index) {
                final data = documents[index].data() as Map<String, dynamic>;
                final nombre = data['nombre'];
                final colorString = data['color']; // Obtén el color como cadena
                final color = getColorFromFirebaseString(
                    colorString); // Convierte la cadena en un Color

                return InkWell(
                  onTap: () {
                    // Realiza la acción que desees al tocar la tarjeta
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
                              color: color, // Usa el color obtenido de Firebase
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
      ),
      extendBodyBehindAppBar: true,
      extendBody: true,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.keyboard),
            label: 'Teclado',
            backgroundColor: Color(0xFF0F2440),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mic),
            label: 'Micrófono',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_enhance),
            label: 'Cámara',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check),
            label: 'Visto',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz),
            label: 'Más',
          ),
        ],
        selectedItemColor: const Color(0xFFD9CE9A),
        unselectedItemColor: const Color(0xFFD9CE9A),
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
    );
  }
}
