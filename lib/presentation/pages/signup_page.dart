import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_application_1/presentation/providers/auth_provider.dart';
import 'package:flutter_application_1/presentation/widgets/custom_button.dart';
import 'package:flutter_application_1/presentation/widgets/custom_form_field.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_application_1/core/utils/responsive_util.dart';

class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({super.key});

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _obscureConfirmPassword = !_obscureConfirmPassword;
    });
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    return null;
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

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  void _signup() async {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text;
      final email = _emailController.text;
      final password = _passwordController.text;
      
      await ref.read(authProvider.notifier).signup(name, email, password);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final isLoading = authState.status == AuthStatus.authenticating;
    final errorMessage = authState.errorMessage;
    
    final isMobile = ResponsiveUtil.isMobile(context);
    final isTablet = ResponsiveUtil.isTablet(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            context.pop();
          },
        ),
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          if (orientation == Orientation.landscape && !isMobile) {
            // Landscape layout for tablets and desktop
            return Row(
              children: [
                // Left section with title
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.all(ResponsiveUtil.horizontalPadding(context)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Join Us Today',
                          style: GoogleFonts.poppins(
                            fontSize: ResponsiveUtil.getResponsiveFontSize(context, baseFontSize: 32),
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF5BBCD6),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Create an account and start chatting with our AI assistant',
                          style: GoogleFonts.poppins(
                            fontSize: ResponsiveUtil.getResponsiveFontSize(context, baseFontSize: 16),
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),
                        Image.asset(
                          'assets/signup.png', 
                          height: 200,
                          errorBuilder: (context, error, stackTrace) => 
                            Icon(Icons.person_add_alt_1_rounded, size: 100, color: const Color(0xFF5BBCD6)),
                        ),
                      ],
                    ),
                  ),
                ),
                // Right section with form
                Expanded(
                  flex: 2,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFFF5F7FA),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        bottomLeft: Radius.circular(40),
                      ),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveUtil.horizontalPadding(context),
                      vertical: ResponsiveUtil.verticalPadding(context),
                    ),
                    child: _buildSignupForm(context),
                  ),
                ),
              ],
            );
          } else {
            // Portrait layout or mobile
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveUtil.horizontalPadding(context),
                vertical: isMobile ? 16.0 : ResponsiveUtil.verticalPadding(context),
              ),
              child: _buildSignupForm(context),
            );
          }
        },
      ),
    );
  }

  Widget _buildSignupForm(BuildContext context) {
    final authState = ref.watch(authProvider);
    final isLoading = authState.status == AuthStatus.authenticating;
    final errorMessage = authState.errorMessage;
    final isMobile = ResponsiveUtil.isMobile(context);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (MediaQuery.of(context).orientation == Orientation.portrait)
            Center(
              child: Text(
                'Signup',
                style: GoogleFonts.poppins(
                  fontSize: ResponsiveUtil.getResponsiveFontSize(context, baseFontSize: 28),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          if (MediaQuery.of(context).orientation == Orientation.portrait)
            const SizedBox(height: 32),
          
          Text(
            'Full Name',
            style: GoogleFonts.poppins(
              fontSize: ResponsiveUtil.getResponsiveFontSize(context, baseFontSize: 16),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          CustomFormField(
            controller: _nameController,
            labelText: '',
            hintText: 'Enter your name',
            validator: _validateName,
          ),
          
          SizedBox(height: isMobile ? 16 : 24),
          
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
          
          SizedBox(height: isMobile ? 16 : 24),
          
          Text(
            'Confirm Password',
            style: GoogleFonts.poppins(
              fontSize: ResponsiveUtil.getResponsiveFontSize(context, baseFontSize: 16),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          CustomFormField(
            controller: _confirmPasswordController,
            labelText: '',
            hintText: 'Confirm your password',
            validator: _validateConfirmPassword,
            obscureText: _obscureConfirmPassword,
            suffixIcon: IconButton(
              icon: Icon(
                _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey,
              ),
              onPressed: _toggleConfirmPasswordVisibility,
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
            text: 'Sign Up',
            onPressed: _signup,
            isLoading: isLoading,
          ),
          
          const SizedBox(height: 16),
          
          Center(
            child: TextButton(
              onPressed: () {
                context.go('/login');
              },
              child: Text(
                'Already have an account? Login',
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
    );
  }
}