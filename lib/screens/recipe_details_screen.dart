import 'package:flutter/material.dart';
import '../models/recipe_model.dart';


class RecipeDetailScreen extends StatelessWidget {
final Recipe recipe;
const RecipeDetailScreen({super.key, required this.recipe});


@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(title: Text(recipe.title)),
body: SingleChildScrollView(
padding: const EdgeInsets.all(16),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
if (recipe.imageUrl.isNotEmpty)
Image.network(recipe.imageUrl, height: 220, width: double.infinity, fit: BoxFit.cover),
const SizedBox(height: 12),
Text(recipe.title, style: Theme.of(context).textTheme.headline6),
const SizedBox(height: 8),
Text('Category: ${recipe.category}'),
const SizedBox(height: 12),
Text(recipe.description),
],
),
),
);
}
}