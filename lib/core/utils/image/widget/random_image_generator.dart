import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class RandomImageGenerator {
  static Future<Uint8List> createImageFromCanvas(int width, int height) async {
    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(
        recorder,
        Rect.fromPoints(
            Offset(0, 0), Offset(width.toDouble(), height.toDouble())));

    final Random random = Random();
    final Color color = Color.fromRGBO(
        random.nextInt(256), random.nextInt(256), random.nextInt(256), 1);
    final List<String> alphabets = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('');

    // Drawing code for a single colored section with text
    final paint = Paint()..color = color;
    canvas.drawRect(
        Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), paint);

    // Adding text
    String letter = alphabets[random.nextInt(alphabets.length)];
    final textStyle = TextStyle(
      color: _getContrastingColor(
          color), // Ensure text is visible against the background
      fontSize: 96, // Increased font size for better visibility
    );
    final textSpan = TextSpan(style: textStyle, text: letter);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    final textX = (width - textPainter.width) / 2;
    final textY = (height - textPainter.height) / 2;
    textPainter.paint(canvas, Offset(textX, textY));

    // Finish recording and convert to image
    final picture = recorder.endRecording();
    final ui.Image img = await picture.toImage(width, height);
    final ByteData? byteData =
        await img.toByteData(format: ui.ImageByteFormat.png);

    if (byteData == null) {
      throw Exception("Failed to convert image to byte data");
    }

    return byteData.buffer.asUint8List();
  }

  static Color _getContrastingColor(Color background) {
    // Calculate luminance to choose between black/white text for better contrast
    double luminance = (0.299 * background.red +
            0.587 * background.green +
            0.114 * background.blue) /
        255;
    return luminance > 0.5 ? Colors.black : Colors.white;
  }
}
