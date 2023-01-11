import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class Notifications extends StatelessWidget {
  const Notifications({Key? key, required this.info}) : super(key: key);

  final String info;
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New notification"),
      ),
      body: Center(child: Text(info)),
    );
  }
}
