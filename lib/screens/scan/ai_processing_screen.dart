import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../router/app_router.dart';
import '../../widgets/loading_state.dart';
import '../../providers/scan_flow_provider.dart';

class AiProcessingScreen extends StatefulWidget {
  const AiProcessingScreen({super.key});

  @override
  State<AiProcessingScreen> createState() => _AiProcessingScreenState();
}

class _AiProcessingScreenState extends State<AiProcessingScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        context.pushReplacement(AppRoutes.scanExtracted);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = context.watch<ScanFlowProvider>().placeholderImageUrl;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            if (imageUrl != null && imageUrl.isNotEmpty)
              Container(
                height: 250,
                width: double.infinity,
                margin: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white24, width: 2),
                  image: DecorationImage(
                    image: FileImage(File(imageUrl)),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            const Expanded(
              child: LoadingState(
                message: 'Extracting product information…',
                subMessage: 'Our AI is reading the label',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
