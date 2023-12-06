import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/rendering.dart';
import 'package:image/image.dart' as img;

class ColorPicker {
  final Uint8List? bytes;

  img.Image? _decodedImage;

  ColorPicker({this.bytes});

  Future<Color> getColor({required Offset pixelPosition}) async {
    _decodedImage ??= img.decodeImage(bytes!);

    final abgrPixel = _decodedImage!.getPixelSafe(
      pixelPosition.dx.toInt(),
      pixelPosition.dy.toInt(),
    );

    final rgba = abgrToRgba(abgrPixel);

    final color = Color(rgba);

    return color;
  }

  int abgrToRgba(int argb) {
    int r = (argb >> 16) & 0xFF;
    int b = argb & 0xFF;

    final rgba = (argb & 0xFF00FF00) | (b << 16) | r;

    return rgba;
  }
}
