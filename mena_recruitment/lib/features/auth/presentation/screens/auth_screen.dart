import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mena_recruitment/core/routing/route_names.dart';
import 'package:mena_recruitment/core/theme/app_colors.dart';
import 'package:mena_recruitment/features/auth/providers/auth_provider.dart';

class AuthScreen extends ConsumerStatefulWidget {
  final bool initialIsSignUp;

  const AuthScreen({
    super.key,
    this.initialIsSignUp = false,
  });

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  late bool _isSignUp;

  // Controllers for Sign In
  final _signInEmailController = TextEditingController();
  final _signInPasswordController = TextEditingController();
  bool _signInObscure = true;

  // Controllers for Sign Up
  final _signUpNameController = TextEditingController();
  final _signUpEmailController = TextEditingController();
  final _signUpPhoneController = TextEditingController();
  final _signUpPasswordController = TextEditingController();
  String _selectedCountryCode = '+966';
  bool _signUpObscure = true;
  bool _agreeToTerms = true;

  final List<Map<String, String>> _countryCodes = [
    {'code': '+966', 'flag': '🇸🇦', 'name': 'Saudi Arabia'},
    {'code': '+971', 'flag': '🇦🇪', 'name': 'UAE'},
    {'code': '+974', 'flag': '🇶🇦', 'name': 'Qatar'},
    {'code': '+965', 'flag': '🇰🇼', 'name': 'Kuwait'},
    {'code': '+968', 'flag': '🇴🇲', 'name': 'Oman'},
    {'code': '+973', 'flag': '🇧🇭', 'name': 'Bahrain'},
    {'code': '+20', 'flag': '🇪🇬', 'name': 'Egypt'},
    {'code': '+91', 'flag': '🇮🇳', 'name': 'India'},
    {'code': '+92', 'flag': '🇵🇰', 'name': 'Pakistan'},
    {'code': '+44', 'flag': '🇬🇧', 'name': 'UK'},
    {'code': '+1', 'flag': '🇺🇸', 'name': 'USA'},
    {'code': '+65', 'flag': '🇸🇬', 'name': 'Singapore'},
  ];

