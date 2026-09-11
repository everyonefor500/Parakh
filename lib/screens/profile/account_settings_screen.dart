import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state_provider.dart';
import '../../models/profile.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/primary_button.dart';

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _orgController;
  late TextEditingController _designationController;
  late TextEditingController _deptController;
  late TextEditingController _stateController;
  late TextEditingController _districtController;
  String? _languagePreference;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final profile = context.read<AppStateProvider>().currentUser;
    _nameController = TextEditingController(text: profile?.fullName);
    _phoneController = TextEditingController(text: profile?.phone);
    _orgController = TextEditingController(text: profile?.organization);
    _designationController = TextEditingController(text: profile?.designation);
    _deptController = TextEditingController(text: profile?.department);
    _stateController = TextEditingController(text: profile?.state);
    _districtController = TextEditingController(text: profile?.district);
    
    final pref = profile?.languagePreference;
    final validCodes = ['en', 'hi', 'ta', 'te', 'bn'];
    _languagePreference = (pref != null && validCodes.contains(pref)) ? pref : 'en';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _orgController.dispose();
    _designationController.dispose();
    _deptController.dispose();
    _stateController.dispose();
    _districtController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) throw Exception('Not logged in');

      final updates = {
        'id': user.id,
        'full_name': _nameController.text.trim(),
        'phone': _phoneController.text.trim(),
        'organization': _orgController.text.trim(),
        'designation': _designationController.text.trim(),
        'department': _deptController.text.trim(),
        'state': _stateController.text.trim(),
        'district': _districtController.text.trim(),
        'language_preference': _languagePreference,
      };

      final response = await Supabase.instance.client
          .from('profiles')
          .upsert(updates)
          .select()
          .single();

      if (mounted) {
        final updatedProfile = Profile.fromJson(response);
        context.read<AppStateProvider>().login(updatedProfile);
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully'), backgroundColor: AppColors.statusCompliantGreen),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating profile: $e'), backgroundColor: AppColors.statusViolationRed),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Widget _buildField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        style: AppTextStyles.bodyMedium,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: AppColors.bgSecondary,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.cardBorder),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.cardBorder),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        title: const Text('Account Settings'),
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildField('Full Name', _nameController),
                  _buildField('Phone Number', _phoneController),
                  _buildField('Organization', _orgController),
                  _buildField('Designation', _designationController),
                  _buildField('Department', _deptController),
                  _buildField('State', _stateController),
                  _buildField('District', _districtController),
                  
                  const SizedBox(height: 8),
                  Text('Language Preference', style: AppTextStyles.labelLarge),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _languagePreference, // ignore: deprecated_member_use
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.bgSecondary,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.cardBorder),
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'en', child: Text('English')),
                      DropdownMenuItem(value: 'hi', child: Text('Hindi')),
                      DropdownMenuItem(value: 'ta', child: Text('Tamil')),
                      DropdownMenuItem(value: 'te', child: Text('Telugu')),
                      DropdownMenuItem(value: 'bn', child: Text('Bengali')),
                    ],
                    onChanged: (val) {
                      setState(() {
                        _languagePreference = val;
                      });
                    },
                  ),
                  
                  const SizedBox(height: 32),
                  PrimaryButton(
                    text: 'Save Changes',
                    onPressed: _saveProfile,
                  ),
                ],
              ),
            ),
          ),
    );
  }
}
