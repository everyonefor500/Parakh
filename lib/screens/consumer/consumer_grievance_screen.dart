import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state_provider.dart';
import '../../router/app_router.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/primary_button.dart';

class ConsumerGrievanceScreen extends StatefulWidget {
  const ConsumerGrievanceScreen({super.key});

  @override
  State<ConsumerGrievanceScreen> createState() => _ConsumerGrievanceScreenState();
}

class _ConsumerGrievanceScreenState extends State<ConsumerGrievanceScreen> {
  final _productNameController = TextEditingController();
  final _shopNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  File? _evidenceImage;
  bool _isSubmitting = false;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _evidenceImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _submitGrievance() async {
    if (_productNameController.text.trim().isEmpty || 
        _shopNameController.text.trim().isEmpty || 
        _descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill all fields.'),
          backgroundColor: context.appColors.statusViolationRed,
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final user = context.read<AppStateProvider>().currentUser;
      if (user == null) throw Exception('Not logged in');

      final supabase = Supabase.instance.client;
      String? evidenceUrl;

      if (_evidenceImage != null) {
        final fileExt = _evidenceImage!.path.split('.').last;
        final fileName = '${const Uuid().v4()}.$fileExt';
        final storagePath = '${user.id}/$fileName';

        await supabase.storage.from('grievance-evidence').upload(storagePath, _evidenceImage!);
        evidenceUrl = supabase.storage.from('grievance-evidence').getPublicUrl(storagePath);
      }

      final insertData = {
        'id': const Uuid().v4(),
        'submitted_by': user.id,
        'category': 'other', // default category
        'description': _descriptionController.text.trim(),
        'evidence_url': evidenceUrl,
        'status': 'submitted',
        'product_name': _productNameController.text.trim(),
        'shop_seller_name': _shopNameController.text.trim(),
      };

      final response = await supabase
          .from('complaints')
          .insert(insertData)
          .select()
          .single();

      final complaintCode = response['complaint_code'] ?? 'Unknown Code';

      if (mounted) {
        context.go(AppRoutes.home);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Symbols.check_circle_rounded,
                    color: Colors.white, size: 18, fill: 1),
                SizedBox(width: 8),
                Expanded(
                  child: Text('Grievance submitted. Code: $complaintCode',
                      style: AppTextStyles.bodyMedium
                          .copyWith(color: Colors.white)),
                ),
              ],
            ),
            backgroundColor: context.appColors.statusCompliantGreen,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    } catch (e) {
      debugPrint('Error submitting grievance: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit grievance.'),
            backgroundColor: context.appColors.statusViolationRed,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _productNameController.dispose();
    _shopNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('File a Grievance')),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header
                    Text(
                      'Report a Non-Compliant Product',
                      style: AppTextStyles.headlineMedium,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Your report will be securely sent to the Legal Metrology department for action.',
                      style: AppTextStyles.bodyMedium,
                    ),
                    SizedBox(height: 32),

                    // Form fields
                    _buildField(context,
                      label: 'Product Name / Brand',
                      icon: Symbols.inventory_2_rounded,
                      controller: _productNameController,
                    ),
                    SizedBox(height: 16),
                    _buildField(context,
                      label: 'Shop / Seller Name',
                      icon: Symbols.storefront_rounded,
                      controller: _shopNameController,
                    ),
                    SizedBox(height: 16),
                    _buildField(context,
                      label: 'Issue Description',
                      icon: Symbols.description_rounded,
                      maxLines: 4,
                      controller: _descriptionController,
                    ),
                    SizedBox(height: 24),

                    // Photo upload zone
                    Text(
                      'Attach Evidence',
                      style: AppTextStyles.titleMedium,
                    ),
                    SizedBox(height: 12),
                    GestureDetector(
                      onTap: _isSubmitting ? null : _pickImage,
                      child: Container(
                        height: 160,
                        decoration: BoxDecoration(
                          color: context.appColors.bgSecondary,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: context.appColors.accentBlue.withValues(alpha: 0.3),
                            width: 1.5,
                            style: BorderStyle.solid,
                          ),
                          image: _evidenceImage != null 
                              ? DecorationImage(
                                  image: FileImage(_evidenceImage!),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: _evidenceImage == null
                            ? DashedBorderContainer(
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              context.appColors.accentBlue
                                                  .withValues(alpha: 0.15),
                                              context.appColors.accentBlue
                                                  .withValues(alpha: 0.06),
                                            ],
                                          ),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Symbols.add_a_photo_rounded,
                                          color: context.appColors.accentBlue,
                                          size: 24,
                                          fill: 1,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'Tap to upload photo',
                                        style: AppTextStyles.bodyMedium.copyWith(
                                          color: context.appColors.accentBlue
                                              .withValues(alpha: 0.75),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : Container(
                                alignment: Alignment.topRight,
                                padding: EdgeInsets.all(8),
                                child: IconButton(
                                  icon: Icon(Icons.close, color: Colors.white),
                                  onPressed: () {
                                    setState(() {
                                      _evidenceImage = null;
                                    });
                                  },
                                ),
                              ),
                      ),
                    ),
                    SizedBox(height: 32),
                  ],
                ),
              ),
            ),

            // Submit button
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: _isSubmitting 
                ? Center(child: CircularProgressIndicator())
                : PrimaryButton(
                    text: 'Submit Grievance',
                    icon: Symbols.send_rounded,
                    onPressed: _submitGrievance,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(
      BuildContext context,
      {required String label,
      required IconData icon,
      required TextEditingController controller,
      int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: AppTextStyles.bodyMedium.copyWith(color: context.appColors.textPrimary),
      decoration: InputDecoration(
        labelText: maxLines == 1 ? label : null,
        hintText: maxLines > 1 ? label : null,
        prefixIcon: maxLines == 1
            ? Icon(icon, color: context.appColors.textSecondary, size: 20, fill: 1)
            : null,
        filled: true,
        fillColor: context.appColors.bgSecondary,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: context.appColors.cardBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: context.appColors.cardBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide:
              BorderSide(color: context.appColors.accentBlue, width: 1.5),
        ),
      ),
    );
  }
}

/// Simple wrapper that allows the inner child — used for the photo zone styling.
class DashedBorderContainer extends StatelessWidget {
  final Widget child;
  const DashedBorderContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) => child;
}

