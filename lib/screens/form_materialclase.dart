import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:polismart_project/services/firebase_upload.dart';

class FormMaterialClase extends StatefulWidget {
  final String nombreMateria;

  FormMaterialClase({required this.nombreMateria});

  @override
  _FormMaterialClaseState createState() => _FormMaterialClaseState();
}

class _FormMaterialClaseState extends State<FormMaterialClase> {
  final TextEditingController _nombreController = TextEditingController();
  String? _tipoMaterial;
  String? _archivoNombre;
  File? _archivoSeleccionado;
  bool _subiendoArchivo = false;
  String? _mensajeResultado;

  final List<String> _opcionesTipoMaterial = [
    'Teoria',
    'Pruebas',
    'Tareas',
    'Formulario'
  ];

  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _seleccionarArchivo() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        _archivoSeleccionado = File(result.files.single.path!);
        _archivoNombre = _archivoSeleccionado!.path.split('/').last;
      });
    }
  }

  void _subirArchivo() async {
    setState(() {
      _subiendoArchivo = true;
      _mensajeResultado = null;
    });

    if (_archivoSeleccionado != null) {
      String? downloadURL = await uploadArchivo(_archivoSeleccionado!);

      if (downloadURL != null) {
        await _firestore
            .collection('materias')
            .doc(widget.nombreMateria)
            .collection('material')
            .add({
          'tipo': _tipoMaterial,
          'titulo': _nombreController.text,
          'url': downloadURL,
        });

        setState(() {
          _subiendoArchivo = false;
          _mensajeResultado = 'Archivo subido con éxito.';
          print('URL de descarga del archivo: $downloadURL');
        });
      } else {
        setState(() {
          _subiendoArchivo = false;
          _mensajeResultado = 'La subida del archivo falló.';
          print('La subida del archivo falló.');
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Material a ${widget.nombreMateria}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<String>(
              value: _tipoMaterial,
              decoration: InputDecoration(labelText: 'Tipo de Material'),
              items: _opcionesTipoMaterial.map((tipo) {
                return DropdownMenuItem<String>(
                  value: tipo,
                  child: Text(tipo),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _tipoMaterial = value;
                });
              },
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _nombreController,
              decoration: InputDecoration(labelText: 'Nombre del Material'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _seleccionarArchivo,
              child: Text('Seleccionar Archivo'),
            ),
            SizedBox(height: 16.0),
            if (_archivoNombre != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Nombre del Archivo Seleccionado:'),
                  SizedBox(height: 8.0),
                  Text(
                    _archivoNombre!,
                    style: TextStyle(color: Colors.blue),
                  ),
                  SizedBox(height: 16.0),
                  Center(
                    child: ElevatedButton(
                      onPressed: _subirArchivo,
                      child: Text('Subir Archivo a ${widget.nombreMateria}'),
                    ),
                  ),
                ],
              ),
            if (_subiendoArchivo)
              Center(
                child: CircularProgressIndicator(),
              ),
            if (_mensajeResultado != null)
              AlertDialog(
                title: Text('Resultado de la subida'),
                content: Text(_mensajeResultado!),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cerrar'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
