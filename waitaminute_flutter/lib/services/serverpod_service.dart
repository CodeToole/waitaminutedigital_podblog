import 'package:flutter/foundation.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';
import 'package:waitaminute_serverpod_client/waitaminute_serverpod_client.dart';

/// Service managing the Serverpod Client instance and local fallbacks for public & admin features.
class ServerpodService {
  static ServerpodService? _instance;
  static ServerpodService get instance => _instance ??= ServerpodService._();

  late final Client client;
  bool isConnected = false;

  ServerpodService._() {
    final serverUrl = _resolveServerUrl();
    client = Client(
      serverUrl,
    )..connectivityMonitor = FlutterConnectivityMonitor();
  }

  /// Resolves the host URL based on running platform:
  /// - Web in release mode uses the same origin with /api/ prefix.
  /// - Web in debug mode falls back to local server at http://localhost:8080/.
  /// - Android emulator uses 10.0.2.2:8080 to reach host machine loopback.
  /// - Desktop and iOS simulator use localhost:8080.
  static String _resolveServerUrl() {
    if (kIsWeb) {
      if (kReleaseMode) {
        final origin = Uri.base.origin;
        return '$origin/api/';
      }
      return 'http://localhost:8080/';
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 'http://10.0.2.2:8080/';
      default:
        return 'http://localhost:8080/';
    }
  }

  // ==========================================
  // Public Client APIs
  // ==========================================

  /// Fetches featured project highlights for the public carousel.
  Future<List<ProjectHighlight>> fetchFeaturedProjects() async {
    try {
      final projects = await client.content.getFeaturedProjects();
      if (projects.isNotEmpty) {
        isConnected = true;
        return projects;
      }
    } catch (e) {
      debugPrint('Serverpod unavailable, using local highlights fallback: $e');
      isConnected = false;
    }
    return _localHighlights.where((h) => h.isFeatured).toList();
  }

  /// Fetches published articles for public readers.
  Future<List<Article>> fetchArticles({String? category}) async {
    try {
      final articles = await client.content.getPublishedArticles(
        category: category,
      );
      if (articles.isNotEmpty) {
        isConnected = true;
        return articles;
      }
    } catch (e) {
      debugPrint('Serverpod unavailable, using local articles fallback: $e');
      isConnected = false;
    }

    var list = _localArticles.where((a) => a.isPublished).toList();
    if (category != null && category != 'ALL') {
      list = list.where((a) => a.badge.toUpperCase() == category.toUpperCase()).toList();
    }
    return list;
  }

  /// Submits a lead inquiry to the backend.
  Future<LeadInquiry> submitLead(LeadInquiry inquiry) async {
    try {
      final result = await client.lead.submitInquiry(inquiry);
      _localInquiries.insert(0, result);
      return result;
    } catch (e) {
      debugPrint('Error submitting lead via Serverpod, falling back: $e');
      _localInquiries.insert(0, inquiry);
      return inquiry;
    }
  }

  // ==========================================
  // Admin Editorial APIs (CRUD)
  // ==========================================

  /// Fetches all articles for admin view (including drafts).
  Future<List<Article>> fetchArticlesAdmin({bool includeDrafts = true}) async {
    try {
      final articles = await client.article.getArticles(includeDrafts: includeDrafts);
      if (articles.isNotEmpty) {
        isConnected = true;
        return articles;
      }
    } catch (e) {
      debugPrint('Serverpod admin fetch articles error, using local: $e');
      isConnected = false;
    }
    if (includeDrafts) {
      return List.from(_localArticles);
    }
    return _localArticles.where((a) => a.isPublished).toList();
  }

  /// Saves an article (insert or update).
  Future<Article> saveArticle(Article article) async {
    try {
      final saved = await client.article.saveArticle(article);
      isConnected = true;
      _updateLocalArticle(saved);
      return saved;
    } catch (e) {
      debugPrint('Serverpod save article error, saving to local fallback: $e');
      final fallback = article.id == null
          ? article.copyWith(id: _nextArticleId++)
          : article;
      _updateLocalArticle(fallback);
      return fallback;
    }
  }

