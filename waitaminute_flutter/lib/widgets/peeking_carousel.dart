import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waitaminute_serverpod_client/waitaminute_serverpod_client.dart';
import '../theme/app_theme.dart';

/// IGN-style horizontal "peeking" full-bleed card feed for featured projects/devlogs.
///
/// Responsive behavior:
/// - Desktop (> 800px): Constrained to sleek 4:5 portrait media cards (~300px width, ~400px height)
///   in a multi-card responsive track with floating circular navigation buttons (< and >).
/// - Mobile / Tablet (<= 800px): Classic peeking viewport (84% width) with native finger swiping.
class PeekingCarousel extends StatefulWidget {
  final List<ProjectHighlight> highlights;
  final Function(ProjectHighlight)? onCardTap;

  const PeekingCarousel({
    super.key,
    required this.highlights,
    this.onCardTap,
  });

  @override
  State<PeekingCarousel> createState() => _PeekingCarouselState();
}

class _PeekingCarouselState extends State<PeekingCarousel> {
  PageController? _pageController;
  double _currentFraction = 0.84;
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  void _ensureController(double targetFraction) {
    if (_pageController == null) {
      _currentFraction = targetFraction;
      _pageController = PageController(
        viewportFraction: _currentFraction,
        initialPage: _currentPage,
      );
    } else if ((_currentFraction - targetFraction).abs() > 0.02) {
      _currentFraction = targetFraction;
      final oldPage = _currentPage;
      final oldController = _pageController;
      _pageController = PageController(
        viewportFraction: _currentFraction,
        initialPage: oldPage,
      );
      WidgetsBinding.instance.addPostFrameCallback((_) {
        oldController?.dispose();
      });
    }
  }