  @override
  void initState() {
    super.initState();
    _isSignUp = widget.initialIsSignUp;
    // Check backend health on screen open
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(authStateProvider.notifier).checkServerHealth();
    });
  }

  @override
  void dispose() {
    _signInEmailController.dispose();
    _signInPasswordController.dispose();
    _signUpNameController.dispose();
    _signUpEmailController.dispose();
    _signUpPhoneController.dispose();
    _signUpPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignIn() async {
    final email = _signInEmailController.text.trim();
    final password = _signInPasswordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter both email and password.'),
          backgroundColor: Color(0xFFBA1A1A),
        ),
      );
      return;
    }

    final success = await ref.read(authStateProvider.notifier).login(email, password);
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✓ Welcome back, $email!'),
          backgroundColor: const Color(0xFF059669),
        ),
      );
      context.go(RouteNames.jobs);
    }
  }

  Future<void> _handleSignUp() async {
    final name = _signUpNameController.text.trim();
    final email = _signUpEmailController.text.trim();
    final phone = _signUpPhoneController.text.trim();
    final password = _signUpPasswordController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please complete all required fields.'),
          backgroundColor: Color(0xFFBA1A1A),
        ),
      );
      return;
    }

    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password must be at least 6 characters.'),
          backgroundColor: Color(0xFFBA1A1A),
        ),
      );
      return;
    }

    if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please accept the Terms of Service to continue.'),
          backgroundColor: Color(0xFFBA1A1A),
        ),
      );
      return;
    }

    final success = await ref.read(authStateProvider.notifier).register(
      email: email,
      password: password,
      fullName: name,
      phoneCountryCode: _selectedCountryCode,
      phoneNumber: phone.isNotEmpty ? phone : null,
      role: 'candidate',
    );

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✓ Account created successfully! Signed in as $email'),
          backgroundColor: const Color(0xFF059669),
        ),
      );
      context.go(RouteNames.jobs);
    }
  }

  void _fillDemoAccount() {
    _signInEmailController.text = 'candidate@suhana-global.com';
    _signInPasswordController.text = 'Secret123!';
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Seeded live database account populated.'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  Future<void> _handleDemoLogin() async {
    await ref.read(authStateProvider.notifier).loginDemo();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✓ Entered candidate portal in offline demo mode.'),
          backgroundColor: Color(0xFF1E1B1B),
        ),
      );
      context.go(RouteNames.jobs);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final isLoading = authState.isLoading;

    return Scaffold(
      backgroundColor: const Color(0xFFFBF8F8),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // App Header
                  Center(
                    child: Column(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: const Color(0xFFE4BEB8), width: 1),
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromRGBO(153, 0, 0, 0.08),
                                blurRadius: 12,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              'https://lh3.googleusercontent.com/aida-public/AB6AXuBwOYlqgz9hq3-QkZMTQKrk8RqrIN4FGFSQc8QYsxhhqAIMh_0WMqnASqOsLPc_vS7CyE4sGCpDEhxgxQNeb6FsaDYR5rhekKgxiLZ64De4x3HsSZK5ss2AYmsXBmy1BY1SrS4grQdpvIouVZGmQH5ZUS8_L9xTWRa7GAEVahNwg5BkdcvG_XN6HVAzKVzzoUp8fcHBj7tVCeSmF0NSxyslYdH0omLOececpwsH4PC2zFbdZh82i7R-QAQnjr4ZrP-BI_0',
                              fit: BoxFit.contain,
                              errorBuilder: (ctx, err, stack) => const Icon(
                                Icons.public_rounded,
                                color: AppColors.primary,
                                size: 32,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Global Jobs By Suhana',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF990000),
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'MENA & Global Recruitment Platform',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF5B403C),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Database & Backend Connectivity Badge
                        InkWell(
                          onTap: () async {
                            final messenger = ScaffoldMessenger.of(context);
                            final online = await ref.read(authStateProvider.notifier).checkServerHealth();
                            messenger.showSnackBar(
                              SnackBar(
                                content: Text(
                                  online
                                      ? '✓ Connected to live API & Neon PostgreSQL database.'
                                      : 'Backend offline. App will use live Neon DB via API when started, or offline demo mode.',
                                ),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(9999),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: authState.isBackendOnline
                                  ? const Color(0xFFDCFCE7)
                                  : const Color(0xFFFEF3C7),
                              borderRadius: BorderRadius.circular(9999),
                              border: Border.all(
                                color: authState.isBackendOnline
                                    ? const Color(0xFF86EFAC)
                                    : const Color(0xFFFDE68A),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 7,
                                  height: 7,
                                  decoration: BoxDecoration(
                                    color: authState.isBackendOnline
                                        ? const Color(0xFF16A34A)
                                        : const Color(0xFFD97706),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  authState.isBackendOnline
                                      ? 'Neon Cloud DB Connected'
                                      : 'Offline / Local API Ready',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: authState.isBackendOnline
                                        ? const Color(0xFF15803D)
                                        : const Color(0xFFB45309),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Segmented Switcher (Sign In vs Create Account)
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0E4E2),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              ref.read(authStateProvider.notifier).clearError();
                              setState(() => _isSignUp = false);
                            },
                            borderRadius: BorderRadius.circular(10),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: !_isSignUp ? Colors.white : Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: !_isSignUp
                                    ? const [
                                        BoxShadow(
                                          color: Color.fromRGBO(0, 0, 0, 0.06),
                                          blurRadius: 4,
                                          offset: Offset(0, 2),
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Text(
                                'Sign In',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: !_isSignUp ? const Color(0xFF990000) : const Color(0xFF5B403C),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              ref.read(authStateProvider.notifier).clearError();
                              setState(() => _isSignUp = true);
                            },
                            borderRadius: BorderRadius.circular(10),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: _isSignUp ? Colors.white : Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: _isSignUp
                                    ? const [
                                        BoxShadow(
                                          color: Color.fromRGBO(0, 0, 0, 0.06),
                                          blurRadius: 4,
                                          offset: Offset(0, 2),
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Text(
                                'Create Account',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: _isSignUp ? const Color(0xFF990000) : const Color(0xFF5B403C),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Error Banner
                  if (authState.errorMessage != null)
                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF2F2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFFCA5A5)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline_rounded, color: Color(0xFFDC2626), size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              authState.errorMessage!,
                              style: const TextStyle(
                                color: Color(0xFF991B1B),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, size: 16, color: Color(0xFF991B1B)),
                            onPressed: () => ref.read(authStateProvider.notifier).clearError(),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                    ),

                  // Card containing the form
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFE4BEB8).withValues(alpha: 0.6)),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.03),
                          blurRadius: 10,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: _isSignUp ? _buildSignUpForm(isLoading) : _buildSignInForm(isLoading),
                  ),

                  const SizedBox(height: 16),

                  // Skip / Browse as Guest Button
                  Center(
                    child: TextButton.icon(
                      onPressed: () => context.go(RouteNames.jobs),
                      icon: const Icon(Icons.arrow_forward_rounded, size: 16, color: Color(0xFF5B403C)),
                      label: const Text(
                        'Browse Live Vacancies as Guest',
                        style: TextStyle(
                          color: Color(0xFF5B403C),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================
  // SIGN IN VIEW
  // ==========================================
  Widget _buildSignInForm(bool isLoading) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Sign In to Your Portal',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1E1B1B),
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Access saved applications, visa tracking & AI Vault',
          style: TextStyle(fontSize: 12, color: Color(0xFF5B403C)),
        ),
        const SizedBox(height: 16),

        // Quick Seeded Account Autofill Card
        InkWell(
          onTap: _fillDemoAccount,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF0FDF4),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFBBF7D0)),
            ),
            child: const Row(
              children: [
                Icon(Icons.bolt_rounded, color: Color(0xFF16A34A), size: 18),
                SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '1-Tap Seeded Account (Neon DB)',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF15803D),
                        ),
                      ),
                      Text(
                        'candidate@suhana-global.com / Secret123!',
                        style: TextStyle(fontSize: 10, color: Color(0xFF166534)),
                      ),
                    ],
                  ),
                ),
                Text(
                  'Auto-fill',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF16A34A),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Email Field
        const Text(
          'Email Address',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF1E1B1B)),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: _signInEmailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: 'name@example.com',
            prefixIcon: const Icon(Icons.email_outlined, size: 20, color: Color(0xFF8F706B)),
            filled: true,
            fillColor: const Color(0xFFFAFAFA),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE4BEB8)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE4BEB8)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF990000), width: 1.6),
            ),
          ),
        ),

        const SizedBox(height: 14),

        // Password Field
        const Text(
          'Password',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF1E1B1B)),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: _signInPasswordController,
          obscureText: _signInObscure,
          decoration: InputDecoration(
            hintText: '••••••••',
            prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20, color: Color(0xFF8F706B)),
            suffixIcon: IconButton(
              icon: Icon(
                _signInObscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                size: 20,
                color: const Color(0xFF8F706B),
              ),
              onPressed: () => setState(() => _signInObscure = !_signInObscure),
            ),
            filled: true,
            fillColor: const Color(0xFFFAFAFA),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE4BEB8)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE4BEB8)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF990000), width: 1.6),
            ),
          ),
        ),

        const SizedBox(height: 20),

        // Submit Sign In Button
        ElevatedButton(
          onPressed: isLoading ? null : _handleSignIn,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF990000),
            foregroundColor: Colors.white,
            minimumSize: const Size.fromHeight(48),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 1,
          ),
          child: isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
              : const Text(
                  'Sign In to Your Account',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                ),
        ),

        const SizedBox(height: 10),

        // Offline Demo Mode Button
        OutlinedButton.icon(
          onPressed: isLoading ? null : _handleDemoLogin,
          icon: const Icon(Icons.offline_bolt_outlined, size: 16),
          label: const Text('Continue in Offline Demo Mode', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFF5B403C),
            side: const BorderSide(color: Color(0xFFE4BEB8)),
            minimumSize: const Size.fromHeight(40),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),

        const SizedBox(height: 16),

        // New User -> Create One Option
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'New user? ',
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFF5B403C),
                fontWeight: FontWeight.w500,
              ),
            ),
            InkWell(
              onTap: () {
                ref.read(authStateProvider.notifier).clearError();
                setState(() => _isSignUp = true);
              },
              borderRadius: BorderRadius.circular(4),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                child: Text(
                  'Create one',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF990000),
                    decoration: TextDecoration.underline,
                    decorationColor: Color(0xFF990000),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ==========================================
  // SIGN UP VIEW
  // ==========================================
  Widget _buildSignUpForm(bool isLoading) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Create Candidate Profile',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1E1B1B),
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Fast-track your application to top GCC & global employers',
          style: TextStyle(fontSize: 12, color: Color(0xFF5B403C)),
        ),
        const SizedBox(height: 16),

        // Full Name Field
        const Text(
          'Full Legal Name (as on Passport)',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF1E1B1B)),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: _signUpNameController,
          decoration: InputDecoration(
            hintText: 'e.g. John Doe',
            prefixIcon: const Icon(Icons.person_outline_rounded, size: 20, color: Color(0xFF8F706B)),
            filled: true,
            fillColor: const Color(0xFFFAFAFA),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE4BEB8)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF990000), width: 1.6),
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Email Field
        const Text(
          'Email Address',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF1E1B1B)),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: _signUpEmailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: 'name@example.com',
            prefixIcon: const Icon(Icons.email_outlined, size: 20, color: Color(0xFF8F706B)),
            filled: true,
            fillColor: const Color(0xFFFAFAFA),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE4BEB8)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF990000), width: 1.6),
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Phone Number Field with Country Code Picker
        const Text(
          'Mobile / WhatsApp Contact',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF1E1B1B)),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFFAFAFA),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE4BEB8)),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedCountryCode,
                  items: _countryCodes.map((item) {
                    return DropdownMenuItem<String>(
                      value: item['code'],
                      child: Text(
                        '${item['flag']} ${item['code']}',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedCountryCode = val);
                  },
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _signUpPhoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: '550123456',
                  filled: true,
                  fillColor: const Color(0xFFFAFAFA),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE4BEB8)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF990000), width: 1.6),
                  ),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // Password Field
        const Text(
          'Password (min. 6 characters)',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF1E1B1B)),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: _signUpPasswordController,
          obscureText: _signUpObscure,
          decoration: InputDecoration(
            hintText: '••••••••',
            prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20, color: Color(0xFF8F706B)),
            suffixIcon: IconButton(
              icon: Icon(
                _signUpObscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                size: 20,
                color: const Color(0xFF8F706B),
              ),
              onPressed: () => setState(() => _signUpObscure = !_signUpObscure),
            ),
            filled: true,
            fillColor: const Color(0xFFFAFAFA),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE4BEB8)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF990000), width: 1.6),
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Terms Agreement Checkbox
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(
              value: _agreeToTerms,
              activeColor: const Color(0xFF990000),
              onChanged: (v) => setState(() => _agreeToTerms = v ?? true),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            const Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Text(
                  'I agree to the MENA Data Privacy Policy and authorize Suhana for visa & recruitment screening.',
                  style: TextStyle(fontSize: 11, color: Color(0xFF5B403C)),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Submit Sign Up Button
        ElevatedButton(
          onPressed: isLoading ? null : _handleSignUp,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF990000),
            foregroundColor: Colors.white,
            minimumSize: const Size.fromHeight(48),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 1,
          ),
          child: isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
              : const Text(
                  'Create Candidate Account',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                ),
        ),

        const SizedBox(height: 16),

        // Already have an account? Sign In Option
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Already have an account? ',
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFF5B403C),
                fontWeight: FontWeight.w500,
              ),
            ),
            InkWell(
              onTap: () {
                ref.read(authStateProvider.notifier).clearError();
                setState(() => _isSignUp = false);
              },
              borderRadius: BorderRadius.circular(4),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                child: Text(
                  'Sign In',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF990000),
                    decoration: TextDecoration.underline,
                    decorationColor: Color(0xFF990000),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
