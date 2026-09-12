import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class OCRService {
  // Patterns that definitively indicate console/logcat contamination —
  // none of these can appear on a physical product label.
  static final List<RegExp> _contaminationPatterns = [
    RegExp(r'^[VDIWEF]/\w+[\(\d]+', multiLine: true),   // Android logcat: "W/qdgralloc(21141)"
    RegExp(r'getInterlacedFlag|getMetaData|qdgralloc|gralloc', caseSensitive: false),
    RegExp(r'Parags-MacBook|MacBook-Air', caseSensitive: false),
    RegExp(r'flutter run|flutter:|Dart VM|Hot reload|Hot restart', caseSensitive: false),
    RegExp(r'\bflutter\s+\w+\s+\d+ms\b', caseSensitive: false), // "flutter build 1234ms"
    RegExp(r'Observatory listening|Debug service|DevTools', caseSensitive: false),
    RegExp(r'I/flutter\s*\(', caseSensitive: false),    // "I/flutter (1234):"
  ];

  /// Returns the raw OCR text from the image, or null if OCR fails or
  /// the result appears to be console/debug contamination rather than label text.
  static Future<String?> extractTextFromImage(String imagePath) async {
    try {
      // 1. Pre-process the image
      final processedImagePath = await _preprocessImage(imagePath);

      // 2. Initialize TextRecognizer
      final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

      // 3. Process image — this is the ONLY source of rawOcrText
      final inputImage = InputImage.fromFilePath(processedImagePath);
      final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);

      // 4. Clean up
      textRecognizer.close();

      final text = recognizedText.text;

      debugPrint('[OCR] Extracted ${text.length} chars. First 200: ${text.substring(0, text.length.clamp(0, 200))}');

      // 5. Sanity check — reject if contaminated with console/logcat output
      for (final pattern in _contaminationPatterns) {
        if (pattern.hasMatch(text)) {
          debugPrint('[OCR] CONTAMINATION DETECTED — pattern "${pattern.pattern}" matched. '
              'The image appears to be a screenshot of terminal/logcat output, '
              'not a real product label. Treating OCR as failed.');
          return null;  // Treat as failed scan — upstream will show "Not detected" for all fields
        }
      }

      return text.isEmpty ? null : text;
    } catch (e) {
      debugPrint('[OCR] Error in OCRService: $e');
      return null;
    }
  }

  static Future<String> _preprocessImage(String imagePath) async {
    // Read the original image
    final bytes = await File(imagePath).readAsBytes();
    img.Image? originalImage = img.decodeImage(bytes);

    if (originalImage == null) {
      throw Exception('Failed to decode image at path: $imagePath');
    }

    // Convert to grayscale to improve OCR accuracy
    img.Image processedImage = img.grayscale(originalImage);

    // Boost contrast
    processedImage = img.adjustColor(processedImage, contrast: 1.5);

    // Save to temp file
    final tempDir = await getTemporaryDirectory();
    final tempPath = '${tempDir.path}/processed_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final tempFile = File(tempPath);
    await tempFile.writeAsBytes(img.encodeJpg(processedImage, quality: 85));

    return tempPath;
  }
}
