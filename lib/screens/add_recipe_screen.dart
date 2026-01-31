import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import '../services/storage_service.dart';


class AddRecipeScreen extends StatefulWidget {
const AddRecipeScreen({super.key});


@override
State<AddRecipeScreen> createState() => _AddRecipeScreenState();
}


class _AddRecipeScreenState extends State<AddRecipeScreen> {
final _title = TextEditingController();
final _desc = TextEditingController();
String _category = 'General';
File? _imageFile;
bool _loading = false;
final _picker = ImagePicker();
final _storageService = StorageService();


Future<void> _pickImage() async {
final XFile? picked = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
if (picked != null) {
setState(() => _imageFile = File(picked.path));
}
}


Future<void> _saveRecipe() async {
if (_title.text.trim().isEmpty || _desc.text.trim().isEmpty) {
ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill title and description')));
return;
}


setState(() => _loading = true);
try {
final id = const Uuid().v4();
String imageUrl = '';
if (_imageFile != null) {
imageUrl = await _storageService.uploadRecipeImage(_imageFile!, '$id.jpg');
}


final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
final data = {
'title': _title.text.trim(),
'description': _desc.text.trim(),
'imageUrl': imageUrl,
'category': _category,
'userId': userId,
'createdAt': DateTime.now().toIso8601String(),
};


await FirebaseFirestore.instance.collection('recipes').doc(id).set(data);
if (!mounted) return;
Navigator.pop(context);
} catch (e) {
ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
} finally {
if (mounted) setState(() => _loading = false);
}
}


@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(title: const Text('Add Recipe')),
body: SingleChildScrollView(
padding: const EdgeInsets.all(16),
child: Column(
children: [
TextField(controller: _title, decoration: const InputDecoration(labelText: 'Title')),
TextField(controller: _desc, decoration: const InputDecoration(labelText: 'Description'), maxLines: 5),
const SizedBox(height: 10),
DropdownButtonFormField<String>(
value: _category,
items: ['General', 'Breakfast', 'Lunch', 'Dinner', 'Dessert'].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
onChanged: (v) => setState(() => _category = v ?? 'General'),
decoration: const InputDecoration(labelText: 'Category'),
),
const SizedBox(height: 10),
InkWell(
onTap: _pickImage,
child: _imageFile == null ? Container(height: 150, color: Colors.grey[200], child: const Center(child: Text('Tap to pick image'))) : Image.file(_imageFile!, height: 150, fit: BoxFit.cover),
),
const SizedBox(height: 20),
ElevatedButton(onPressed: _loading ? null : _saveRecipe, child: _loading ? const CircularProgressIndicator() : const Text('Save')),
],
),
),
);
}
}