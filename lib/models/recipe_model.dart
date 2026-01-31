class Recipe {
final String id;
final String title;
final String description;
final String imageUrl;
final String category;
final String userId;
final DateTime createdAt;


Recipe({
required this.id,
required this.title,
required this.description,
required this.imageUrl,
required this.category,
required this.userId,
required this.createdAt,
});


Map<String, dynamic> toMap() {
return {
'title': title,
'description': description,
'imageUrl': imageUrl,
'category': category,
'userId': userId,
'createdAt': createdAt.toIso8601String(),
};
}


factory Recipe.fromMap(Map<String, dynamic> map, String id) {
return Recipe(
id: id,
title: map['title'] ?? '',
description: map['description'] ?? '',
imageUrl: map['imageUrl'] ?? '',
category: map['category'] ?? '',
userId: map['userId'] ?? '',
createdAt: DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now(),
);
}
}