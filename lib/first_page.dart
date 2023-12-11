import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'main_page.dart';
import 'help_page.dart'; // Import the HelpPage file

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

      List<int> imageBytes = await originalImage.readAsBytes();

      _navigateToMainPage(imageBytes);
    }
  }

  void _navigateToMainPage(List<int> imageBytes) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            MainPage(pickedImageBytes: Uint8List.fromList(imageBytes)),
      ),
    );
  }

  void _navigateToHelpPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HelpPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 167, 145, 222),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Color Shift',
                    style: TextStyle(
                      fontFamily: 'Times New Roman', // Example font family
                      fontWeight: FontWeight.bold,

                      //fontWeight: FontWeight.w900,
                      fontSize: 25,
                      color: Color.fromRGBO(0, 0, 0, 1),
                    ),
                    textAlign: TextAlign.left,
                  ),
                  IconButton(
                    icon: const Icon(Icons.help),
                    onPressed: _navigateToHelpPage,
                    color: const Color.fromARGB(
                        255, 0, 0, 0), // Change the icon color here
                  ),
                ],
              ),
            ),
          ),
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
                    fontFamily: 'Times New Roman', // Example font family
                    fontWeight: FontWeight.w300,
                    color: Colors.black,
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
          ),
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
                    size: 45,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
