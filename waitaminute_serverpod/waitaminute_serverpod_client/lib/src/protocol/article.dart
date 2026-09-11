/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:serverpod_client/serverpod_client.dart' as _i1;

/// An editorial article or devlog entry for Waitaminute Digital.
abstract class Article implements _i1.SerializableModel {
  Article._({
    this.id,
    required this.title,
    required this.slug,
    required this.summary,
    required this.body,
    required this.badge,
    this.coverImageUrl,
    this.youtubeUrl,
    bool? isPublished,
    this.publishedAt,
  }) : isPublished = isPublished ?? false;

  factory Article({
    int? id,
    required String title,
    required String slug,
    required String summary,
    required String body,
    required String badge,
    String? coverImageUrl,
    String? youtubeUrl,
    bool? isPublished,
    DateTime? publishedAt,
  }) = _ArticleImpl;

  factory Article.fromJson(Map<String, dynamic> jsonSerialization) {
    return Article(
      id: jsonSerialization['id'] as int?,
      title: jsonSerialization['title'] as String,
      slug: jsonSerialization['slug'] as String,
      summary: jsonSerialization['summary'] as String,
      body: jsonSerialization['body'] as String,
      badge: jsonSerialization['badge'] as String,
      coverImageUrl: jsonSerialization['coverImageUrl'] as String?,
      youtubeUrl: jsonSerialization['youtubeUrl'] as String?,
      isPublished: jsonSerialization['isPublished'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(jsonSerialization['isPublished']),
      publishedAt: jsonSerialization['publishedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['publishedAt'],
            ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// The title of the article.
  String title;

  /// The URL slug for the article.
  String slug;

  /// Short summary / lead paragraph.
  String summary;

  /// Full article content formatted in Markdown.
  String body;

  /// Editorial category badge (e.g. ARCHITECTURE, POST-MORTEM, SHIPPED).
  String badge;

  /// Optional URL to the cover banner image.
  String? coverImageUrl;

  /// Optional YouTube video URL or ID for embedded devlogs.
  String? youtubeUrl;

  /// Publication status flag.
  bool isPublished;

  /// Timestamp when the article was published.
  DateTime? publishedAt;

  /// Returns a shallow copy of this [Article]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Article copyWith({
    int? id,
    String? title,
    String? slug,
    String? summary,
    String? body,
    String? badge,
    String? coverImageUrl,
    String? youtubeUrl,
    bool? isPublished,
    DateTime? publishedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Article',
      if (id != null) 'id': id,
      'title': title,
      'slug': slug,
      'summary': summary,
      'body': body,
      'badge': badge,
      if (coverImageUrl != null) 'coverImageUrl': coverImageUrl,
      if (youtubeUrl != null) 'youtubeUrl': youtubeUrl,
      'isPublished': isPublished,
      if (publishedAt != null) 'publishedAt': publishedAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ArticleImpl extends Article {
  _ArticleImpl({
    int? id,
    required String title,
    required String slug,
    required String summary,
    required String body,
    required String badge,
    String? coverImageUrl,
    String? youtubeUrl,
    bool? isPublished,
    DateTime? publishedAt,
  }) : super._(
         id: id,
         title: title,
         slug: slug,
         summary: summary,
         body: body,
         badge: badge,
         coverImageUrl: coverImageUrl,
         youtubeUrl: youtubeUrl,
         isPublished: isPublished,
         publishedAt: publishedAt,
       );

  /// Returns a shallow copy of this [Article]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Article copyWith({
    Object? id = _Undefined,
    String? title,
    String? slug,
    String? summary,
    String? body,
    String? badge,
    Object? coverImageUrl = _Undefined,
    Object? youtubeUrl = _Undefined,
    bool? isPublished,
    Object? publishedAt = _Undefined,
  }) {
    return Article(
      id: id is int? ? id : this.id,
      title: title ?? this.title,
      slug: slug ?? this.slug,
      summary: summary ?? this.summary,
      body: body ?? this.body,
      badge: badge ?? this.badge,
      coverImageUrl: coverImageUrl is String?
          ? coverImageUrl
          : this.coverImageUrl,
      youtubeUrl: youtubeUrl is String? ? youtubeUrl : this.youtubeUrl,
      isPublished: isPublished ?? this.isPublished,
      publishedAt: publishedAt is DateTime? ? publishedAt : this.publishedAt,
    );
  }
}
