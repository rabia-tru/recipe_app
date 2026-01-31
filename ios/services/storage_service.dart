import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';


class StorageService {
final FirebaseStorage _storage = FirebaseStorage.instance;


Future<String> uploadRecipeImage(File file, String filename) async {
final ref = _storage.ref().child('recipe_images/$filename');
final uploadTask = await ref.putFile(file);
final url = await uploadTask.ref.getDownloadURL();
return url;
}
}