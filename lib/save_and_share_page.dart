import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:share/share.dart';
import 'package:path_provider/path_provider.dart';

class SaveSharePage extends StatelessWidget {
  const SaveSharePage({Key? key, this.pickedImageBytes}) : super(key: key);

  final Uint8List? pickedImageBytes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 167, 145, 222),
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
                onPressed: () async {
                  await _saveImageToGallery(context, pickedImageBytes);
                },
                child: const Text('Save Image'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  await _shareImage(context, pickedImageBytes);
                },
                child: const Text('Share Image'),
              ),
              const SizedBox(height: 16),
              const Text('Thank you for using our app'),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveImageToGallery(
      BuildContext context, Uint8List? imageBytes) async {
    if (imageBytes != null) {
      try {
        // ignore: unused_local_variable
        final result =
            await ImageGallerySaver.saveImage(Uint8List.fromList(imageBytes));
        // ignore: use_build_context_synchronously
        _showSnackBar(context, 'Image saved successfully', Colors.green);
      } on PlatformException catch (error) {
        // ignore: use_build_context_synchronously
        _showSnackBar(context, 'Image saving failed: $error', Colors.red);
      }
    }
  }

  Future<void> _shareImage(BuildContext context, Uint8List? imageBytes) async {
    if (imageBytes != null) {
      try {
        // Save the image locally
        final directory = await getTemporaryDirectory();
        final file = File('${directory.path}/image.png');
        await file.writeAsBytes(imageBytes);

        // Share the file path
        Share.shareFiles([file.path],
            text: 'Check out this image saved with our app!');
        // ignore: unused_catch_clause
      } on PlatformException catch (error) {
        // Handle the error as needed
      }
    }
  }

  void _showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
      ),
    );
  }
}
