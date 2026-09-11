import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';
import '../../router/app_router.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/primary_button.dart';
import '../../providers/role_provider.dart';
import '../../providers/app_state_provider.dart';
import '../../models/profile.dart';

class AuthScreen extends StatefulWidget {
  final String? redirectUrl;
  const AuthScreen({super.key, this.redirectUrl});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _entryController;
  late Animation<double> _logoScale;
  late Animation<double> _logoFade;
  late Animation<Offset> _contentSlide;
  late Animation<double> _contentFade;

  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  bool _isLoading = false;
  bool _isLogin = false; // Default to signup since they came from Role Selection

  @override
  void initState() {
    super.initState();
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _logoScale = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(
          parent: _entryController,
          curve: const Interval(0.0, 0.6, curve: Curves.elasticOut)),
    );
    _logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _entryController,
          curve: const Interval(0.0, 0.4, curve: Curves.easeOut)),
    );
    _contentSlide = Tween<Offset>(
      begin: const Offset(0, 0.05),
      end: Offset.zero,
    ).animate(CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOut)));
    _contentFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _entryController,
          curve: const Interval(0.3, 0.9, curve: Curves.easeOut)),
    );

    _entryController.forward();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _entryController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final fullName = _fullNameController.text.trim();
    final selectedRole = context.read<RoleProvider>().selectedRole ?? UserRole.consumer;

    if (email.isEmpty || password.isEmpty || (!_isLogin && fullName.isEmpty)) {
      _showError('Please fill all required fields.');
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (_isLogin) {
        // --- LOG IN ---
        final response = await Supabase.instance.client.auth.signInWithPassword(
          email: email,
          password: password,
        );

        if (response.user != null) {
          var profileData = await Supabase.instance.client
              .from('profiles')
              .select()
              .eq('id', response.user!.id)
              .maybeSingle();

          if (profileData == null) {
            // Edge case: Auth exists but profile doesn't. Create one.
            final userMeta = response.user!.userMetadata ?? {};
            final metaFullName = userMeta['full_name'] as String? ?? 'User';
            final roleString = userMeta['role'] as String? ?? 'consumer';
            
            profileData = await Supabase.instance.client
                .from('profiles')
                .insert({
                  'id': response.user!.id,
                  'full_name': metaFullName,
                  'role': roleString,
                })
                .select()
                .single();
          }

          final profile = Profile.fromJson(profileData);

          // Enforce role matching for login
          if (profile.role != selectedRole) {
            await Supabase.instance.client.auth.signOut();
            if (mounted) {
              _showError('These credentials belong to a different role. Please select the correct role and try again.');
              setState(() => _isLoading = false);
            }
            return;
          }
          
          if (mounted) {
            context.read<AppStateProvider>().login(profile);
            // Override the selected role with the REAL role from the profile
            context.read<RoleProvider>().setRole(profile.role);
            
            if (widget.redirectUrl != null) {
              context.go(widget.redirectUrl!);
            } else {
              context.go(AppRoutes.home);
            }
          }
        }
      } else {
        // --- SIGN UP ---
        final role = selectedRole;

        final response = await Supabase.instance.client.auth.signUp(
          email: email,
          password: password,
          data: {
            'full_name': fullName,
            'role': role.toString().split('.').last, // e.g., 'consumer'
          },
        );

        if (response.user != null && mounted) {
          final roleString = role.toString().split('.').last;
          
          try {
            await Supabase.instance.client.from('profiles').insert({
              'id': response.user!.id,
              'full_name': fullName,
              'role': roleString,
            });
          } catch (_) {
            // Ignored, might exist already
          }

          final profileData = await Supabase.instance.client
              .from('profiles')
              .select()
              .eq('id', response.user!.id)
              .single();

          final profile = Profile.fromJson(profileData);

          if (mounted) {
            context.read<AppStateProvider>().login(profile);
            context.read<RoleProvider>().setRole(profile.role);
            
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Account created successfully!', style: AppTextStyles.bodyMedium),
                backgroundColor: AppColors.statusCompliantGreen,
                behavior: SnackBarBehavior.floating,
              ),
            );

            if (widget.redirectUrl != null) {
              context.go(widget.redirectUrl!);
            } else {
              context.go(AppRoutes.home);
            }
          }
        }
      }
    } on AuthException catch (e) {
      _showError(e.message);
      debugPrint('AuthException: ${e.message}');
    } catch (e) {
      _showError('An unexpected error occurred.');
      debugPrint('Error: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: AppTextStyles.bodyMedium),
        backgroundColor: AppColors.statusViolationRed,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedRole = context.watch<RoleProvider>().selectedRole ?? UserRole.consumer;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0D1526), AppColors.bgPrimary],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Positioned(
            top: -80,
            left: 0,
            right: 0,
            child: Container(
              height: 340,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    AppColors.accentBlue.withValues(alpha: 0.12),
                    Colors.transparent,
                  ],
                  radius: 0.8,
                ),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28.0),
              child: SizedBox(
                height: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        icon: const Icon(Symbols.arrow_back_rounded, color: AppColors.textSecondary),
                        onPressed: () => context.pop(),
                      ),
                    ),

                    const Spacer(flex: 1),

                    AnimatedBuilder(
                      animation: _entryController,
                      builder: (context, child) => FadeTransition(
                        opacity: _logoFade,
                        child: ScaleTransition(
                          scale: _logoScale,
                          child: Center(
                            child: Container(
                              width: 88,
                              height: 88,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [
                                    AppColors.accentBlue.withValues(alpha: 0.2),
                                    AppColors.accentBlue.withValues(alpha: 0.05),
                                  ],
                                ),
                                border: Border.all(
                                  color: AppColors.accentBlue.withValues(alpha: 0.4),
                                  width: 1.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.accentBlue.withValues(alpha: 0.25),
                                    blurRadius: 32,
                                    spreadRadius: 4,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Symbols.shield_rounded,
                                size: 44,
                                color: AppColors.accentBlue,
                                fill: 1,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    AnimatedBuilder(
                      animation: _entryController,
                      builder: (context, child) => FadeTransition(
                        opacity: _logoFade,
                        child: Column(
                          children: [
                            Text(
                              _isLogin ? 'Welcome Back' : 'Create Account',
                              style: AppTextStyles.displayLarge,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Join Parakh AI Platform',
                              style: AppTextStyles.bodyMedium,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const Spacer(flex: 1),

                    AnimatedBuilder(
                      animation: _entryController,
                      builder: (context, child) => FadeTransition(
                        opacity: _contentFade,
                        child: SlideTransition(
                          position: _contentSlide,
                          child: child,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: AppColors.accentBlue.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.accentBlue.withValues(alpha: 0.3)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Symbols.verified_user_rounded, color: AppColors.accentBlue, size: 24),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Selected Role',
                                        style: AppTextStyles.labelSmall.copyWith(color: AppColors.textTertiary),
                                      ),
                                      Text(
                                        selectedRole.label,
                                        style: AppTextStyles.titleMedium.copyWith(color: AppColors.accentBlue),
                                      ),
                                    ],
                                  ),
                                ),
                                TextButton(
                                  onPressed: () => context.pop(),
                                  child: Text('Change', style: AppTextStyles.labelMedium.copyWith(color: AppColors.textSecondary)),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          if (!_isLogin) ...[
                            _buildTextField(
                              controller: _fullNameController,
                              label: 'Full Name',
                              icon: Symbols.person_rounded,
                            ),
                            const SizedBox(height: 16),
                          ],
                          _buildTextField(
                            controller: _emailController,
                            label: 'Email',
                            icon: Symbols.mail_rounded,
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            controller: _passwordController,
                            label: 'Password',
                            icon: Symbols.lock_rounded,
                            obscureText: true,
                          ),
                          
                          if (_isLogin) ...[
                            const SizedBox(height: 8),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {},
                                child: Text(
                                  'Forgot Password?',
                                  style: AppTextStyles.labelMedium.copyWith(color: AppColors.accentBlue),
                                ),
                              ),
                            ),
                          ] else ...[
                            const SizedBox(height: 24),
                          ],

                          _isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : PrimaryButton(
                                  text: _isLogin ? 'Log In' : 'Sign Up',
                                  onPressed: _handleSubmit,
                                ),
                          
                          const SizedBox(height: 16),
                          
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _isLogin ? "Don't have an account?" : "Already have an account?",
                                style: AppTextStyles.bodyMedium,
                              ),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _isLogin = !_isLogin;
                                  });
                                },
                                child: Text(
                                  _isLogin ? 'Sign Up' : 'Log In',
                                  style: AppTextStyles.labelLarge.copyWith(
                                    color: AppColors.accentBlue,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const Spacer(flex: 2),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.textSecondary, size: 20, fill: 1),
        filled: true,
        fillColor: AppColors.bgSecondary,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.cardBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.cardBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.accentBlue, width: 1.5),
        ),
      ),
    );
  }
}
