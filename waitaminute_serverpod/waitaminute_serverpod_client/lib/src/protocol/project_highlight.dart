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

/// A featured portfolio project or client case study highlight.
abstract class ProjectHighlight implements _i1.SerializableModel {
  ProjectHighlight._({
    this.id,
    required this.title,
    required this.client,
    required this.summary,
    this.coverImageUrl,
    this.externalUrl,
    bool? isFeatured,
    int? order,
  }) : isFeatured = isFeatured ?? false,
       order = order ?? 0;

  factory ProjectHighlight({
    int? id,
    required String title,
    required String client,
    required String summary,
    String? coverImageUrl,
    String? externalUrl,
    bool? isFeatured,
    int? order,
  }) = _ProjectHighlightImpl;

  factory ProjectHighlight.fromJson(Map<String, dynamic> jsonSerialization) {
    return ProjectHighlight(
      id: jsonSerialization['id'] as int?,
      title: jsonSerialization['title'] as String,
      client: jsonSerialization['client'] as String,
      summary: jsonSerialization['summary'] as String,
      coverImageUrl: jsonSerialization['coverImageUrl'] as String?,
      externalUrl: jsonSerialization['externalUrl'] as String?,
      isFeatured: jsonSerialization['isFeatured'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(jsonSerialization['isFeatured']),
      order: jsonSerialization['order'] as int?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// Headline title of the project.
  String title;

  /// Client name or internal project label.
  String client;

  /// Concise summary of the project impact and tech stack.
  String summary;

  /// URL to the featured cover image.
  String? coverImageUrl;

  /// External link to live case study, app, or demo.
  String? externalUrl;

  /// Whether to showcase in the top horizontal carousel.
  bool isFeatured;

  /// Display order priority for sorting.
  int order;

  /// Returns a shallow copy of this [ProjectHighlight]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ProjectHighlight copyWith({
    int? id,
    String? title,
    String? client,
    String? summary,
    String? coverImageUrl,
    String? externalUrl,
    bool? isFeatured,
    int? order,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ProjectHighlight',
      if (id != null) 'id': id,
      'title': title,
      'client': client,
      'summary': summary,
      if (coverImageUrl != null) 'coverImageUrl': coverImageUrl,
      if (externalUrl != null) 'externalUrl': externalUrl,
      'isFeatured': isFeatured,
      'order': order,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ProjectHighlightImpl extends ProjectHighlight {
  _ProjectHighlightImpl({
    int? id,
    required String title,
    required String client,
    required String summary,
    String? coverImageUrl,
    String? externalUrl,
    bool? isFeatured,
    int? order,
  }) : super._(
         id: id,
         title: title,
         client: client,
         summary: summary,
         coverImageUrl: coverImageUrl,
         externalUrl: externalUrl,
         isFeatured: isFeatured,
         order: order,
       );

  /// Returns a shallow copy of this [ProjectHighlight]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ProjectHighlight copyWith({
    Object? id = _Undefined,
    String? title,
    String? client,
    String? summary,
    Object? coverImageUrl = _Undefined,
    Object? externalUrl = _Undefined,
    bool? isFeatured,
    int? order,
  }) {
    return ProjectHighlight(
      id: id is int? ? id : this.id,
      title: title ?? this.title,
      client: client ?? this.client,
      summary: summary ?? this.summary,
      coverImageUrl: coverImageUrl is String?
          ? coverImageUrl
          : this.coverImageUrl,
      externalUrl: externalUrl is String? ? externalUrl : this.externalUrl,
      isFeatured: isFeatured ?? this.isFeatured,
      order: order ?? this.order,
    );
  }
}
