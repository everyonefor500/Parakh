import 'dart:io';
import 'package:supabase/supabase.dart';

void main() async {
  final envFile = File('.env');
  final lines = envFile.readAsLinesSync();
  String supabaseUrl = '';
  String supabaseKey = '';
  for (var line in lines) {
    if (line.startsWith('SUPABASE_URL=')) supabaseUrl = line.split('=')[1].trim();
    if (line.startsWith('SUPABASE_ANON_KEY=')) supabaseKey = line.split('=')[1].trim();
  }
  
  final client = SupabaseClient(supabaseUrl, supabaseKey);

  try {
    final res = await client.from('complaints').select();
    print('Total complaints: ${res.length}');
    for (var row in res) {
      print('ID: ${row['id']}, evidence_url: ${row['evidence_url']}');
    }
  } catch (e) {
    print('Error: $e');
  }
  exit(0);
}
