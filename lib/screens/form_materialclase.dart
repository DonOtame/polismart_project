import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FormMaterialClase extends StatefulWidget {
  final String nombreMateria;

  FormMaterialClase({required this.nombreMateria});

  @override
  _FormMaterialClaseState createState() => _FormMaterialClaseState();
}

class _FormMaterialClaseState extends State<FormMaterialClase> {
  final TextEditingController _tipoController = TextEditingController();
  String _archivoURL = ''; // URL del archivo subido
  final FirebaseStorage _storage = FirebaseStorage.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Material de Clase a ${widget.nombreMateria}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _tipoController,
              decoration: InputDecoration(labelText: 'Tipo de Material'),
            ),
            ElevatedButton(
              onPressed: () {
                _subirArchivo(context);
              },
              child: Text('Subir Archivo'),
            ),
            if (_archivoURL.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Text('Archivo Subido:'),
                  Text(
                    _archivoURL,
                    style: TextStyle(color: Colors.blue),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _subirArchivo(BuildContext context) async {
    final tipo = _tipoController.text;

    // Validar que los campos no estén vacíos
    if (tipo.isEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Por favor, complete todos los campos.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Aceptar'),
              ),
            ],
          );
        },
      );
      return;
    }

    // Abre el selector de archivos para el usuario
    final filePickerResult = await FilePicker.platform.pickFiles();

    if (filePickerResult != null) {
      final fileBytes = filePickerResult.files.single.bytes;
      final fileName = filePickerResult.files.single.name;

      try {
        // Subir el archivo a Firebase Storage
        final Reference storageReference = _storage.ref().child(fileName);

        final UploadTask uploadTask = storageReference.putData(fileBytes!);

        await uploadTask.whenComplete(() async {
          // Obtener la URL del archivo subido
          final archivoURL = await storageReference.getDownloadURL();

          setState(() {
            _archivoURL = archivoURL;
          });

          // Guardar el material de clase en Firebase Firestore
          final materialClaseRef = FirebaseFirestore.instance
              .collection('materias')
              .doc(widget.nombreMateria)
              .collection('materialClase')
              .doc();

          materialClaseRef.set({
            'tipo': tipo,
            'archivoURL': _archivoURL,
          }).then((value) {
            // Cerrar la pantalla de formulario
            Navigator.of(context).pop();
          }).catchError((error) {
            print('Error al guardar el material de clase: $error');
            // Mostrar un mensaje de error en caso de que ocurra un error al guardar el material de clase
          });
        });
      } catch (error) {
        print('Error al subir el archivo: $error');
      }
    }
  }

  @override
  void dispose() {
    _tipoController.dispose();
    super.dispose();
  }
}
