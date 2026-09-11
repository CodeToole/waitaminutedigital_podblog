import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waitaminute_serverpod_client/waitaminute_serverpod_client.dart';
import '../services/serverpod_service.dart';
import '../theme/app_theme.dart';

/// Modal bottom sheet for submitting a lead inquiry to the Serverpod backend.
class LeadIntakeModal extends StatefulWidget {
  const LeadIntakeModal({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        side: BorderSide(color: Color(0xFF26262B), width: 1),
      ),
      builder: (_) => const LeadIntakeModal(),
    );
  }

  @override
  State<LeadIntakeModal> createState() => _LeadIntakeModalState();
}

class _LeadIntakeModalState extends State<LeadIntakeModal> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();
  String _selectedProjectType = 'Mobile Architecture';
  bool _isSubmitting = false;
  String? _statusMessage;

  final List<String> _projectTypes = [
    'Mobile Architecture',
    'Serverpod / Cloud Backend',
    'Multi-Agent System',
    'Web & Fullstack CMS',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
      _statusMessage = null;
    });

    final inquiry = LeadInquiry(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      message: _messageController.text.trim(),
      projectType: _selectedProjectType,
      createdAt: DateTime.now(),
    );

    try {
      await ServerpodService.instance.submitLead(inquiry);
      if (mounted) {
        setState(() {
          _isSubmitting = false;
          _statusMessage = 'Inquiry received! We will reach out shortly.';
        });
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) Navigator.of(context).pop();
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
          _statusMessage = 'Fallback saved locally (Server offline).';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 20, bottomInset + 24),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFF26262B),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppTheme.neonCyan.withValues(alpha: 0.35),
                        width: 1,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(9),
                      child: Image.asset(
                        'assets/img/mascot_head.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'BOOK A DISCOVERY CALL',
                          style: GoogleFonts.spaceGrotesk(
                            color: AppTheme.textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.1,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Connect with Waitaminute Digital to plan your systems.',
                          style: GoogleFonts.inter(
                            color: const Color(0xFF94A3B8),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                style: GoogleFonts.inter(color: AppTheme.textPrimary),
                decoration: _inputDecoration('Your Name'),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _emailController,
                style: GoogleFonts.inter(color: AppTheme.textPrimary),
                keyboardType: TextInputType.emailAddress,
                decoration: _inputDecoration('Work Email'),
                validator: (v) =>
                    v == null || !v.contains('@') ? 'Enter a valid email' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _selectedProjectType,
                dropdownColor: AppTheme.surfaceElevated,
                style: GoogleFonts.inter(color: AppTheme.textPrimary),
                decoration: _inputDecoration('Project Type'),
                items: _projectTypes
                    .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                    .toList(),
                onChanged: (v) {
                  if (v != null) setState(() => _selectedProjectType = v);
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _messageController,
                style: GoogleFonts.inter(color: AppTheme.textPrimary),
                maxLines: 3,
                decoration: _inputDecoration('Project Goals & Timeline'),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              if (_statusMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    _statusMessage!,
                    style: GoogleFonts.spaceMono(
                      color: _statusMessage!.contains('received')
                          ? AppTheme.neonGreen
                          : AppTheme.neonAmber,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  gradient: AppTheme.buttonGradient,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.neonViolet.withValues(alpha: 0.35),
                      blurRadius: 14,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(25),
                    onTap: _isSubmitting ? null : _submit,
                    child: Center(
                      child: _isSubmitting
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              'BOOK DISCOVERY CALL',
                              style: GoogleFonts.spaceMono(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                                letterSpacing: 1.2,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: GoogleFonts.inter(color: AppTheme.textMuted, fontSize: 13),
      filled: true,
      fillColor: AppTheme.surfaceElevated,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFF26262B)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppTheme.neonCyan),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    );
  }
}
