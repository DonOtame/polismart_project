import 'package:flutter/material.dart';

class MateriaCard extends StatelessWidget {
  final String nombre;
  final Color iconColor;

  MateriaCard({required this.nombre, required this.iconColor});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Agrega aquí la lógica que deseas ejecutar al tocar la tarjeta.
      },
      child: SizedBox(
        height: 200,
        width: 190,
        child: Card(
          elevation: 3,
          margin: const EdgeInsets.all(10),
          child: Padding(
            padding: const EdgeInsets.all(1.0),
            child: Column(
              children: [
                Icon(
                  Icons.book,
                  size: 125.00,
                  color: iconColor, // Color del icono de la materia
                ),
                const SizedBox(height: 15), // Reduce el espacio inferior aquí
                Text(
                  nombre,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black, // Color del nombre de la materia
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
