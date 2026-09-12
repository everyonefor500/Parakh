import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../router/app_router.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../providers/scan_flow_provider.dart';
import '../../providers/app_state_provider.dart';

class AiProcessingScreen extends StatefulWidget {
  const AiProcessingScreen({super.key});

  @override
  State<AiProcessingScreen> createState() => _AiProcessingScreenState();
}

class _AiProcessingScreenState extends State<AiProcessingScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = context.read<AppStateProvider>().currentUser;
      if (user != null) {
        context.read<ScanFlowProvider>().runPipeline(user.id).then((_) async {
          if (mounted) {
            await context.read<AppStateProvider>().fetchHistory();
            if (mounted) {
              // Once pipeline finishes (Phase 2 goes to step 5 but we just push replacement)
              context.pushReplacement(AppRoutes.scanExtracted);
            }
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final flowProvider = context.watch<ScanFlowProvider>();
    final imageUrl = flowProvider.placeholderImageUrl;
    final currentIndex = flowProvider.currentStepIndex;
    
    final stages = [
      'Image Captured',
      'Label region detected',
      'OCR text extracted',
      'Extracting product fields',
      'Checking rules & generating verdict',
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF050A12),
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
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: context.appColors.accentBlue),
                    const SizedBox(height: 32),
                    Text(
                      'AI Processing',
                      style: AppTextStyles.headlineMedium.copyWith(color: Colors.white),
                    ),
                    const SizedBox(height: 24),
                    ...List.generate(stages.length, (index) {
                      bool isPast = index < currentIndex;
                      bool isCurrent = index == currentIndex;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Row(
                          children: [
                            Icon(
                              isPast ? Icons.check_circle : (isCurrent ? Icons.sync : Icons.radio_button_unchecked),
                              color: isPast ? context.appColors.statusCompliantGreen : (isCurrent ? context.appColors.accentBlue : Colors.white24),
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                stages[index],
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: isPast || isCurrent ? Colors.white : Colors.white24,
                                  fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
