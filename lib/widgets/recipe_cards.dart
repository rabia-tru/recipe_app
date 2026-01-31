import 'package:flutter/material.dart';
import '../models/recipe_model.dart';


class RecipeCard extends StatelessWidget {
final Recipe recipe;
const RecipeCard({super.key, required this.recipe});


@override
Widget build(BuildContext context) {
return Card(
margin: const EdgeInsets.symmetric(vertical: 8),
child: ListTile(
leading: recipe.imageUrl.isNotEmpty ? Image.network(recipe.imageUrl, width: 60, height: 60, fit: BoxFit.cover) : Container(width: 60, height: 60, color: Colors.grey[200], child: const Icon(Icons.restaurant_menu)),
title: Text(recipe.title),
subtitle: Text(recipe.category),
trailing: const Icon(Icons.chevron_right),
),
);
}
}