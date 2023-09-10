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

Future<void> eliminarMaterial(
    BuildContext context, String nombreMateria, String url) async {
  final confirmacion = await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Confirmar Eliminación'),
        content:
            const Text('¿Estás seguro de que quieres eliminar este documento?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Sí'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No'),
          ),
        ],
      );
    },
  );

  if (confirmacion != null && confirmacion) {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('materias')
          .doc(nombreMateria)
          .collection('documentos')
          .where('url', isEqualTo: url)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final documentId = querySnapshot.docs.first.id;
        await FirebaseFirestore.instance
            .collection('materias')
            .doc(nombreMateria)
            .collection('documentos')
            .doc(documentId)
            .delete();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('El material se ha eliminado con éxito.'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text('No se encontró el documento con el URL proporcionado.'),
          ),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al eliminar el material: $error'),
        ),
      );
    }
  }
}
