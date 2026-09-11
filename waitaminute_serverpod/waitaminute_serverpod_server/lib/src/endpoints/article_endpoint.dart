import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

/// Endpoint for managing editorial articles and devlogs (CRUD).
class ArticleEndpoint extends Endpoint {
  /// Fetches articles, optionally including drafts.
  Future<List<Article>> getArticles(
    Session session, {
    bool includeDrafts = false,
  }) async {
    return await Article.db.find(
      session,
      where: (t) => includeDrafts ? Constant.bool(true) : t.isPublished.equals(true),
      orderBy: (t) => t.publishedAt,
      orderDescending: true,
    );
  }

  /// Fetches a single article by its database ID.
  Future<Article?> getArticleById(Session session, int id) async {
    return await Article.db.findById(session, id);
  }

  /// Saves an article, performing an insert if id is null or an update if id is provided.
  Future<Article> saveArticle(Session session, Article article) async {
    if (article.id != null) {
      return await Article.db.updateRow(session, article);
    } else {
      return await Article.db.insertRow(session, article);
    }
  }

  /// Deletes an article by its database ID.
  Future<bool> deleteArticle(Session session, int id) async {
    final article = await Article.db.findById(session, id);
    if (article != null) {
      await Article.db.deleteRow(session, article);
      return true;
    }
    return false;
  }
}