  void _previousPage() {
    if (_pageController != null &&
        _pageController!.hasClients &&
        _currentPage > 0) {
      _pageController!.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _nextPage() {
    if (_pageController != null &&
        _pageController!.hasClients &&
        _currentPage < widget.highlights.length - 1) {
      _pageController!.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.highlights.isEmpty) {
      return const SizedBox.shrink();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final isDesktop = screenWidth > 800;

        // Desktop: ~300px card width within the track
        // Mobile: 0.84 viewport fraction creates peeking adjacent cards
        final targetFraction = isDesktop
            ? (320.0 / screenWidth).clamp(0.18, 0.45)
            : 0.84;

        _ensureController(targetFraction);

        const double carouselHeight = 400.0;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                // Carousel Viewport
                SizedBox(
                  height: carouselHeight,
                  child: PageView.builder(
                    controller: _pageController,
                    padEnds: !isDesktop,
                    itemCount: widget.highlights.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      final project = widget.highlights[index];
                      final isCurrent = index == _currentPage;

                      return Center(
                        child: SizedBox(
                          width: isDesktop ? 300.0 : null,
                          height: carouselHeight - 10,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 260),
                            curve: Curves.easeOutCubic,
                            margin: EdgeInsets.symmetric(
                              horizontal: isDesktop ? 8 : 6,
                              vertical: isCurrent ? 2 : (isDesktop ? 6 : 12),
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isCurrent
                                    ? AppTheme.neonCyan.withValues(alpha: 0.85)
                                    : const Color(0xFF26262B),
                                width: 1,
                              ),
                              boxShadow: isCurrent
                                  ? [
                                      BoxShadow(
                                        color: AppTheme.neonCyan.withValues(alpha: 0.22),
                                        blurRadius: 20,
                                        spreadRadius: 1,
                                        offset: const Offset(0, 4),
                                      ),
                                    ]
                                  : [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.4),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    if (widget.onCardTap != null) {
                                      widget.onCardTap!(project);
                                    }
                                  },
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      // 1. Full-bleed background image or cybernetic gradient
                                      _buildCardBackground(project),

                                      // 2. Continuous linear-gradient overlay from transparent (top 38%) to rgba(10, 10, 12, 0.95)
                                      Container(
                                        decoration: const BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            stops: [0.0, 0.38, 0.72, 1.0],
                                            colors: [
                                              Colors.transparent,
                                              Colors.transparent,
                                              Color(0xCC0A0A0C),
                                              Color(0xF20A0A0C),
                                            ],
                                          ),
                                        ),
                                      ),

                                      // 3. Subtle ambient top-edge highlight
                                      Positioned(
                                        top: 0,
                                        left: 0,
                                        right: 0,
                                        height: 60,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                Colors.black.withValues(alpha: 0.45),
                                                Colors.transparent,
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),

                                      // 4. Category badge and project content floating cleanly over the bottom overlay
                                      Positioned(
                                        left: 18,
                                        right: 18,
                                        bottom: 18,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            // Badge row
                                            Row(
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 4,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: AppTheme.neonViolet.withValues(alpha: 0.22),
                                                    borderRadius: BorderRadius.circular(6),
                                                    border: Border.all(
                                                      color: AppTheme.neonViolet.withValues(alpha: 0.6),
                                                      width: 1,
                                                    ),
                                                  ),
                                                  child: Text(
                                                    project.client.toUpperCase(),
                                                    style: GoogleFonts.spaceMono(
                                                      color: AppTheme.neonViolet,
                                                      fontSize: 10,
                                                      fontWeight: FontWeight.w600,
                                                      letterSpacing: 1.1,
                                                    ),
                                                  ),
                                                ),
                                                if (project.isFeatured) ...[
                                                  const SizedBox(width: 8),
                                                  Container(
                                                    padding: const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 3,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: AppTheme.neonCyan.withValues(alpha: 0.18),
                                                      borderRadius: BorderRadius.circular(4),
                                                      border: Border.all(
                                                        color: AppTheme.neonCyan.withValues(alpha: 0.5),
                                                        width: 1,
                                                      ),
                                                    ),
                                                    child: Text(
                                                      'FEATURED',
                                                      style: GoogleFonts.spaceMono(
                                                        color: AppTheme.neonCyan,
                                                        fontSize: 9,
                                                        fontWeight: FontWeight.w700,
                                                        letterSpacing: 1.0,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ],
                                            ),
                                            const SizedBox(height: 10),

                                            // Project Title in Space Grotesk
                                            Text(
                                              project.title,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.spaceGrotesk(
                                                color: Colors.white,
                                                fontSize: 19,
                                                fontWeight: FontWeight.w700,
                                                height: 1.25,
                                              ),
                                            ),
                                            const SizedBox(height: 8),

                                            // Summary in Inter
                                            Text(
                                              project.summary,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.inter(
                                                color: const Color(0xFFCBD5E1),
                                                fontSize: 12.5,
                                                height: 1.4,
                                              ),
                                            ),
                                            const SizedBox(height: 14),

                                            // View Project Action
                                            Row(
                                              children: [
                                                Text(
                                                  'VIEW PROJECT',
                                                  style: GoogleFonts.spaceMono(
                                                    color: isCurrent
                                                        ? AppTheme.neonCyan
                                                        : AppTheme.textMuted,
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w700,
                                                    letterSpacing: 1.1,
                                                  ),
                                                ),
                                                const SizedBox(width: 6),
                                                Icon(
                                                  Icons.arrow_forward_rounded,
                                                  size: 14,
                                                  color: isCurrent
                                                      ? AppTheme.neonCyan
                                                      : AppTheme.textMuted,
                                                ),
                                              ],
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
                      );
                    },
                  ),
                ),

                // Floating Circular Navigation Buttons (< and >) - Desktop Only
                if (isDesktop) ...[
                  // Previous Button (<)
                  Positioned(
                    left: 8,
                    child: _buildFloatingNavButton(
                      icon: Icons.chevron_left_rounded,
                      enabled: _currentPage > 0,
                      onTap: _previousPage,
                      tooltip: 'Previous Project',
                    ),
                  ),

                  // Next Button (>)
                  Positioned(
                    right: 8,
                    child: _buildFloatingNavButton(
                      icon: Icons.chevron_right_rounded,
                      enabled: _currentPage < widget.highlights.length - 1,
                      onTap: _nextPage,
                      tooltip: 'Next Project',
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 14),

            // Carousel Indicator Dots
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(widget.highlights.length, (i) {
                  final active = i == _currentPage;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: active ? 22 : 7,
                    height: 4,
                    decoration: BoxDecoration(
                      color: active ? AppTheme.neonCyan : const Color(0xFF26262B),
                      borderRadius: BorderRadius.circular(2),
                      boxShadow: active
                          ? [
                              BoxShadow(
                                color: AppTheme.neonCyan.withValues(alpha: 0.6),
                                blurRadius: 6,
                                spreadRadius: 1,
                              ),
                            ]
                          : [],
                    ),
                  );
                }),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFloatingNavButton({
    required IconData icon,
    required bool enabled,
    required VoidCallback onTap,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: enabled ? 1.0 : 0.35,
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: const Color(0xF00D0D12),
            shape: BoxShape.circle,
            border: Border.all(
              color: enabled
                  ? AppTheme.neonCyan.withValues(alpha: 0.5)
                  : const Color(0xFF26262B),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.65),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
              if (enabled)
                BoxShadow(
                  color: AppTheme.neonCyan.withValues(alpha: 0.2),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: enabled ? onTap : null,
              child: Center(
                child: Icon(
                  icon,
                  size: 26,
                  color: enabled ? Colors.white : AppTheme.textMuted,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardBackground(ProjectHighlight project) {
    if (project.coverImageUrl != null && project.coverImageUrl!.isNotEmpty) {
      return Image.network(
        project.coverImageUrl!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _fallbackGradient(),
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Stack(
            fit: StackFit.expand,
            children: [
              _fallbackGradient(),
              const Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppTheme.neonCyan,
                  ),
                ),
              ),
            ],
          );
        },
      );
    }
    return _fallbackGradient();
  }

  Widget _fallbackGradient() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF191828),
            Color(0xFF0F1420),
            Color(0xFF0A0A0C),
          ],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.terminal_rounded,
          size: 48,
          color: Colors.white.withValues(alpha: 0.08),
        ),
      ),
    );
  }
}
