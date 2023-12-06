import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'main_page.dart';

class UploadImagePage extends StatefulWidget {
  const UploadImagePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _UploadImagePageState createState() => _UploadImagePageState();
}

class _UploadImagePageState extends State<UploadImagePage> {
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      final File originalImage = File(pickedImage.path);

      // Read the bytes of the original image
      List<int> imageBytes = await originalImage.readAsBytes();

      // After setting the image, call a callback function to handle navigation
      _navigateToMainPage(imageBytes);
    }
  }

  // Callback function to navigate to the MainPage
  void _navigateToMainPage(List<int> imageBytes) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            MainPage(pickedImageBytes: Uint8List.fromList(imageBytes)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 65, 60, 60),
      body: Stack(
        alignment: Alignment.center,
        children: [
          // Container for the first text with padding at the top
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              padding: const EdgeInsets.only(top: 40.0),
              child: const Text(
                'Background Color Changer',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 25,
                  color: Color.fromRGBO(22, 110, 154, 1),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          // Container for the IconButton and text
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.upload_file),
                  onPressed: _pickImage,
                  iconSize: 100.0,
                  color: Colors.black,
                ),
                const SizedBox(height: 8.0),
                const Text(
                  'Upload an image',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
          ),
          // Container for the last text and Flutter icon with padding at the bottom
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'This app is powered by ',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  FlutterLogo(
                    size: 60,
                  ), // Replace with your desired Flutter icon
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
