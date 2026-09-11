import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waitaminute_serverpod_client/waitaminute_serverpod_client.dart';
import '../screens/article_reader_screen.dart';
import '../theme/app_theme.dart';
import 'badge_tag.dart';

/// Editorial list item representing an article or technical devlog.
class ArticleCard extends StatelessWidget {
  final Article article;
  final VoidCallback? onTap;

  const ArticleCard({
    super.key,
    required this.article,
    this.onTap,
  });

  void _handleTap(BuildContext context) {
    if (onTap != null) {
      onTap!();
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ArticleReaderScreen(article: article),
          settings: RouteSettings(name: '/article/${article.slug}'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = article.publishedAt != null
        ? _formatRelativeDate(article.publishedAt!)
        : 'RECENT';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF26262B), width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => _handleTap(context),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Meta row: Badge + Time
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BadgeTag(label: article.badge, isSmall: true),
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time_rounded,
                          size: 13,
                          color: AppTheme.textMuted,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          formattedDate,
                          style: GoogleFonts.spaceMono(
                            color: AppTheme.textMuted,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Article Title
                Text(
                  article.title,
                  style: GoogleFonts.spaceGrotesk(
                    color: AppTheme.textPrimary,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 8),

                // Summary snippet
                Text(
                  article.summary,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    color: const Color(0xFF94A3B8),
                    fontSize: 13,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 14),

                // Action link ("READ ARTICLE >")
                InkWell(
                  borderRadius: BorderRadius.circular(4),
                  onTap: () => _handleTap(context),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'READ ARTICLE',
                          style: GoogleFonts.spaceMono(
                            color: AppTheme.badgeColor(article.badge),
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.1,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 11,
                          color: AppTheme.badgeColor(article.badge),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatRelativeDate(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}d ago';
    }
    return '${date.month}/${date.day}/${date.year}';
  }
}
