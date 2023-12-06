import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:tempapp/save_and_share_page.dart';
import 'dart:collection';
import 'dart:math';
import 'pixelAughhh.dart';

class Point {
  int x, y;
  Point(this.x, this.y);
}

// ignore: must_be_immutable
class MainPage extends StatefulWidget {
  // do not Use this no matter what //
  //           just dont            //
  //     massive logical error      //
  Uint8List? pickedImageBytes;

  // !!!!!!!!!!!!!!hazard warning !!!!!!!!!!!!!!!!!//
  //                                               //
  // do not use pickedImageBytes !!!!!!!!!!!!!!!!!!//
  List<Uint8List> imageStack;

  // Initialize imageStack in the constructor
  MainPage({Key? key, this.pickedImageBytes})
      : imageStack = [if (pickedImageBytes != null) pickedImageBytes],
        super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Color colorToChange = const Color.fromARGB(255, 253, 253, 253);
  Color newColor = const Color.fromARGB(255, 253, 253, 253);
  bool allowPickColor = false;
  int positionX = 0;
  int positionY = 0;
  int? origionalImageWidth;
  int? origionalImageHeight;
  img.Image? _decodedAhhImage;

  GlobalKey<PixelColorPickerState> pixelColorPickerKey = GlobalKey();
  late Offset pickedCoordinates;
  int toleranceDiff = 30;

  void _navigateBack() {
    Navigator.pop(context);
  }

