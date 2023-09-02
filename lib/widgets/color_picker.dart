// widgets/color_picker.dart
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ColorPickerWidget extends StatelessWidget {
  final Color selectedColor;
  final Function(Color) onColorChanged;

  ColorPickerWidget(
      {required this.selectedColor, required this.onColorChanged});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    ColorPicker(
                      pickerColor: selectedColor,
                      onColorChanged: (color) {
                        onColorChanged(
                            color); // Llama a la función proporcionada cuando cambia el color.
                      },
                      colorPickerWidth: 300.0,
                      pickerAreaHeightPercent: 0.7,
                      enableAlpha: true,
                      displayThumbColor: true,
                      paletteType: PaletteType.hsv,
                    ),
                    SizedBox(
                        height:
                            16.0), // Espaciado entre el selector de color y el botón
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              10.0), // Ajusta el radio de borde
                        ),
                      ),
                      child: Text(
                        'Aceptar',
                        style: TextStyle(
                          color: Colors
                              .white, // Cambia el color del texto del botón
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0), // Ajusta el radio de borde
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: selectedColor,
              borderRadius:
                  BorderRadius.circular(10.0), // Ajusta el radio de borde
            ),
          ),
          SizedBox(width: 8.0), // Espaciado entre el icono y el texto
          Text(
            'Seleccionar Color',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
