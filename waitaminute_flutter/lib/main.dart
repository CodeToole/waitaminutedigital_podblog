import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waitaminute_serverpod_client/waitaminute_serverpod_client.dart';
import 'admin/admin_auth_gate.dart';
import 'screens/article_reader_screen.dart';
import 'services/serverpod_service.dart';
import 'theme/app_theme.dart';
import 'widgets/article_card.dart';
import 'widgets/lead_intake_modal.dart';
import 'widgets/peeking_carousel.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const WaitaminuteApp());
}

class WaitaminuteApp extends StatelessWidget {
  const WaitaminuteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Waitaminute Digital',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
          PointerDeviceKind.trackpad,
          PointerDeviceKind.stylus,
        },
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/admin': (context) => const AdminAuthGate(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/admin') {
          return MaterialPageRoute(
            builder: (_) => const AdminAuthGate(),
            settings: settings,
          );
        }
        if (settings.name != null && settings.name!.startsWith('/article/')) {
          final slug = settings.name!.replaceFirst('/article/', '');
          return MaterialPageRoute(
            builder: (_) => ArticleReaderScreen(
              article: settings.arguments as Article?,
              slug: slug,
            ),
            settings: settings,
          );
        }
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
          settings: settings,
        );
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ServerpodService _serverpod = ServerpodService.instance;

  List<ProjectHighlight> _highlights = [];
  List<Article> _articles = [];
  bool _isLoading = true;
  String _selectedCategory = 'ALL';

  final List<String> _categories = [
    'ALL',
    'ARCHITECTURE',
    'POST-MORTEM',
    'SHIPPED',
    'DEVLOG',
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    final highlights = await _serverpod.fetchFeaturedProjects();
    final articles = await _serverpod.fetchArticles(
      category: _selectedCategory == 'ALL' ? null : _selectedCategory,
    );

    if (mounted) {
      setState(() {
        _highlights = highlights;
        _articles = articles;
        _isLoading = false;
      });
    }
  }

  void _onCategorySelected(String category) {
    if (_selectedCategory == category) return;
    setState(() {
      _selectedCategory = category;
    });
    _loadArticlesOnly();
  }

  Future<void> _loadArticlesOnly() async {
    final articles = await _serverpod.fetchArticles(
      category: _selectedCategory == 'ALL' ? null : _selectedCategory,
    );
    if (mounted) {
      setState(() {
        _articles = articles;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(64),
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFF0A0A0C),
                border: Border(
                  bottom: BorderSide(
                    color: Color(0xFF1F1E24),
                    width: 1,
                  ),
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      // 1. Robot Mascot Avatar Icon (Pure Visual Branding)
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: const Color(0xFF16161E),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: AppTheme.neonCyan.withValues(alpha: 0.35),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.neonCyan.withValues(alpha: 0.15),
                              blurRadius: 8,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(9),
                          child: Image.asset(
                            'assets/img/mascot_head.png',
                            fit: BoxFit.cover,
                            height: 36,
                            width: 36,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),

                      // Brand Headline & Subtitle
                      Text(
                        'WAITAMINUTE',
                        style: GoogleFonts.spaceGrotesk(
                          color: AppTheme.textPrimary,
                          fontSize: screenWidth < 380 ? 15 : 17,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.3,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppTheme.neonCyan.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'EDITORIAL',
                          style: GoogleFonts.spaceMono(
                            color: AppTheme.neonCyan,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.1,
                          ),
                        ),
                      ),

                      const Spacer(),

                      // Primary CTA Button: Smooth pill with violet-to-cyan gradient
                      Container(
                        height: 38,
                        decoration: BoxDecoration(
                          gradient: AppTheme.buttonGradient,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.neonViolet.withValues(alpha: 0.35),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(24),
                            onTap: () => LeadIntakeModal.show(context),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 14),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.auto_awesome,
                                    size: 14,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    screenWidth < 460 ? 'Connect' : 'Book a Call',
                                    style: GoogleFonts.spaceMono(
                                      color: Colors.white,
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.8,
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
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppTheme.neonCyan),
            )
          : RefreshIndicator(
              color: AppTheme.neonCyan,
              backgroundColor: AppTheme.surfaceElevated,
              onRefresh: _loadData,
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                slivers: [
                  // Serverpod Connection Status Pill
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                      child: Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _serverpod.isConnected
                                  ? AppTheme.neonGreen
                                  : AppTheme.neonAmber,
                              boxShadow: [
                                BoxShadow(
                                  color: (_serverpod.isConnected
                                          ? AppTheme.neonGreen
                                          : AppTheme.neonAmber)
                                      .withValues(alpha: 0.6),
                                  blurRadius: 6,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _serverpod.isConnected
                                ? 'SERVERPOD BACKEND CONNECTED'
                                : 'LOCAL SANDBOX / OFFLINE FALLBACK',
                            style: GoogleFonts.spaceMono(
                              color: _serverpod.isConnected
                                  ? AppTheme.neonGreen
                                  : AppTheme.textMuted,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Hero Section: Official Mascot Editorial Guide & Modern Work Systems Headline
                  SliverToBoxAdapter(
                    child: _buildHeroSection(context, screenWidth),
                  ),

                  const SliverToBoxAdapter(
                    child: SizedBox(height: 24),
                  ),

                  // Section Header 1: Featured Projects & Devlogs
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 6, 16, 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'FEATURED HIGHLIGHTS',
                            style: GoogleFonts.spaceGrotesk(
                              color: AppTheme.textPrimary,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.2,
                            ),
                          ),
                          Text(
                            '${_highlights.length} CASE STUDIES',
                            style: GoogleFonts.spaceMono(
                              color: AppTheme.textMuted,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Full-Bleed IGN Peeking Card Carousel (380px)
                  SliverToBoxAdapter(
                    child: PeekingCarousel(
                      highlights: _highlights,
                      onCardTap: (project) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: AppTheme.surfaceElevated,
                            content: Text(
                              'Viewing: ${project.title}',
                              style: GoogleFonts.spaceMono(
                                color: AppTheme.neonCyan,
                                fontSize: 12,
                              ),
                            ),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                    ),
                  ),

                  const SliverToBoxAdapter(
                    child: SizedBox(height: 32),
                  ),

                  // Section Header 2: Editorial Articles
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'EDITORIAL DISPATCHES',
                            style: GoogleFonts.spaceGrotesk(
                              color: AppTheme.textPrimary,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.2,
                            ),
                          ),
                          Text(
                            '${_articles.length} ARTICLES',
                            style: GoogleFonts.spaceMono(
                              color: AppTheme.textMuted,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Horizontal Category Pills Filter
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 42,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _categories.length,
                        itemBuilder: (context, index) {
                          final category = _categories[index];
                          final isSelected = _selectedCategory == category;
                          final accent = AppTheme.badgeColor(category);

                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: FilterChip(
                              label: Text(
                                category,
                                style: GoogleFonts.spaceMono(
                                  color: isSelected
                                      ? Colors.black
                                      : const Color(0xFF94A3B8),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.9,
                                ),
                              ),
                              selected: isSelected,
                              onSelected: (_) => _onCategorySelected(category),
                              backgroundColor: AppTheme.surface,
                              selectedColor: isSelected ? accent : AppTheme.surface,
                              side: BorderSide(
                                color: isSelected ? accent : const Color(0xFF26262B),
                                width: 1,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              showCheckmark: false,
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  const SliverToBoxAdapter(
                    child: SizedBox(height: 12),
                  ),

                  // Editorial Article List
                  _articles.isEmpty
                      ? SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.all(36),
                            child: Center(
                              child: Text(
                                'No articles found in this category.',
                                style: GoogleFonts.inter(
                                  color: AppTheme.textMuted,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                        )
                      : SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final article = _articles[index];
                              return ArticleCard(
                                article: article,
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => ArticleReaderScreen(article: article),
                                      settings: RouteSettings(name: '/article/${article.slug}'),
                                    ),
                                  );
                                },
                              );
                            },
                            childCount: _articles.length,
                          ),
                        ),

                  const SliverToBoxAdapter(
                    child: SizedBox(height: 32),
                  ),

                  // Footer: Clean Branding Text
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                      child: Center(
                        child: Text(
                          '© 2026 WAITAMINUTE DIGITAL • ALL RIGHTS RESERVED',
                          style: GoogleFonts.spaceMono(
                            color: AppTheme.textMuted.withValues(alpha: 0.6),
                            fontSize: 10,
                            letterSpacing: 1.1,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SliverToBoxAdapter(
                    child: SizedBox(height: 32),
                  ),
                ],
              ),
            ),
    );
  }

  /// Hero Section featuring the Robot Mascot alongside the main headline
  Widget _buildHeroSection(BuildContext context, double screenWidth) {
    final isDesktop = screenWidth >= 768;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF111115),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF26262B), width: 1),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF161522),
            Color(0xFF101014),
          ],
        ),
      ),
      child: isDesktop
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 6,
                  child: _buildHeroTextContent(context),
                ),
                const SizedBox(width: 24),
                Expanded(
                  flex: 4,
                  child: _buildMascotVisualCard(context, height: 280),
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeroTextContent(context),
                const SizedBox(height: 20),
                _buildMascotVisualCard(context, height: 220),
              ],
            ),
    );
  }

  Widget _buildHeroTextContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Eyebrow matching waitaminutedigital.com
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.neonCyan,
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                'BUILT FOR CREATORS. ENGINEERED FOR MODERN WORK.',
                style: GoogleFonts.spaceMono(
                  color: AppTheme.neonCyan,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Headline in Space Grotesk
        Text(
          'We architect modern work systems that turn effort into momentum.',
          style: GoogleFonts.spaceGrotesk(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w700,
            height: 1.2,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 12),

        // Body Text in Inter
        Text(
          'Waitaminute Digital helps founders and teams modernize their web presence, automate operations, and turn customer interest into qualified follow-up.',
          style: GoogleFonts.inter(
            color: const Color(0xFFCBD5E1),
            fontSize: 13.5,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 20),

        // Dual CTA Buttons
        Wrap(
          spacing: 12,
          runSpacing: 10,
          children: [
            // Primary Pill: Violet-to-cyan gradient
            Container(
              height: 44,
              decoration: BoxDecoration(
                gradient: AppTheme.buttonGradient,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.neonViolet.withValues(alpha: 0.4),
                    blurRadius: 14,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(24),
                  onTap: () => LeadIntakeModal.show(context),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Center(
                      child: Text(
                        'Book a Discovery Call',
                        style: GoogleFonts.spaceMono(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Secondary Outlined Pill: Explore Services
            Container(
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFF16161D),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: const Color(0xFF26262B),
                  width: 1,
                ),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(24),
                  onTap: () {
                    // Quick scroll down to articles
                    _onCategorySelected('ALL');
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Center(
                      child: Text(
                        'Explore Dispatches',
                        style: GoogleFonts.spaceMono(
                          color: const Color(0xFFCBD5E1),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Feature Tags
        Wrap(
          spacing: 10,
          runSpacing: 6,
          children: [
            _buildFeatureBadge('Azure-ready builds'),
            _buildFeatureBadge('Serverpod telemetry'),
            _buildFeatureBadge('Conversion-first design'),
          ],
        ),
      ],
    );
  }

  Widget _buildFeatureBadge(String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.check_circle_outline, size: 12, color: AppTheme.neonCyan),
        const SizedBox(width: 4),
        Text(
          text,
          style: GoogleFonts.inter(
            color: AppTheme.textMuted,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildMascotVisualCard(BuildContext context, {required double height}) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFF0D0D12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF26262B),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.neonViolet.withValues(alpha: 0.15),
            blurRadius: 20,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background subtle ambient glow
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.neonViolet.withValues(alpha: 0.25),
                  blurRadius: 50,
                  spreadRadius: 20,
                ),
              ],
            ),
          ),

          // Robot Mascot Image
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Image.asset(
              'assets/img/mascot.png',
              fit: BoxFit.contain,
            ),
          ),

          // Top badge
          Positioned(
            top: 12,
            right: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xE60A0A0C),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: AppTheme.neonCyan.withValues(alpha: 0.4),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.neonCyan,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    'EDITORIAL GUIDE',
                    style: GoogleFonts.spaceMono(
                      color: AppTheme.neonCyan,
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.9,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom floating info
          Positioned(
            bottom: 10,
            left: 12,
            right: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xE60A0A0C),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color(0xFF26262B),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'STATUS: ACTIVE',
                    style: GoogleFonts.spaceMono(
                      color: AppTheme.neonGreen,
                      fontSize: 9.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.0,
                    ),
                  ),
                  Text(
                    'SYS.V2.4',
                    style: GoogleFonts.spaceMono(
                      color: AppTheme.textMuted,
                      fontSize: 9.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
