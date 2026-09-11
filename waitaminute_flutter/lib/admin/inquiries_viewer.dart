import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waitaminute_serverpod_client/waitaminute_serverpod_client.dart';
import '../services/serverpod_service.dart';
import '../theme/app_theme.dart';

/// Admin viewer for prospect lead inquiries submitted via the Discovery intake form.
class InquiriesViewer extends StatefulWidget {
  const InquiriesViewer({super.key});

  @override
  State<InquiriesViewer> createState() => _InquiriesViewerState();
}

class _InquiriesViewerState extends State<InquiriesViewer> {
  final ServerpodService _service = ServerpodService.instance;
  List<LeadInquiry> _inquiries = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadInquiries();
  }

  Future<void> _loadInquiries() async {
    setState(() => _isLoading = true);
    final list = await _service.fetchInquiries();
    if (mounted) {
      setState(() {
        _inquiries = list;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Action Bar
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          child: Row(
            children: [
              Text(
                'DISCOVERY INQUIRIES (${_inquiries.length})',
                style: GoogleFonts.spaceGrotesk(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.1,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.refresh_rounded, color: AppTheme.neonCyan, size: 20),
                tooltip: 'Refresh Inquiries',
                onPressed: _loadInquiries,
              ),
            ],
          ),
        ),

        // Inquiries List
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator(color: AppTheme.neonCyan))
              : _inquiries.isEmpty
                  ? Center(
                      child: Text(
                        'No client inquiries yet.',
                        style: GoogleFonts.inter(color: AppTheme.textMuted),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                      itemCount: _inquiries.length,
                      itemBuilder: (context, index) {
                        final inquiry = _inquiries[index];
                        return _buildInquiryCard(inquiry);
                      },
                    ),
        ),
      ],
    );
  }

  Widget _buildInquiryCard(LeadInquiry inquiry) {
    final dateStr = '${inquiry.createdAt.month}/${inquiry.createdAt.day}/${inquiry.createdAt.year}';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF14141A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF26262B)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Name + Project Type badge + Date
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppTheme.neonCyan.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        inquiry.name.isNotEmpty ? inquiry.name[0].toUpperCase() : '?',
                        style: GoogleFonts.spaceMono(
                          color: AppTheme.neonCyan,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        inquiry.name,
                        style: GoogleFonts.spaceGrotesk(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        inquiry.email,
                        style: GoogleFonts.spaceMono(
                          color: AppTheme.neonCyan,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppTheme.neonViolet.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: AppTheme.neonViolet.withValues(alpha: 0.4),
                      ),
                    ),
                    child: Text(
                      inquiry.projectType.toUpperCase(),
                      style: GoogleFonts.spaceMono(
                        color: AppTheme.neonViolet,
                        fontSize: 9.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dateStr,
                    style: GoogleFonts.spaceMono(
                      color: AppTheme.textMuted,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Message
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF0F0F14),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFF1E1E24)),
            ),
            child: Text(
              inquiry.message,
              style: GoogleFonts.inter(
                color: const Color(0xFFCBD5E1),
                fontSize: 13,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
