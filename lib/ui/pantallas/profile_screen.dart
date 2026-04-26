import 'package:flutter/material.dart';
import '../../datos/modelos/post.dart';
import '../widgets/profile_header.dart';
import '../widgets/user_posts_grid.dart';
import '../widgets/user_filtered_feed.dart';

class ProfileScreen extends StatelessWidget {
  final String userId;
  final String username;
  final String bio;
  final String profileImageUrl;
  final int postsCount;
  final int followers;
  final int following;
  final List<Post> allPosts;

  const ProfileScreen({
    super.key,
    required this.userId,
    required this.username,
    required this.bio,
    required this.profileImageUrl,
    required this.postsCount,
    required this.followers,
    required this.following,
    required this.allPosts,
  });

  @override
  Widget build(BuildContext context) {
    // Filtrar posts de l’usuari
    final userPosts = allPosts.where((p) => p.ownerId == userId).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('@$username'),
        actions: [
          Semantics(
            label: 'Editar perfil',
            button: true,
            hint: 'Doble toc per editar el perfil',
            child: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                // TODO: Navegar a pantalla d’edició de perfil
              },
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Capçalera accessible
            ProfileHeader(
              username: username,
              bio: bio,
              profileImageUrl: profileImageUrl,
              posts: postsCount,
              followers: followers,
              following: following,
            ),

            const SizedBox(height: 24),

            // Títol de secció
            Semantics(
              label: 'Publicacions de @$username',
              child: const Text(
                'Publicacions',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Grid de posts accessible
            UserPostsGrid(posts: userPosts),

            const SizedBox(height: 24),

            // Feed filtrat (opcional)
            Semantics(
              label: 'Feed filtrat de @$username',
              child: const Text(
                'Feed filtrat',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 12),

            UserFilteredFeed(
              userId: userId,
              allPosts: allPosts,
            ),
          ],
        ),
      ),
    );
  }
}
