import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/app_logo_widget.dart';
import './widgets/biometric_prompt_widget.dart';
import './widgets/login_form_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  bool _isLoading = false;
  bool _showBiometricPrompt = false;
  bool _isBiometricLoading = false;
  String? _errorMessage;

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Mock credentials for testing
  final Map<String, String> _mockCredentials = {
    'admin@cryptolend.com': 'admin123',
    'user@cryptolend.com': 'user123',
    'demo@cryptolend.com': 'demo123',
  };

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin(String email, String password) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // Simulate blockchain authentication delay
    await Future.delayed(const Duration(seconds: 2));

    // Validate credentials
    if (_mockCredentials.containsKey(email) &&
        _mockCredentials[email] == password) {
      // Success - trigger haptic feedback
      HapticFeedback.lightImpact();

      setState(() {
        _isLoading = false;
        _showBiometricPrompt = true;
      });
    } else {
      setState(() {
        _isLoading = false;
        _errorMessage = _getErrorMessage(email, password);
      });

      // Error haptic feedback
      HapticFeedback.heavyImpact();
    }
  }

  String _getErrorMessage(String email, String password) {
    if (!_mockCredentials.containsKey(email)) {
      return 'Usuario no encontrado. Verifica tu email.';
    } else if (_mockCredentials[email] != password) {
      return 'Contraseña incorrecta. Inténtalo de nuevo.';
    } else {
      return 'Error de conexión. Verifica tu red.';
    }
  }

  Future<void> _handleBiometricSetup() async {
    setState(() {
      _isBiometricLoading = true;
    });

    // Simulate biometric setup
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isBiometricLoading = false;
    });

    // Success haptic feedback
    HapticFeedback.lightImpact();

    // Navigate to dashboard
    Navigator.pushReplacementNamed(context, '/dashboard');
  }

  void _handleSkipBiometric() {
    // Navigate to dashboard without biometric setup
    Navigator.pushReplacementNamed(context, '/dashboard');
  }

  void _handleSignUp() {
    Navigator.pushNamed(context, '/onboarding-flow');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            // Main Content
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height -
                      MediaQuery.of(context).padding.top -
                      MediaQuery.of(context).padding.bottom,
                ),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6.w),
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: Column(
                          children: [
                            SizedBox(height: 8.h),

                            // App Logo
                            const AppLogoWidget(),

                            SizedBox(height: 6.h),

                            // Welcome Text
                            Text(
                              'Bienvenido de vuelta',
                              style: AppTheme.lightTheme.textTheme.headlineSmall
                                  ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color:
                                    AppTheme.lightTheme.colorScheme.onSurface,
                              ),
                              textAlign: TextAlign.center,
                            ),

                            SizedBox(height: 1.h),

                            Text(
                              'Accede a tu wallet DeFi de forma segura',
                              style: AppTheme.lightTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                              ),
                              textAlign: TextAlign.center,
                            ),

                            SizedBox(height: 4.h),

                            // Error Message
                            if (_errorMessage != null) ...[
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(4.w),
                                decoration: BoxDecoration(
                                  color: AppTheme
                                      .lightTheme.colorScheme.errorContainer,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: AppTheme.lightTheme.colorScheme.error
                                        .withValues(alpha: 0.3),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    CustomIconWidget(
                                      iconName: 'error_outline',
                                      color:
                                          AppTheme.lightTheme.colorScheme.error,
                                      size: 20,
                                    ),
                                    SizedBox(width: 3.w),
                                    Expanded(
                                      child: Text(
                                        _errorMessage!,
                                        style: AppTheme
                                            .lightTheme.textTheme.bodySmall
                                            ?.copyWith(
                                          color: AppTheme.lightTheme.colorScheme
                                              .onErrorContainer,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 3.h),
                            ],

                            // Login Form
                            LoginFormWidget(
                              onLogin: _handleLogin,
                              isLoading: _isLoading,
                            ),

                            const Spacer(),

                            // Sign Up Link
                            Padding(
                              padding: EdgeInsets.only(bottom: 4.h),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '¿Nuevo en DeFi? ',
                                    style: AppTheme
                                        .lightTheme.textTheme.bodyMedium
                                        ?.copyWith(
                                      color: AppTheme.lightTheme.colorScheme
                                          .onSurfaceVariant,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed:
                                        _isLoading ? null : _handleSignUp,
                                    style: TextButton.styleFrom(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 2.w),
                                      minimumSize: Size.zero,
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    child: Text(
                                      'Regístrate',
                                      style: AppTheme
                                          .lightTheme.textTheme.bodyMedium
                                          ?.copyWith(
                                        color: AppTheme
                                            .lightTheme.colorScheme.primary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Biometric Prompt Overlay
            if (_showBiometricPrompt)
              Container(
                color: AppTheme.lightTheme.colorScheme.scrim
                    .withValues(alpha: 0.7),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: BiometricPromptWidget(
                      onEnableBiometric: _handleBiometricSetup,
                      onSkip: _handleSkipBiometric,
                      isLoading: _isBiometricLoading,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
