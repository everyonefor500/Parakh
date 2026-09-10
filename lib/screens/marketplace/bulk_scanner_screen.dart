import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class BulkScannerScreen extends StatelessWidget {
  const BulkScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Camera feed is dark
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: const Text('Bulk Verification'),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Mock camera feed
          const Center(
            child: Text(
              'Continuous Camera Feed\n(Mock)',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white54, fontSize: 24),
            ),
          ),
          
          // Mock bounding boxes for detected products
          Positioned(
            top: 200,
            left: 50,
            child: _buildBoundingBox('Product 1 (Scanning...)', AppColors.accentBlue),
          ),
          Positioned(
            top: 400,
            left: 150,
            child: _buildBoundingBox('Product 2 (Verified)', AppColors.statusCompliantGreen),
          ),

          // Bottom Sheet with results
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 200,
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: AppColors.bgPrimary,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Session Progress', style: AppTextStyles.titleLarge),
                      Text('2 items detected', style: AppTextStyles.bodyMedium),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const LinearProgressIndicator(
                    value: 0.5, // 50% complete
                    backgroundColor: AppColors.bgSecondary,
                    color: AppColors.accentBlue,
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () => context.pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.statusCompliantGreen,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: const Text('Finish Batch'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBoundingBox(String label, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          color: color,
          child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
        ),
        Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            border: Border.all(color: color, width: 2),
          ),
        ),
      ],
    );
  }
}
