import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final String username;
  final String bio;
  final String profileImageUrl;
  final int posts;
  final int followers;
  final int following;

  const ProfileHeader({
    super.key,
    required this.username,
    required this.bio,
    required this.profileImageUrl,
    required this.posts,
    required this.followers,
    required this.following,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Semantics(
              label: 'Foto de perfil de @$username',
              image: true,
              child: ExcludeSemantics(
                child: CircleAvatar(
                  radius: 32,
                  backgroundImage: NetworkImage(profileImageUrl),
                ),
              ),
            ),
            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Semantics(
                    label: '@$username',
                    child: Text(
                      '@$username',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Semantics(
                    label: 'Biografia: $bio',
                    child: Text(
                      bio,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        MergeSemantics(
          child: Semantics(
            label:
            '$posts publicacions, $followers seguidors, $following seguint',
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatItem(label: 'Publicacions', value: posts),
                _StatItem(label: 'Seguidors', value: followers),
                _StatItem(label: 'Seguint', value: following),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        Semantics(
          button: true,
          label: 'Editar perfil',
          hint: 'Doble toc per editar el perfil',
          child: SizedBox(
            height: 48,
            child: OutlinedButton(
              onPressed: () {
                // TODO: acció d’editar perfil
              },
              child: const Text('Editar perfil'),
            ),
          ),
        ),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final int value;

  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ExcludeSemantics(
          child: Text(
            value.toString(),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        ExcludeSemantics(
          child: Text(label),
        ),
      ],
    );
  }
}
