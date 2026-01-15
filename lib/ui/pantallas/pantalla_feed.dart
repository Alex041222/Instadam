import 'package:flutter/material.dart';

class PantallaFeed extends StatelessWidget {
  const PantallaFeed({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Feed"),
      ),
      body: const Center(
        child: Text(
          "Aquí irá el feed de publicaciones",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
