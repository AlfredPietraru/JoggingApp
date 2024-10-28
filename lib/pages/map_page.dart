import 'package:flutter/material.dart';
import 'package:jogging/constants.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});
  static Route<void> page() =>
      MaterialPageRoute<void>(builder: (_) => const MapPage());

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 30),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Back", style: TextStyle(fontSize: 30)),
          ),
          const SizedBox(height: 20),
          Text(
            'A creat userul cu succes',
            style: AppTextStyle.body,
          ),
        ],
      ),
    );
  }
}
