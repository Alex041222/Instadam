import 'package:flutter/material.dart';
import '../../datos/modelos/post.dart';
import 'post_visual_card.dart';

class UserFilteredFeed extends StatelessWidget {
  final String userId;
  final List<Post> allPosts;

  const UserFilteredFeed({
    super.key,
    required this.userId,
    required this.allPosts,
  });

  @override
  Widget build(BuildContext context) {
    // Filtrar només els posts de l’usuari
    final userPosts = allPosts.where((p) => p.ownerId == userId).toList();

    return ListView.builder(
      itemCount: userPosts.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final post = userPosts[index];
        final position = index + 1;
        final total = userPosts.length;

        final description =
        (post.description?.isNotEmpty ?? false)
            ? post.description!
            : 'Sense descripció';

        final semanticsLabel =
            'Publicació $position de $total. '
            'Descripció: $description. '
            '${post.likes} likes. '
            'Doble toc per obrir.';

        return Semantics(
          label: semanticsLabel,
          button: true,
          onTapHint: 'Obrir publicació',
          child: GestureDetector(
            onTap: () {
              // TODO: obrir detall de la publicació
            },
            child: ExcludeSemantics(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: PostVisualCard(post: post),
              ),
            ),
          ),
        );
      },
    );
  }
}
