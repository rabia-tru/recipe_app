import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth/login_screen.dart';
import 'add_recipe_screen.dart';
import '../models/recipe_model.dart';
import '../widgets/recipe_card.dart';
import 'recipe_detail_screen.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();
  String _search = '';

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final themeProvider = Provider.of<ThemeProvider>(context);

    // Base query: only recipes created by this user
    Query recipesQuery = FirebaseFirestore.instance
        .collection('recipes')
        .where('userId', isEqualTo: uid)
        .orderBy('createdAt', descending: true);

    // Apply search filter if text is not empty
    if (_search.isNotEmpty) {
      recipesQuery = recipesQuery
          .where('title', isGreaterThanOrEqualTo: _search)
          .where('title', isLessThanOrEqualTo: '$_search\uf8ff');
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipes'),
        actions: [
          // Theme toggle
          IconButton(
            icon: Icon(themeProvider.isDark
                ? Icons.wb_sunny
                : Icons.nightlight_round),
            onPressed: () => themeProvider.toggle(),
          ),
          // Logout with confirmation
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Logout'),
                  content: const Text('Are you sure you want to logout?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Logout'),
                    ),
                  ],
                ),
              );
              if (confirm ?? false) {
                await FirebaseAuth.instance.signOut();
                if (!mounted) return;
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              }
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddRecipeScreen()),
        ),
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search box
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Search recipes by title',
                  border: OutlineInputBorder(),
                ),
                onChanged: (val) => setState(() => _search = val.trim()),
              ),
            ),
            const SizedBox(height: 10),
            // Recipe list
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: recipesQuery.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No recipes yet'));
                  }

                  final recipes = snapshot.data!.docs
                      .map((d) => Recipe.fromMap(
                          d.data() as Map<String, dynamic>, d.id))
                      .toList();

                  return ListView.builder(
                    itemCount: recipes.length,
                    itemBuilder: (context, index) {
                      final item = recipes[index];
                      return GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  RecipeDetailScreen(recipe: item)),
                        ),
                        child: RecipeCard(recipe: item),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