  void _navigateToSaveandShare(List<int> imageBytes) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            SaveSharePage(pickedImageBytes: Uint8List.fromList(imageBytes)),
      ),
    );
  }

  double euclideanDistance(int r1, int g1, int b1, int r2, int g2, int b2) {
    return sqrt(pow(r2 - r1, 2) + pow(g2 - g1, 2) + pow(b2 - b1, 2));
  }

  void changeColor(
      int X, int Y, int targetColor, int replacementColor, int diff) {
    int size = widget.imageStack.length;
    img.Image? decodedImage = img.decodeImage(widget.imageStack[size - 1]);
    int width = decodedImage!.width;
    int height = decodedImage.height;

    Queue<Point> stack = Queue();
    stack.add(Point(X, Y));

    while (stack.isNotEmpty) {
      Point current = stack.removeLast();

      int x = current.x;
      int y = current.y;

      if (x < 0 || x >= width || y < 0 || y >= height) {
        continue;
      }

      int currentColor = decodedImage.getPixel(x, y);
      if (euclideanDistance(
              img.getRed(currentColor),
              img.getGreen(currentColor),
              img.getBlue(currentColor),
              img.getRed(targetColor),
              img.getGreen(targetColor),
              img.getBlue(targetColor)) >=
          diff) {
        continue; // Skip if the color difference is greater than the threshold
      }

      decodedImage.setPixel(
          x,
          y,
          img.getColor(img.getRed(replacementColor),
              img.getGreen(replacementColor), img.getBlue(replacementColor)));

      // Add neighboring pixels to the stack for further processing
      stack.add(Point(x + 1, y));
      stack.add(Point(x - 1, y));
      stack.add(Point(x, y + 1));
      stack.add(Point(x, y - 1));
    }

    widget.imageStack.add(Uint8List.fromList(img.encodePng(decodedImage)));
    if (widget.imageStack.length > 5) {
      widget.imageStack.removeAt(0); // Remove the oldest image
    }

    setState(() {
      colorToChange = newColor;
    });
  }

  void _setColor(Color color) {
    setState(() {
      newColor = color;
    });
    pixelColorPickerKey = GlobalKey();
    changeColor(
        positionX,
        positionY,
        img.getColor(
            colorToChange.red, colorToChange.green, colorToChange.blue),
        img.getColor(newColor.red, newColor.green, newColor.blue),
        toleranceDiff);
    Navigator.of(context).pop(); // Close the color picker
  }

  void _showColorPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select a Color'),
          content: SizedBox(
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ColorSquare(Colors.red, onTap: () => _setColor(Colors.red)),
                ColorSquare(Colors.blue, onTap: () => _setColor(Colors.blue)),
                ColorSquare(Colors.green, onTap: () => _setColor(Colors.green)),
                ColorSquare(Colors.yellow,
                    onTap: () => _setColor(Colors.yellow)),
              ],
            ),
          ),
        );
      },
    );
  }

  void decodeImageIfNeeded() {
    // Check if the image has already been decoded
    if (_decodedAhhImage == null) {
      _decodedAhhImage = img.decodeImage(widget.imageStack.last);

      // Retrieve image dimensions
      origionalImageWidth = _decodedAhhImage!.width;
      origionalImageHeight = _decodedAhhImage!.height;
    }
  }

  @override
  Widget build(BuildContext context) {
    decodeImageIfNeeded();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color.fromARGB(255, 65, 60, 60),
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          toolbarHeight: 80,
          backgroundColor: const Color.fromRGBO(116, 168, 88, 1),
          leading: SizedBox(
            width: 56.0,
            height: 56.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    _navigateBack();
                  },
                  color: const Color.fromARGB(255, 0, 0, 0),
                ),
                const Text(
                  'go back',
                  style: TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            SizedBox(
              width: 56.0,
              height: 56.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.check),
                    onPressed: () {
                      _navigateToSaveandShare(
                        widget.imageStack[widget.imageStack.length - 1],
                      );
                    },
                    color: const Color.fromARGB(255, 0, 0, 0),
                  ),
                  const Text(
                    'confirm',
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                    // Add any text properties or styling here
                  ),
                ],
              ),
            ),
          ],
        ),
        body: Center(
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 2),
            ),
            child: Center(
              child: PixelColorPicker(
                key: pixelColorPickerKey,
                onChanged: (Color color, Offset offset) {
                  if (allowPickColor) {
                    double scaleX = origionalImageWidth! / 300;
                    double scaleY = origionalImageHeight! / 300;
                    setState(() {
                      colorToChange = color;
                      pickedCoordinates = offset;
                      if (origionalImageWidth! < origionalImageHeight!) {
                        positionX = (pickedCoordinates.dx * scaleY).toInt();
                        positionY = (pickedCoordinates.dy * scaleY).toInt();
                      } else {
                        positionX = (pickedCoordinates.dx * scaleX).toInt();
                        positionY = (pickedCoordinates.dy * scaleX).toInt();
                      }
                    });
                  } else {
                    setState(() {});
                  }
                },
                child: Image.memory(
                  widget.imageStack[widget.imageStack.length - 1],
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: Container(
          color: const Color.fromRGBO(116, 168, 88, 1),
          width: double.infinity,
          height: 200,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 40,
                  child: Slider(
                    value: toleranceDiff.toDouble(),
                    min: 10.0,
                    max: 100.0,
                    divisions: 9,
                    inactiveColor: const Color.fromARGB(175, 55, 51, 51),
                    activeColor: const Color.fromARGB(239, 255, 255, 255),
                    label: toleranceDiff.toString(),
                    onChanged: (value) {
                      setState(() {
                        toleranceDiff = value.toInt();
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: 80,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        width: 80,
                        child: TextField(
                          readOnly: true,
                          controller: TextEditingController(
                              text: colorToChange.red.toString()),
                          decoration: const InputDecoration(labelText: 'R:'),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      SizedBox(
                        width: 80,
                        child: TextField(
                          readOnly: true,
                          controller: TextEditingController(
                              text: colorToChange.green.toString()),
                          decoration: const InputDecoration(labelText: 'G:'),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      SizedBox(
                        width: 80,
                        child: TextField(
                          readOnly: true,
                          controller: TextEditingController(
                              text: colorToChange.blue.toString()),
                          decoration: const InputDecoration(labelText: 'B:'),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: colorToChange,
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromARGB(166, 0, 0, 0),
                              blurRadius: 5.0,
                              offset: Offset(0, 0),
                              spreadRadius: 2.5,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 80,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        height: 80,
                        width: 80,
                        child: Column(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.colorize),
                              onPressed: () {
                                setState(() {
                                  allowPickColor = true;
                                });
                              },
                              color: const Color.fromRGBO(0, 0, 0, 1),
                            ),
                            const Text(
                              'pick color',
                              // Add any text properties or styling here
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 80,
                        width: 80,
                        child: Column(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.undo),
                              onPressed: () {
                                allowPickColor = false;
                                if (widget.imageStack.length > 1) {
                                  widget.imageStack.removeLast();
                                }
                                setState(() {});
                              },
                              color: const Color.fromARGB(255, 0, 0, 0),
                            ),
                            const Text(
                              'undo',
                              // Add any text properties or styling here
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 80,
                        width: 80,
                        child: Column(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.format_color_fill),
                              onPressed: () {
                                allowPickColor = false;
                                _showColorPicker(context);
                                //call to new color
                              },
                              color: const Color.fromARGB(255, 0, 0, 0),
                            ),
                            const Text(
                              'select color',
                              // Add any text properties or styling here
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ColorSquare extends StatelessWidget {
  final Color color;
  final VoidCallback onTap;

  const ColorSquare(this.color, {super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        width: 50,
        height: 50,
        color: color,
        margin: const EdgeInsets.all(8),
      ),
    );
  }
}
