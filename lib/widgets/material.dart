import 'package:flutter/material.dart';
import 'package:polismart_project/screens/form_materialclase.dart';
import 'package:polismart_project/widgets/material_clase_list.dart';

Widget buildMaterialClase(BuildContext context, String nombreMateria) {
  return Column(
    children: [
      Expanded(
        child: SingleChildScrollView(
          child: MaterialClaseList(
            nombreMateria: nombreMateria,
          ),
        ),
      ),
      const SizedBox(height: 20),
      ElevatedButton(
        onPressed: () {
          abrirFormMaterial(context, nombreMateria);
        },
        child: const Text('Agregar Material'),
      ),
    ],
  );
}

void abrirFormMaterial(BuildContext context, String nombreMateria) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => FormMaterialClase(nombreMateria: nombreMateria),
    ),
  );
}
