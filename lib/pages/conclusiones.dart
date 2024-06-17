import 'package:flutter/material.dart';

class ConclusionesPage extends StatelessWidget {
  const ConclusionesPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Conclusiones'),
        backgroundColor: const Color(0xffad1c1c),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text(
              'Mi proyecto esta hecho con lo que aprendi en todo este semestre,ya sea cosas de interfaz y bases de datos.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
