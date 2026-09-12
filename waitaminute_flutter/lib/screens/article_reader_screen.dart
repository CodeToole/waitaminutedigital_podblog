import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:waitaminute_serverpod_client/waitaminute_serverpod_client.dart';
import '../services/serverpod_service.dart';
import '../theme/app_theme.dart';
import '../widgets/badge_tag.dart';

/// Cyber-Editorial Reader Screen for in-depth article and devlog reading.
class ArticleReaderScreen extends StatefulWidget {
  final Article? article;
  final String? slug;

  const ArticleReaderScreen({
    super.key,
    this.article,
    this.slug,
  });

  @override
  State<ArticleReaderScreen> createState() => _ArticleReaderScreenState();
}

class _ArticleReaderScreenState extends State<ArticleReaderScreen> {
  Article? _article;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _article = widget.article;
    if (_article == null && widget.slug != null) {
      _loadArticleBySlug(widget.slug!);
    }
  }

  Future<void> _loadArticleBySlug(String slug) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final fetched = await ServerpodService.instance.fetchArticleBySlug(slug);

    if (!mounted) return;
    setState(() {
      _isLoading = false;
      if (fetched != null) {
        _article = fetched;
      } else {
        _errorMessage = 'Dispatch not found. It may have been archived or unpublished.';
      }
    });
  }

  String _getShareUrl(Article article) {
    try {
      if (kIsWeb && (Uri.base.scheme == 'http' || Uri.base.scheme == 'https')) {
        return '${Uri.base.origin}/#/article/${article.slug}';
      }
    } catch (_) {}
    return 'https://waitaminutedigital.com/#/article/${article.slug}';
  }

  Future<void> _launchShare(String urlString) async {
    final uri = Uri.parse(urlString);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint('Could not launch share URL: $e');
    }
  }

  void _copyLink(BuildContext context, Article article) {
    final shareUrl = _getShareUrl(article);
    Clipboard.setData(ClipboardData(text: shareUrl));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF161622),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: AppTheme.neonCyan, width: 1),
        ),
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: AppTheme.neonCyan, size: 18),
            const SizedBox(width: 10),
            Text(
              'Article link copied to clipboard!',
              style: GoogleFonts.spaceMono(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'RECENT DISPATCH';
    const months = [
      'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN',
      'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  String _calculateReadingTime(String content) {
    final words = content.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length;
    final minutes = (words / 200).ceil().clamp(1, 60);
    return '$minutes MIN READ';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0A0C),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white70),
          tooltip: 'Back to Dispatches',
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              Navigator.of(context).pushReplacementNamed('/');
            }
          },
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                child: Image.asset('assets/img/mascot_head.png', fit: BoxFit.cover),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'WAITAMINUTE DISPATCH',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.1,
                color: Colors.white,
              ),
            ),
          ],
        ),
        actions: [
          if (_article != null)
            IconButton(
              icon: const Icon(Icons.share_rounded, color: AppTheme.neonCyan, size: 20),
              tooltip: 'Share Article',
              onPressed: () => _copyLink(context, _article!),
            ),
          const SizedBox(width: 8),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: Color(0xFF1F1E24)),
        ),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppTheme.neonCyan,
          strokeWidth: 2.5,
        ),
      );
    }

    if (_errorMessage != null || _article == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.article_outlined, size: 56, color: AppTheme.textMuted),
              const SizedBox(height: 16),
              Text(
                _errorMessage ?? 'Dispatch not found',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => Navigator.of(context).pushReplacementNamed('/'),
                icon: const Icon(Icons.arrow_back_rounded, size: 16),
                label: Text(
                  'RETURN TO HOME',
                  style: GoogleFonts.spaceMono(fontSize: 12, fontWeight: FontWeight.w700),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A1A24),
                  foregroundColor: AppTheme.neonCyan,
                  side: const BorderSide(color: Color(0xFF26262B)),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final article = _article!;
    final readingTime = _calculateReadingTime(article.body);
    final formattedDate = _formatDate(article.publishedAt);

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 820),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Meta Row: Badge + Date + Reading Time
              Wrap(
                spacing: 12,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  BadgeTag(label: article.badge),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.calendar_today_rounded, size: 13, color: AppTheme.textMuted),
                      const SizedBox(width: 5),
                      Text(
                        formattedDate,
                        style: GoogleFonts.spaceMono(
                          color: AppTheme.textMuted,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.access_time_rounded, size: 13, color: AppTheme.neonCyan),
                      const SizedBox(width: 5),
                      Text(
                        readingTime,
                        style: GoogleFonts.spaceMono(
                          color: AppTheme.neonCyan,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Article Title
              Text(
                article.title,
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  height: 1.25,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 20),

              // Summary Snippet Callout
              if (article.summary.isNotEmpty) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F141C),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.neonCyan.withValues(alpha: 0.3), width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.neonCyan.withValues(alpha: 0.05),
                        blurRadius: 20,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 3,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppTheme.neonCyan,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          article.summary,
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            height: 1.6,
                            color: const Color(0xFFCBD5E1),
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // Social Sharing Action Bar (Header)
              _buildShareBar(context, article),
              const SizedBox(height: 28),

              // Cover Image (if present)
              if (article.coverImageUrl != null && article.coverImageUrl!.trim().isNotEmpty) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFF26262B)),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Image.network(
                      article.coverImageUrl!,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],

              // Divider
              const Divider(color: Color(0xFF1F1E24), height: 1),
              const SizedBox(height: 28),

              // Markdown Content Body
              MarkdownBody(
                data: article.body,
                selectable: true,
                onTapLink: (text, href, title) {
                  if (href != null) _launchShare(href);
                },
                styleSheet: MarkdownStyleSheet(
                  h1: GoogleFonts.spaceGrotesk(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    height: 1.3,
                  ),
                  h2: GoogleFonts.spaceGrotesk(
                    fontSize: 21,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.neonCyan,
                    height: 1.35,
                  ),
                  h3: GoogleFonts.spaceGrotesk(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    height: 1.4,
                  ),
                  p: GoogleFonts.inter(
                    fontSize: 16,
                    height: 1.75,
                    color: const Color(0xFFCBD5E1),
                  ),
                  strong: GoogleFonts.inter(
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                  em: GoogleFonts.inter(
                    fontStyle: FontStyle.italic,
                    color: const Color(0xFFE2E8F0),
                  ),
                  code: GoogleFonts.spaceMono(
                    fontSize: 13,
                    color: AppTheme.neonCyan,
                    backgroundColor: const Color(0xFF161622),
                  ),
                  codeblockPadding: const EdgeInsets.all(16),
                  codeblockDecoration: BoxDecoration(
                    color: const Color(0xFF0D0D14),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFF26262B)),
                  ),
                  blockquote: GoogleFonts.inter(
                    fontSize: 15,
                    fontStyle: FontStyle.italic,
                    color: const Color(0xFF94A3B8),
                    height: 1.6,
                  ),
                  blockquoteDecoration: BoxDecoration(
                    color: const Color(0xFF12121A),
                    border: const Border(
                      left: BorderSide(color: AppTheme.neonViolet, width: 3.5),
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  blockquotePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  listBullet: GoogleFonts.spaceMono(
                    color: AppTheme.neonCyan,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                  horizontalRuleDecoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: const Color(0xFF1F1E24), width: 1.5),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 48),
              const Divider(color: Color(0xFF1F1E24), height: 1),
              const SizedBox(height: 32),

              // Footer Social Share Section
              Text(
                'SHARE THIS DISPATCH',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.1,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 14),
              _buildShareBar(context, article),

              const SizedBox(height: 48),

              // Return CTA
              Center(
                child: OutlinedButton.icon(
                  onPressed: () {
                    if (Navigator.of(context).canPop()) {
                      Navigator.of(context).pop();
                    } else {
                      Navigator.of(context).pushReplacementNamed('/');
                    }
                  },
                  icon: const Icon(Icons.arrow_back_rounded, size: 16),
                  label: Text(
                    'BACK TO ALL DISPATCHES',
                    style: GoogleFonts.spaceMono(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.1,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Color(0xFF26262B), width: 1.5),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  /// Social Sharing Action Bar with X (Twitter), Facebook, LinkedIn, and Copy Link
  Widget _buildShareBar(BuildContext context, Article article) {
    final shareUrl = _getShareUrl(article);
    final encodedUrl = Uri.encodeComponent(shareUrl);
    final encodedTitle = Uri.encodeComponent(article.title);

    final xShareUrl = 'https://twitter.com/intent/tweet?text=$encodedTitle&url=$encodedUrl';
    final fbShareUrl = 'https://www.facebook.com/sharer/sharer.php?u=$encodedUrl';
    final inShareUrl = 'https://www.linkedin.com/sharing/share-offsite/?url=$encodedUrl';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF121218),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF22222B)),
      ),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            'SHARE:',
            style: GoogleFonts.spaceMono(
              color: AppTheme.textMuted,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.1,
            ),
          ),

          // Share to X (Twitter)
          _ShareButton(
            label: '𝕏 Post',
            icon: null,
            badgeColor: Colors.white,
            backgroundColor: const Color(0xFF1B1B24),
            onTap: () => _launchShare(xShareUrl),
            tooltip: 'Share on X',
          ),

          // Share to Facebook
          _ShareButton(
            label: 'Facebook',
            icon: Icons.facebook,
            badgeColor: const Color(0xFF1877F2),
            backgroundColor: const Color(0xFF141926),
            onTap: () => _launchShare(fbShareUrl),
            tooltip: 'Share on Facebook',
          ),

          // Share to LinkedIn
          _ShareButton(
            label: 'LinkedIn',
            icon: Icons.share_rounded,
            badgeColor: const Color(0xFF0A66C2),
            backgroundColor: const Color(0xFF121B26),
            onTap: () => _launchShare(inShareUrl),
            tooltip: 'Share on LinkedIn',
          ),

          // Copy Link Button
          _ShareButton(
            label: 'Copy Link',
            icon: Icons.link_rounded,
            badgeColor: AppTheme.neonViolet,
            backgroundColor: const Color(0xFF1C1426),
            onTap: () => _copyLink(context, article),
            tooltip: 'Copy article link to clipboard',
          ),
        ],
      ),
    );
  }
}

class _ShareButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Color badgeColor;
  final Color backgroundColor;
  final VoidCallback onTap;
  final String tooltip;

  const _ShareButton({
    required this.label,
    required this.icon,
    required this.badgeColor,
    required this.backgroundColor,
    required this.onTap,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Tooltip(
        message: tooltip,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: badgeColor.withValues(alpha: 0.35)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 14, color: badgeColor),
                  const SizedBox(width: 6),
                ],
                Text(
                  label,
                  style: GoogleFonts.spaceMono(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
