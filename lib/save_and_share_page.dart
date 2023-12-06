import 'dart:typed_data';
import 'package:flutter/material.dart';

class SaveSharePage extends StatelessWidget {
  const SaveSharePage({Key? key, this.pickedImageBytes}) : super(key: key);

  // Takes a Uint8List parameter in the constructor
  final Uint8List? pickedImageBytes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  // Save image to Android gallery
                  //_saveImageToGallery(pickedImageBytes);
                },
                child: const Text('Save'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Open share option for WhatsApp
                  _shareImageOnWhatsApp(pickedImageBytes);
                },
                child: const Text('Share'),
              ),
              const SizedBox(height: 16),
              const Text('Thank you for using our app'),
            ],
          ),
        ),
      ),
    );
  }

  void _shareImageOnWhatsApp(Uint8List? imageBytes) {
    // Implement share image on WhatsApp functionality
    // Example: ShareUtil.shareOnWhatsApp(imageBytes);
  }
}
