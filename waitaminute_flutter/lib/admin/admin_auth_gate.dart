import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import 'admin_layout.dart';

/// Editorial authorization gate protecting access to the admin dashboard.
class AdminAuthGate extends StatefulWidget {
  const AdminAuthGate({super.key});

  @override
  State<AdminAuthGate> createState() => _AdminAuthGateState();
}

class _AdminAuthGateState extends State<AdminAuthGate>
    with SingleTickerProviderStateMixin {
  final TextEditingController _pinController = TextEditingController();
  late final AnimationController _shakeController;
  late final Animation<double> _shakeAnimation;

  bool _isAuthenticated = false;
  bool _isProcessing = false;
  bool _obscureText = true;
  String? _errorMessage;

  // Master authorization credentials
  static const String _primaryPin = '84920173';
  static const String _primaryPassphrase = 'waitaminutedigital-secure';

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 450),
      vsync: this,
    );

    _shakeAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -12.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -12.0, end: 12.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 12.0, end: -8.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -8.0, end: 8.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 8.0, end: -4.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -4.0, end: 0.0), weight: 1),
    ]).animate(CurvedAnimation(
      parent: _shakeController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _shakeController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  Future<void> _verifyAccess() async {
    if (_isProcessing) return;

    // Sanitize input: strip all whitespace and invisible zero-width unicode characters
    final rawInput = _pinController.text;
    final sanitized = rawInput.trim().replaceAll(RegExp(r'[\s\u200B-\u200D\uFEFF]'), '');

    if (sanitized.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter an authorization key.';
      });
      return;
    }

    setState(() {
      _isProcessing = true;
      _errorMessage = null;
    });

    // Check against authorized credentials
    final isMatch = sanitized == _primaryPin ||
        sanitized.toLowerCase() == _primaryPassphrase.toLowerCase();

    if (isMatch) {
      setState(() {
        _isAuthenticated = true;
        _errorMessage = null;
        _isProcessing = false;
      });
    } else {
      // Trigger shake animation and throttling delay
      _shakeController.forward(from: 0.0);
      await Future.delayed(const Duration(milliseconds: 400));
      if (!mounted) return;

      setState(() {
        _errorMessage = 'Invalid authorization key. Access denied.';
        _isProcessing = false;
      });
    }
  }

  void _lock() {
    setState(() {
      _isAuthenticated = false;
      _pinController.clear();
      _errorMessage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isAuthenticated) {
      return AdminLayout(onLock: _lock);
    }

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0A0C),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white70),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              Navigator.of(context).pushReplacementNamed('/');
            }
          },
          tooltip: 'Back to Site',
        ),
        title: Text(
          'ADMIN AUTHENTICATION',
          style: GoogleFonts.spaceGrotesk(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.1,
          ),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: Color(0xFF1F1E24)),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: AnimatedBuilder(
              animation: _shakeAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(_shakeAnimation.value, 0),
                  child: child,
                );
              },
              child: Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: const Color(0xFF121216),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFF26262B), width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.neonViolet.withValues(alpha: 0.12),
                      blurRadius: 30,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Robot Mascot Avatar
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1A24),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppTheme.neonCyan.withValues(alpha: 0.5),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.neonCyan.withValues(alpha: 0.25),
                            blurRadius: 18,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/img/mascot_head.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Headline
                    Text(
                      'EDITORIAL CONTROL GATE',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Subtitle (Sanitized - unrevealing prompt)
                    Text(
                      'Enter authorization key to access the editorial control center.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: const Color(0xFF94A3B8),
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 28),

                    // PIN / Key Input Field
                    TextField(
                      controller: _pinController,
                      obscureText: _obscureText,
                      autofocus: true,
                      enabled: !_isProcessing,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.spaceMono(
                        color: Colors.white,
                        fontSize: 20,
                        letterSpacing: _obscureText ? 6.0 : 2.0,
                        fontWeight: FontWeight.w700,
                      ),
                      decoration: InputDecoration(
                        hintText: _obscureText ? '••••••••' : 'Enter PIN / key',
                        hintStyle: GoogleFonts.spaceMono(
                          color: AppTheme.textMuted,
                          letterSpacing: _obscureText ? 6.0 : 1.0,
                          fontSize: 16,
                        ),
                        filled: true,
                        fillColor: const Color(0xFF181820),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFF26262B)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppTheme.neonCyan, width: 1.5),
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                            color: const Color(0xFF94A3B8),
                            size: 20,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                          tooltip: _obscureText ? 'Show key' : 'Hide key',
                        ),
                      ),
                      onSubmitted: (_) => _verifyAccess(),
                    ),

                    if (_errorMessage != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        _errorMessage!,
                        style: GoogleFonts.spaceMono(
                          color: AppTheme.neonMagenta,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],

                    const SizedBox(height: 24),

                    // Unlock CTA Button (Gradient Pill)
                    Container(
                      width: double.infinity,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: AppTheme.buttonGradient,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.neonViolet.withValues(alpha: 0.35),
                            blurRadius: 16,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(24),
                          onTap: _isProcessing ? null : _verifyAccess,
                          child: Center(
                            child: _isProcessing
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.lock_open_rounded, size: 16, color: Colors.white),
                                      const SizedBox(width: 8),
                                      Text(
                                        'UNLOCK CONTROL CENTER',
                                        style: GoogleFonts.spaceMono(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 1.1,
                                        ),
                                      ),
                                    ],
                                  ),
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
      ),
    );
  }
}