  void _updateLocalArticle(Article article) {
    final idx = _localArticles.indexWhere((a) => a.id == article.id);
    if (idx >= 0) {
      _localArticles[idx] = article;
    } else {
      _localArticles.insert(0, article);
    }
  }

  /// Deletes an article by ID.
  Future<bool> deleteArticle(int id) async {
    try {
      final success = await client.article.deleteArticle(id);
      _localArticles.removeWhere((a) => a.id == id);
      return success;
    } catch (e) {
      debugPrint('Serverpod delete article error, deleting local: $e');
      _localArticles.removeWhere((a) => a.id == id);
      return true;
    }
  }

  /// Fetches all project highlights for admin view.
  Future<List<ProjectHighlight>> fetchAllHighlights() async {
    try {
      final highlights = await client.projectHighlight.getHighlights();
      if (highlights.isNotEmpty) {
        isConnected = true;
        return highlights;
      }
    } catch (e) {
      debugPrint('Serverpod admin fetch highlights error, using local: $e');
      isConnected = false;
    }
    return List.from(_localHighlights);
  }

  /// Saves a project highlight (insert or update).
  Future<ProjectHighlight> saveHighlight(ProjectHighlight project) async {
    try {
      final saved = await client.projectHighlight.saveHighlight(project);
      isConnected = true;
      _updateLocalHighlight(saved);
      return saved;
    } catch (e) {
      debugPrint('Serverpod save highlight error, saving to local fallback: $e');
      final fallback = project.id == null
          ? project.copyWith(id: _nextHighlightId++)
          : project;
      _updateLocalHighlight(fallback);
      return fallback;
    }
  }

  void _updateLocalHighlight(ProjectHighlight project) {
    final idx = _localHighlights.indexWhere((h) => h.id == project.id);
    if (idx >= 0) {
      _localHighlights[idx] = project;
    } else {
      _localHighlights.add(project);
    }
    _localHighlights.sort((a, b) => a.order.compareTo(b.order));
  }

  /// Deletes a project highlight by ID.
  Future<bool> deleteHighlight(int id) async {
    try {
      final success = await client.projectHighlight.deleteHighlight(id);
      _localHighlights.removeWhere((h) => h.id == id);
      return success;
    } catch (e) {
      debugPrint('Serverpod delete highlight error, deleting local: $e');
      _localHighlights.removeWhere((h) => h.id == id);
      return true;
    }
  }

  /// Fetches client lead inquiries for admin review.
  Future<List<LeadInquiry>> fetchInquiries() async {
    try {
      final inquiries = await client.lead.getInquiries();
      if (inquiries.isNotEmpty) {
        isConnected = true;
        return inquiries;
      }
    } catch (e) {
      debugPrint('Serverpod fetch inquiries error, using local fallback: $e');
      isConnected = false;
    }
    return List.from(_localInquiries);
  }

  // ==========================================
  // In-Memory Seed / Fallback Datastores
  // ==========================================

  static int _nextArticleId = 10;
  static int _nextHighlightId = 10;

  static final List<ProjectHighlight> _localHighlights = [
    ProjectHighlight(
      id: 1,
      title: 'Waitaminute Digital Platform',
      client: 'INTERNAL INCUBATOR',
      summary: 'High-velocity editorial CMS and consulting engine powered by Django 6.1 + Serverpod.',
      coverImageUrl: 'https://images.unsplash.com/photo-1550745165-9bc0b252726f?auto=format&fit=crop&w=800&q=80',
      externalUrl: 'https://waitaminutedigital.com',
      isFeatured: true,
      order: 1,
    ),
    ProjectHighlight(
      id: 2,
      title: 'Autonomous Multi-Agent Fleet',
      client: 'FINTECH CLIENT',
      summary: 'Real-time telemetry and task orchestration engine deployed on Azure Container Apps.',
      coverImageUrl: 'https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?auto=format&fit=crop&w=800&q=80',
      externalUrl: 'https://waitaminutedigital.com/portfolio',
      isFeatured: true,
      order: 2,
    ),
    ProjectHighlight(
      id: 3,
      title: 'IGN-Style Mobile Peeking UI',
      client: 'LABS / EXPERIMENTS',
      summary: 'Dart-first editorial client utilizing Serverpod declarative ORM and custom Flutter shaders.',
      coverImageUrl: 'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?auto=format&fit=crop&w=800&q=80',
      externalUrl: 'https://waitaminutedigital.com',
      isFeatured: true,
      order: 3,
    ),
  ];

