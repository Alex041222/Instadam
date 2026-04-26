import 'package:flutter/material.dart';
import '../../datos/modelos/post.dart';

class PostVisualCard extends StatelessWidget {
  final Post post;

  const PostVisualCard({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Imatge del post (decorativa → ExcludeSemantics)
        ExcludeSemantics(
          child: Image.network(
            post.imageUrl,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),

        const SizedBox(height: 8),

        // Likes (decoratiu, no cal Semantics)
        ExcludeSemantics(
          child: Row(
            children: [
              const Icon(Icons.favorite, size: 18, color: Colors.red),
              const SizedBox(width: 4),
              Text('${post.likes} likes'),
            ],
          ),
        ),

        const SizedBox(height: 4),

        // Descripció (decorativa, ja anunciada al grid)
        if (post.description != null && post.description!.isNotEmpty)
          ExcludeSemantics(
            child: Text(
              post.description!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
      ],
    );
  }
}
