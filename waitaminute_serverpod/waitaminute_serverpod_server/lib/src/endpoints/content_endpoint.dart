import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

/// Endpoint for serving editorial CMS content and receiving discovery inquiries.
class ContentEndpoint extends Endpoint {
  /// Fetches all featured project highlights ordered by display priority.
  Future<List<ProjectHighlight>> getFeaturedProjects(Session session) async {
    return await ProjectHighlight.db.find(
      session,
      where: (t) => t.isFeatured.equals(true),
      orderBy: (t) => t.order,
    );
  }

  /// Fetches published articles, optionally filtered by category badge.
  Future<List<Article>> getPublishedArticles(
    Session session, {
    String? category,
    int? limit,
    int? offset,
  }) async {
    return await Article.db.find(
      session,
      where: (t) {
        var condition = t.isPublished.equals(true);
        if (category != null && category.isNotEmpty) {
          condition = condition & t.badge.equals(category);
        }
        return condition;
      },
      orderBy: (t) => t.publishedAt,
      orderDescending: true,
      limit: limit ?? 20,
      offset: offset ?? 0,
    );
  }

  /// Fetches a single published article by its unique slug.
  Future<Article?> getArticleBySlug(Session session, String slug) async {
    return await Article.db.findFirstRow(
      session,
      where: (t) => t.slug.equals(slug) & t.isPublished.equals(true),
    );
  }

  /// Submits a new lead inquiry from the mobile intake form.
  Future<LeadInquiry> submitLeadInquiry(
    Session session,
    LeadInquiry inquiry,
  ) async {
    return await LeadInquiry.db.insertRow(session, inquiry);
  }
}
