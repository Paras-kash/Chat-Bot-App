// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_application_1/presentation/providers/auth_provider.dart';
import 'package:flutter_application_1/presentation/widgets/custom_button.dart';
import 'package:flutter_application_1/presentation/widgets/custom_form_field.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_application_1/core/utils/responsive_util.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text;
      final password = _passwordController.text;
      
      await ref.read(authProvider.notifier).login(email, password);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final isLoading = authState.status == AuthStatus.authenticating;
    final errorMessage = authState.errorMessage;

    // Get responsive dimensions
    final screenWidth = ResponsiveUtil.getScreenWidth(context);
    final screenHeight = ResponsiveUtil.getScreenHeight(context);
    final isLandscape = screenWidth > screenHeight;
    final isMobile = ResponsiveUtil.isMobile(context);
    final isTablet = ResponsiveUtil.isTablet(context);

    return Scaffold(
      backgroundColor: const Color(0xFF5BBCD6),
      body: SafeArea(
        child: OrientationBuilder(
          builder: (context, orientation) {
            // Use different layouts for landscape and portrait
            if (orientation == Orientation.landscape && !isMobile) {
              // Landscape layout for tablets and desktops
              return Row(
                children: [
                  // Left side with icon
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.chat_bubble_outline,
                          size: isTablet ? 60 : 80,
                          color: const Color(0xFF5BBCD6),
                        ),
                      ),
                    ),
                  ),
                  // Right side with form
                  Expanded(
                    flex: 2,
                    child: Container(
                      color: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveUtil.horizontalPadding(context),
                        vertical: ResponsiveUtil.verticalPadding(context),
                      ),
                      child: _buildLoginForm(context),
                    ),
                  ),
                ],
              );
            } else {
              // Portrait layout or mobile landscape
              return Column(
                children: [
                  // Top section with icon
                  Expanded(
                    flex: isMobile ? 1 : 2,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.chat_bubble_outline,
                          size: isMobile ? 40 : 60,
                          color: const Color(0xFF5BBCD6),
                        ),
                      ),
                    ),
                  ),
                  // Bottom section with form
                  Expanded(
                    flex: isMobile ? 3 : 4,
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveUtil.horizontalPadding(context),
                        vertical: ResponsiveUtil.verticalPadding(context),
                      ),
                      child: _buildLoginForm(context),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    final authState = ref.watch(authProvider);
    final isLoading = authState.status == AuthStatus.authenticating;
    final errorMessage = authState.errorMessage;
    final isMobile = ResponsiveUtil.isMobile(context);

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome Back',
              style: GoogleFonts.poppins(
                fontSize: ResponsiveUtil.getResponsiveFontSize(context, baseFontSize: 24),
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Login to continue',
              style: GoogleFonts.poppins(
                fontSize: ResponsiveUtil.getResponsiveFontSize(context, baseFontSize: 16),
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: isMobile ? 24 : 32),
            
            Text(
              'Email',
              style: GoogleFonts.poppins(
                fontSize: ResponsiveUtil.getResponsiveFontSize(context, baseFontSize: 16),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            CustomFormField(
              controller: _emailController,
              labelText: '',
              hintText: 'Enter your email',
              validator: _validateEmail,
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: isMobile ? 16 : 24),
            
            Text(
              'Password',
              style: GoogleFonts.poppins(
                fontSize: ResponsiveUtil.getResponsiveFontSize(context, baseFontSize: 16),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            CustomFormField(
              controller: _passwordController,
              labelText: '',
              hintText: 'Enter your password',
              validator: _validatePassword,
              obscureText: _obscurePassword,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey,
                ),
                onPressed: _togglePasswordVisibility,
              ),
            ),
            
            SizedBox(height: isMobile ? 24 : 32),
            
            if (errorMessage != null)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        errorMessage,
                        style: const TextStyle(color: Colors.red, fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            
            if (errorMessage != null) const SizedBox(height: 20),
            
            CustomButton(
              text: 'Login',
              onPressed: _login,
              isLoading: isLoading,
            ),
            
            const SizedBox(height: 24),
            
            Center(
              child: TextButton(
                onPressed: () {
                  context.push('/signup');
                },
                child: Text(
                  "Don't have an account? Sign Up",
                  style: TextStyle(
                    color: const Color(0xFF5BBCD6),
                    fontWeight: FontWeight.w500,
                    fontSize: ResponsiveUtil.getResponsiveFontSize(context, baseFontSize: 15),
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