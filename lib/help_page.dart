import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  HelpPage({Key? key}) : super(key: key);

  final List<String> screenshots = [
    'cute.jpg',
    'bad.jpg',
    'cute.jpg',
    // Add more screenshots as needed
  ];

  final List<String> stepDescriptions = [
    'Step 1: Open the app',
    'Step 2: Choose a photo',
    'Step 3: Select the background color',
    // Add more step descriptions corresponding to your screenshots
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Help'),
      ),
      body: ListView.builder(
        itemCount: screenshots.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/${screenshots[index]}', // Assuming images are in the assets folder
                  height: 200, // Adjust the height as needed
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 10),
                Text(
                  stepDescriptions[index],
                  style: const TextStyle(fontSize: 16),
                ),
                const Divider(), // Optional: Add a divider between steps
              ],
            ),
          );
        },
      ),
    );
  }
}
