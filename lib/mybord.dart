import 'package:flutter/material.dart';

class MyBird extends StatelessWidget {
  const MyBird({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: 60, height: 60, child: Image.asset('assets/images/bird.png'));
  }
}
