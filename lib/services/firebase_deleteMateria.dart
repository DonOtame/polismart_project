import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<bool> confirmDeleteMateria(
    BuildContext context, String nombreMateria) async {
  final confirmDelete = await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Confirmar eliminación'),
        content: Text('¿Estás seguro de que deseas eliminar esta materia?'),
        actions: <Widget>[
          TextButton(
            child: Text('Cancelar'),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          TextButton(
            child: Text('Eliminar'),
            onPressed: () async {
              // Eliminar la materia de Firebase
              try {
                await FirebaseFirestore.instance
                    .collection('materias')
                    .where('nombre', isEqualTo: nombreMateria)
                    .get()
                    .then((querySnapshot) {
                  querySnapshot.docs.forEach((doc) {
                    doc.reference.delete();
                  });
                });

                // Mostrar un SnackBar para confirmar la eliminación exitosa
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('La materia se ha eliminado con éxito'),
                  ),
                );

                // Regresar a la pantalla anterior
                Navigator.of(context).pop(true);
              } catch (e) {
                print('Error al eliminar la materia: $e');
                Navigator.of(context).pop(false);
              }
            },
          ),
        ],
      );
    },
  );

  return confirmDelete == true;
}
