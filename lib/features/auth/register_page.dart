import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:chatapp/core/app_routes.dart';
import 'Package:chatapp/core/app_theme.dart';
import 'package:chatapp/core/auth_widgets.dart';
import 'package:chatapp/features/shell/shell_page.dart';

/// Registration page with Name, Email, Password, Confirm Password fields.
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _isLoading = false;

  late final AnimationController _enterCtrl;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _enterCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();

    _fadeAnim = CurvedAnimation(
      parent: _enterCtrl,
      curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
    );

    _slideAnim = Tween<Offset>(
      begin: const Offset(0.08, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _enterCtrl,
        curve: const Interval(0.0, 0.8, curve: Curves.easeOutCubic),
      ),
    );
  }

  @override
  void dispose() {
    _enterCtrl.dispose();
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  // ── Actions ─────────────────────────────────────────────────────────────────

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isLoading = true);
    HapticFeedback.lightImpact();

    await Future.delayed(const Duration(milliseconds: 1500));

    if (!mounted) return;
    setState(() => _isLoading = false);

    Navigator.of(context).pushAndRemoveUntil(
      fadeRoute(const ShellPage()),
      (_) => false,
    );
  }

  // ── Build ───────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: FadeTransition(
            opacity: _fadeAnim,
            child: SlideTransition(
              position: _slideAnim,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
                child: Column(
                  children: [
                    SizedBox(height: topPad * 0.2),

                    // ── Logo ──────────────────────────────────────────────────
                    _RegisterLogoSection(),

                    const SizedBox(height: 32),

                    // ── Card ──────────────────────────────────────────────────
                    _RegisterCard(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Register',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.dmSans(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                                letterSpacing: -0.5,
                              ),
                            ),

                            const SizedBox(height: 4),
                            _ThinDivider(),
                            const SizedBox(height: 22),

                            // Name
                            AuthTextField(
                              label: 'Name',
                              controller: _nameCtrl,
                              prefixIcon: Icons.person_outline_rounded,
                              keyboardType: TextInputType.name,
                              textInputAction: TextInputAction.next,
                              autofocus: true,
                              validator: (v) {
                                if (v == null || v.trim().isEmpty) {
                                  return 'Name is required';
                                }
                                if (v.trim().length < 2) {
                                  return 'Name too short';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 14),

                            // Email
                            AuthTextField(
                              label: 'Email',
                              controller: _emailCtrl,
                              prefixIcon: Icons.alternate_email_rounded,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              validator: (v) {
                                if (v == null || v.trim().isEmpty) {
                                  return 'Email is required';
                                }
                                if (!v.contains('@') || !v.contains('.')) {
                                  return 'Enter a valid email';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 14),

                            // Password
                            AuthTextField(
                              label: 'Password',
                              controller: _passwordCtrl,
                              obscureText: true,
                              prefixIcon: Icons.lock_outline_rounded,
                              textInputAction: TextInputAction.next,
                              validator: (v) {
                                if (v == null || v.isEmpty) {
                                  return 'Password is required';
                                }
                                if (v.length < 6) {
                                  return 'Minimum 6 characters';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 14),

                            // Confirm Password
                            AuthTextField(
                              label: 'Confirm Password',
                              controller: _confirmCtrl,
                              obscureText: true,
                              prefixIcon: Icons.lock_person_outlined,
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (_) => _submit(),
                              validator: (v) {
                                if (v == null || v.isEmpty) {
                                  return 'Please confirm your password';
                                }
                                if (v != _passwordCtrl.text) {
                                  return 'Passwords do not match';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 8),
                            _ThinDivider(),
                            const SizedBox(height: 20),

                            // Sign Up button
                            AuthPrimaryButton(
                              label: 'Sign Up',
                              onTap: _submit,
                              isLoading: _isLoading,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ── Login link ─────────────────────────────────────────────
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: RichText(
                        text: TextSpan(
                          text: 'Already have an account? ',
                          style: GoogleFonts.dmSans(
                            fontSize: 13,
                            color: AppColors.textMuted,
                          ),
                          children: [
                            TextSpan(
                              text: 'Sign In',
                              style: GoogleFonts.dmSans(
                                fontSize: 13,
                                color: AppColors.primaryAccent,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Local sub-widgets
// ─────────────────────────────────────────────────────────────────────────────

class _RegisterLogoSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.surfaceSecondary,
            border: Border.all(
              color: AppColors.primaryAccent.withOpacity(0.3),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryAccent.withOpacity(0.1),
                blurRadius: 20,
                spreadRadius: 3,
              ),
            ],
          ),
          child: const Icon(
            Icons.bolt_rounded,
            color: AppColors.primaryAccent,
            size: 30,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'ChatApp',
          style: GoogleFonts.dmSans(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
            letterSpacing: -0.8,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Create your account',
          style: GoogleFonts.dmSans(
            fontSize: 13,
            color: AppColors.textMuted,
          ),
        ),
      ],
    );
  }
}

class _RegisterCard extends StatelessWidget {
  const _RegisterCard({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 26),
      decoration: BoxDecoration(
        color: AppColors.surfaceSecondary,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderSubtle, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.35),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _ThinDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Container(height: 1, color: AppColors.borderSubtle);
}
