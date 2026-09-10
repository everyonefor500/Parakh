import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../router/app_router.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/field_row.dart';
import '../../widgets/primary_button.dart';

class ExtractedInfoScreen extends StatelessWidget {
  const ExtractedInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Extracted Info')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Please verify the details extracted from the package.',
                style: AppTextStyles.bodyMedium,
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView(
                  children: const [
                    FieldRow(label: 'Product Name', value: 'Fresh Apple Juice'),
                    FieldRow(label: 'MRP', value: '₹120'),
                    FieldRow(label: 'Net Quantity', value: '1 L'),
                    FieldRow(label: 'Manufacturing Date', value: '12-Aug-2026'),
                    FieldRow(label: 'Expiry Date', value: '12-Feb-2027'),
                    FieldRow(label: 'Manufacturer', value: 'Fresh Foods Ltd'),
                    FieldRow(label: 'Customer Care', value: '1800-123-4567'),
                  ],
                ),
              ),
              PrimaryButton(
                text: 'Confirm & Analyze',
                onPressed: () {
                  context.pushReplacement(AppRoutes.scanCompliance);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
