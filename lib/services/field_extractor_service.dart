import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import '../models/extracted_field.dart';

class FieldExtractorService {
  static int _groqCallsThisSession = 0;
  static const int _maxGroqCalls = 20;

  static Future<List<ExtractedField>> extractFields(String scanId, String text) async {
    final fields = <String, ExtractedField>{};
    
    // Helper function to wrap patterns with letter-boundaries (avoids \b issues with symbols)
    String b(String pattern) => r'(?<![a-zA-Z])' + pattern + r'(?![a-zA-Z])';

    final extractFields = <String, String>{
      'MRP': b(r'(?:MRP|M\.R\.P|Rs\.?|₹)'),
      'Net Quantity': b(r'(?:Net\s*(?:Wt\.?|Weight|Qty\.?|Vol\.?|Quantity)|Quantity|Weight)'),
      'Mfg Date': b(r'(?:MFD|Mfg\.?\s*(?:Date|Dt\.?)|Pkd\.?\s*(?:On|Dt\.?)|Packed\s*On|Date\s*of\s*Mfg|Date\s*of\s*Pkg)'),
      'Expiry': b(r'(?:Best\s*Before|Use\s*By|Expiry|Exp\.?)'), 
      'Manufacturer': b(r'(?:Mfd\.?\s*By|Manufactured\s*By|Marketed\s*By|Packed\s*By)'),
      'Consumer Care': b(r'(?:Customer\s*Care|Consumer\s*Care|For\s*Complaints?|Feedback)'),
      'FSSAI': b(r'(?:fssai|Lic\.?\s*No\.?)'),
      'Country of Origin': b(r'(?:Country\s*of\s*Origin|Made\s*in)'),
    };

    final boundaryFields = <String, String>{
      'Batch No': b(r'(?:Batch\s*No\.?)'),
      'Nutritional Information': b(r'(?:Nutritional\s*Information|Nutrition\s*Facts|TUTRTIONAL)'),
      'Ingredients': b(r'(?:Ingredients?)'),
      'Energy': b(r'(?:Energy)'),
    };

    final allKeywordPatterns = <String, String>{
      ...extractFields,
      ...boundaryFields,
    };

    // Find all matches
    final matches = <_FieldMatch>[];
    allKeywordPatterns.forEach((fieldName, pattern) {
      final reg = RegExp(pattern, caseSensitive: false);
      final allMatches = reg.allMatches(text);
      for (final match in allMatches) {
        matches.add(_FieldMatch(fieldName, match.start, match.end, match.group(0)!));
      }
    });

    // Sort matches by start position
    matches.sort((a, b) => a.start.compareTo(b.start));

    // Remove overlapping matches (keep the first one)
    final filteredMatches = <_FieldMatch>[];
    for (final match in matches) {
      if (filteredMatches.isEmpty || match.start >= filteredMatches.last.end) {
        filteredMatches.add(match);
      }
    }

    // Secondary stop regex — truncates any field value at the first appearance of a
    // known label keyword, regardless of the positional boundary. This prevents
    // fields like Expiry from consuming "Manufacturer: XYZ Foods" when the next
    // boundary keyword wasn't matched by the primary positional scan.
    final _keywordStopPattern = RegExp(
      r'(?:MRP|M\.R\.P|Rs\.?|₹|Net\s*(?:Wt\.?|Weight|Qty\.?|Vol\.?|Quantity)|Quantity|Weight'
      r'|MFD|Mfg\.?\s*(?:Date|Dt\.?)|Pkd\.?\s*(?:On|Dt\.?)|Packed\s*On|Date\s*of\s*Mfg'
      r'|Date\s*of\s*Pkg|Best\s*Before|Use\s*By|Expiry|Exp\.?'
      r'|Mfd\.?\s*By|Manufactured\s*By|Marketed\s*By|Packed\s*By'
      r'|Customer\s*Care|Consumer\s*Care|For\s*Complaints?|Feedback'
      r'|fssai|Lic\.?\s*No\.?|Country\s*of\s*Origin|Made\s*in'
      r'|Batch\s*No\.?|Nutritional\s*Information|Nutrition\s*Facts|Ingredients?|Energy)',
      caseSensitive: false,
    );

    // Now extract values between current match and next match
    for (int i = 0; i < filteredMatches.length; i++) {
      final current = filteredMatches[i];
      // Skip if it's a boundary-only keyword, as they don't need extraction
      if (boundaryFields.containsKey(current.fieldName)) continue;

      final next = (i + 1 < filteredMatches.length) ? filteredMatches[i + 1] : null;

      final startIndex = current.end;
      final endIndex = next?.start ?? text.length;

      String rawValue = text.substring(startIndex, endIndex);

      // Clean up leading colons, hyphens, and whitespace
      rawValue = rawValue.replaceFirst(RegExp(r'^[\s:\-]+'), '').trim();

      // --- FIELD BOUNDARY SAFETY NET ---
      // After extracting the raw slice, truncate at the first occurrence of ANY
      // label keyword. This catches cases where the positional boundary didn't
      // fire (e.g. keyword variant not in regex) and prevents field bleeding.
      final stopMatch = _keywordStopPattern.firstMatch(rawValue);
      if (stopMatch != null && stopMatch.start > 0) {
        rawValue = rawValue.substring(0, stopMatch.start).trim();
        debugPrint('[FieldExtractor] Truncated ${current.fieldName} at keyword "${stopMatch.group(0)}" (pos ${stopMatch.start})');
      }

      if (rawValue.isNotEmpty && !fields.containsKey(current.fieldName)) {
        double conf = 0.85;

        // Cap length based on field type
        int maxLength = 250;
        if (['MRP', 'Net Quantity', 'Mfg Date', 'Expiry', 'FSSAI'].contains(current.fieldName)) {
          maxLength = 50;  // slightly more generous than 40 to allow e.g. "01/2026 (Best Before)"
        } else if (current.fieldName == 'Manufacturer' || current.fieldName == 'Consumer Care') {
          maxLength = 150;
        }

        if (rawValue.length > maxLength) {
          rawValue = rawValue.substring(0, maxLength).trim();
          conf -= 0.3; // Penalty for exceeding length bounds
        }

        if (current.fieldName == 'Manufacturer') {
          rawValue = rawValue.replaceAll(RegExp(r'\b\d{14}\b'), '').trim();
        } else if (current.fieldName == 'FSSAI') {
          final fssaiMatch = RegExp(r'\b\d{14}\b').firstMatch(rawValue);
          if (fssaiMatch != null) {
            rawValue = fssaiMatch.group(0)!;
            conf = 0.95;
          } else {
            rawValue = '';
          }
        } else if (current.fieldName == 'MRP') {
          final lower = rawValue.toLowerCase();
          if (lower.contains('incl') || lower.contains('tax') || lower.contains('all') || lower.contains('cf')) {
            conf = 0.95;
          } else {
            conf = 0.70;
          }
        }

        debugPrint('[FieldExtractor] ${current.fieldName}: "$rawValue" (conf=${conf.toStringAsFixed(2)})');

        if (rawValue.isNotEmpty) {
          fields[current.fieldName] = ExtractedField(
            id: const Uuid().v4(),
            scanId: scanId,
            fieldName: current.fieldName,
            fieldValue: rawValue,
            confidence: conf.clamp(0.0, 1.0),
            isDetected: true,
            createdAt: DateTime.now(),
          );
        }
      }
    }

    final mandatoryKeys = ['MRP', 'Net Quantity', 'Mfg Date', 'Expiry', 'Manufacturer', 'Consumer Care'];
    final missingOrLowConf = mandatoryKeys.where((key) {
      final f = fields[key];
      return f == null || !f.isDetected || f.confidence < 0.6;
    }).toList();

    if (missingOrLowConf.isNotEmpty && _groqCallsThisSession < _maxGroqCalls) {
      _groqCallsThisSession++;
      debugPrint('Calling Groq fallback for: $missingOrLowConf (Call $_groqCallsThisSession/$_maxGroqCalls)');
      try {
        final fallbackData = await _callGroqFallback(text, missingOrLowConf);
        
        for (final key in missingOrLowConf) {
          if (fallbackData.containsKey(key) && fallbackData[key] != null) {
            final val = fallbackData[key].toString().trim();
            if (val.isNotEmpty && val.toLowerCase() != 'null' && val.toLowerCase() != 'not detected') {
              fields[key] = ExtractedField(
                id: const Uuid().v4(),
                scanId: scanId,
                fieldName: key,
                fieldValue: val,
                confidence: 0.85, 
                isDetected: true,
                createdAt: DateTime.now(),
              );
              debugPrint('Field [$key] resolved by Groq: $val');
            } else {
              debugPrint('Field [$key] remained unresolved after Groq');
            }
          }
        }
      } catch (e) {
        debugPrint('Groq fallback failed: $e');
      }
    }

    // Fill in default non-detected fields for those still missing
    final allKeys = ['MRP', 'Net Quantity', 'Mfg Date', 'Expiry', 'Manufacturer', 'Consumer Care', 'FSSAI', 'Country of Origin'];
    for (final key in allKeys) {
      if (!fields.containsKey(key)) {
        fields[key] = ExtractedField(
          id: const Uuid().v4(),
          scanId: scanId,
          fieldName: key,
          fieldValue: null,
          confidence: 0.0,
          isDetected: false,
          createdAt: DateTime.now(),
        );
      }
    }

    return fields.values.toList();
  }

