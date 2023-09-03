import 'package:flutter/material.dart';
import 'package:polismart_project/screens/form_documentosclase.dart';
import 'package:polismart_project/widgets/documentos_clase_list.dart';

Widget buildDocumentosClase(BuildContext context, String nombreMateria) {
  return Column(
    children: [
      Expanded(
        child: SingleChildScrollView(
          child: DocumentoClaseList(
            nombreMateria: nombreMateria,
          ),
        ),
      ),
      const SizedBox(height: 20),
      ElevatedButton(
        onPressed: () {
          abrirFormDocumentos(context, nombreMateria);
        },
        child: const Text('Agregar Documentos'),
      ),
    ],
  );
}

void abrirFormDocumentos(BuildContext context, String nombreMateria) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => FormDocumentosClase(nombreMateria: nombreMateria),
    ),
  );
}
