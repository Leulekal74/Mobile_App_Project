<<<<<<< HEAD
=======
import 'package:flutter/material.dart';
import 'presentation/pages/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}
>>>>>>> c78ff3df42e8105c2d5ce1c9d43415d0f0ee79b6