  static final List<Article> _localArticles = [
    Article(
      id: 1,
      title: 'Why We Tested Serverpod for Our High-Velocity Mobile CMS',
      slug: 'why-we-tested-serverpod-mobile-cms',
      summary: 'Replacing REST boilerplate with typed Dart-first serialization and automatic client generation.',
      body: '## The Architecture Shift\n\nMoving to Serverpod allowed us to write typed endpoints in Dart and directly share contracts with our mobile app without generating OpenAPI schemas manually.\n\n### Performance Highlights\n- 0-reflection binary serialization\n- Automatic client generation in seconds\n- PostgreSQL integration with declarative YAML schemas',
      badge: 'ARCHITECTURE',
      coverImageUrl: 'https://images.unsplash.com/photo-1550751827-4bd374c3f58b?auto=format&fit=crop&w=800&q=80',
      isPublished: true,
      publishedAt: DateTime.now().subtract(const Duration(hours: 4)),
    ),
    Article(
      id: 2,
      title: 'Zero Downtime Migrations on Azure PostgreSQL 18: A Field Guide',
      slug: 'zero-downtime-migrations-postgresql-18',
      summary: 'How to structure backward-compatible schema evolutions without locking editorial tables.',
      body: '## Schema Evolution Patterns\n\nWhen deploying high-traffic updates, backward-compatible migrations ensure existing containers continue serving traffic while new schema columns are populated.',
      badge: 'POST-MORTEM',
      coverImageUrl: 'https://images.unsplash.com/photo-1544197150-b99a580bb7a8?auto=format&fit=crop&w=800&q=80',
      isPublished: true,
      publishedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Article(
      id: 3,
      title: 'Waitaminute Digital v2.0 Shipped: IGN Layouts on Modern Mobile',
      slug: 'waitaminute-digital-v2-shipped',
      summary: 'Bringing desktop editorial aesthetics to pocket screens with peeking carousels and neon badges.',
      body: '## Mobile Visual Excellence\n\nWe designed our carousel around full-bleed artwork, gradient depth overlays, and custom typography tokens.',
      badge: 'SHIPPED',
      coverImageUrl: 'https://images.unsplash.com/photo-1518770660439-4636190af475?auto=format&fit=crop&w=800&q=80',
      isPublished: true,
      publishedAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
    Article(
      id: 4,
      title: 'Devlog #14: Streaming WebSockets with Serverpod & Flutter',
      slug: 'devlog-14-streaming-websockets-serverpod',
      summary: 'Real-time state synchronization with minimal battery impact on Android devices.',
      body: '## Stream Handling in Dart\n\nUsing Serverpod streaming endpoints, clients maintain a single persistent connection with automatic reconnection.',
      badge: 'DEVLOG',
      coverImageUrl: 'https://images.unsplash.com/photo-1504639725590-34d0984388bd?auto=format&fit=crop&w=800&q=80',
      isPublished: false,
      publishedAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
  ];

  static final List<LeadInquiry> _localInquiries = [
    LeadInquiry(
      id: 1,
      name: 'Marcus Vance',
      email: 'marcus@vanceventures.io',
      projectType: 'Mobile Architecture',
      message: 'Looking to build a Flutter + Serverpod media app for our distributed editorial staff with real-time sync.',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    LeadInquiry(
      id: 2,
      name: 'Elena Chen',
      email: 'elena@chenautonomous.ai',
      projectType: 'Multi-Agent System',
      message: 'Need cloud orchestration for agent telemetry dashboard on Azure Container Apps.',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];
}