  static Future<Map<String, dynamic>> _callGroqFallback(String text, List<String> missingFields) async {
    final apiKey = dotenv.env['GROQ_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) return {};

    final prompt = '''
You are a strict data extraction AI. Extract the following missing fields from the provided OCR text of a product label.
Fields to extract: ${missingFields.join(', ')}

Return ONLY valid JSON with keys matching exactly the field names above. Do not include markdown, explanations, or backticks.
CRITICAL INSTRUCTION: If a field is truly not found in the text, output null for its value. DO NOT hallucinate, guess, or make up any placeholder values (e.g., do not invent "XYZ Foods", random numbers, or fake dates). Only extract exact values present in the text.
OCR Text:
"""
$text
"""
''';

    final response = await http.post(
      Uri.parse('https://api.groq.com/openai/v1/chat/completions'),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'model': 'llama-3.3-70b-versatile',
        'messages': [
          {'role': 'system', 'content': 'You are a strict data extraction AI that outputs strictly valid JSON. You NEVER hallucinate or invent data.'},
          {'role': 'user', 'content': prompt}
        ],
        'temperature': 0.1,
      }),
    ).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final content = data['choices'][0]['message']['content'].toString().trim();
      
      // Clean up markdown code blocks if the model mistakenly added them
      var cleanContent = content;
      if (cleanContent.startsWith('```json')) {
        cleanContent = cleanContent.replaceAll('```json', '');
      } else if (cleanContent.startsWith('```')) {
        cleanContent = cleanContent.replaceAll('```', '');
      }
      if (cleanContent.endsWith('```')) {
        cleanContent = cleanContent.substring(0, cleanContent.length - 3);
      }
      
      return jsonDecode(cleanContent.trim()) as Map<String, dynamic>;
    } else {
      throw Exception('Groq API error: ${response.statusCode} - ${response.body}');
    }
  }
}

class _FieldMatch {
  final String fieldName;
  final int start;
  final int end;
  final String matchedText;

  _FieldMatch(this.fieldName, this.start, this.end, this.matchedText);
}
