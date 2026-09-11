import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/serverpod_service.dart';
import '../theme/app_theme.dart';
import 'articles_manager.dart';
import 'highlights_manager.dart';
import 'inquiries_viewer.dart';

/// Main layout for the Waitaminute Digital Admin Control Center.
class AdminLayout extends StatefulWidget {
  final VoidCallback onLock;

  const AdminLayout({
    super.key,
    required this.onLock,
  });

  @override
  State<AdminLayout> createState() => _AdminLayoutState();
}

class _AdminLayoutState extends State<AdminLayout> with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final ServerpodService _serverpod = ServerpodService.instance;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xFF0A0A0C),
            border: Border(
              bottom: BorderSide(color: Color(0xFF1F1E24), width: 1),
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  // Mascot avatar
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFF16161E),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppTheme.neonCyan.withValues(alpha: 0.35),
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
                  const SizedBox(width: 10),

                  Text(
                    'W/M CONTROL',
                    style: GoogleFonts.spaceGrotesk(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppTheme.neonViolet.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'ADMIN',
                      style: GoogleFonts.spaceMono(
                        color: AppTheme.neonViolet,
                        fontSize: 9.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),

                  const Spacer(),

                  // Connection status indicator
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF14141A),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: const Color(0xFF26262B)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _serverpod.isConnected
                                ? AppTheme.neonGreen
                                : AppTheme.neonAmber,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _serverpod.isConnected ? 'LIVE BACKEND' : 'OFFLINE SANDBOX',
                          style: GoogleFonts.spaceMono(
                            color: _serverpod.isConnected
                                ? AppTheme.neonGreen
                                : AppTheme.neonAmber,
                            fontSize: 9.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Lock PIN button
                  IconButton(
                    icon: const Icon(Icons.lock_outline_rounded, size: 18, color: Colors.white70),
                    tooltip: 'Lock Admin Gate',
                    onPressed: widget.onLock,
                  ),

                  IconButton(
                    icon: const Icon(Icons.exit_to_app_rounded, size: 18, color: AppTheme.neonCyan),
                    tooltip: 'Exit to Public Site',
                    onPressed: () {
                      if (Navigator.of(context).canPop()) {
                        Navigator.of(context).pop();
                      } else {
                        Navigator.of(context).pushReplacementNamed('/');
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Section Tabs Bar
          Container(
            color: const Color(0xFF101015),
            child: TabBar(
              controller: _tabController,
              indicatorColor: AppTheme.neonCyan,
              indicatorWeight: 2,
              labelColor: AppTheme.neonCyan,
              unselectedLabelColor: const Color(0xFF94A3B8),
              labelStyle: GoogleFonts.spaceMono(fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 0.9),
              tabs: const [
                Tab(
                  icon: Icon(Icons.article_outlined, size: 18),
                  text: 'Dispatches',
                ),
                Tab(
                  icon: Icon(Icons.view_carousel_outlined, size: 18),
                  text: 'Highlights',
                ),
                Tab(
                  icon: Icon(Icons.inbox_outlined, size: 18),
                  text: 'Inquiries',
                ),
              ],
            ),
          ),

          // Tab Views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                ArticlesManager(),
                HighlightsManager(),
                InquiriesViewer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
