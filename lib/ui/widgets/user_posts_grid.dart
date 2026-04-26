import 'package:flutter/material.dart';
import '../../datos/modelos/post.dart';



class UserPostsGrid extends StatelessWidget {
  final List<Post> posts;

  const UserPostsGrid({
    super.key,
    required this.posts,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: posts.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 2,
        crossAxisSpacing: 2,
      ),
      itemBuilder: (context, index) {
        final post = posts[index];
        final position = index + 1;
        final total = posts.length;

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
              child: Image.network(
                post.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      },
    );
  }
}
