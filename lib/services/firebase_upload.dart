import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

final FirebaseStorage storage = FirebaseStorage.instance;

Future<String?> uploadArchivo(File file) async {
  try {
    // Genera una referencia única para el archivo en Firebase Storage.
    final Reference storageReference = storage.ref().child(
        'carpeta_destino/${DateTime.now().millisecondsSinceEpoch.toString()}');

    // Sube el archivo a Firebase Storage.
    final UploadTask uploadTask = storageReference.putFile(file);

    // Espera a que se complete la subida.
    final TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);

    // Obtiene la URL de descarga del archivo subido.
    final String downloadURL = await storageReference.getDownloadURL();

    // Devuelve la URL de descarga del archivo.
    return downloadURL;
  } catch (e) {
    // Maneja cualquier error que pueda ocurrir durante la subida del archivo.
    print('Error al subir el archivo a Firebase Storage: $e');
    return null; // Devuelve null para indicar que la subida falló.
  }
}
