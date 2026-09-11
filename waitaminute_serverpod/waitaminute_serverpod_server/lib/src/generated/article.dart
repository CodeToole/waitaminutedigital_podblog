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

import 'package:serverpod/serverpod.dart' as _i1;

/// An editorial article or devlog entry for Waitaminute Digital.
abstract class Article
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
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

  static final t = ArticleTable();

  static const db = ArticleRepository._();

  @override
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

  @override
  _i1.Table<int?> get table => t;

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
  Map<String, dynamic> toJsonForProtocol() {
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

  static ArticleInclude include() {
    return ArticleInclude._();
  }

  static ArticleIncludeList includeList({
    _i1.WhereExpressionBuilder<ArticleTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ArticleTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ArticleTable>? orderByList,
    ArticleInclude? include,
  }) {
    return ArticleIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Article.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Article.t),
      include: include,
    );
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

class ArticleUpdateTable extends _i1.UpdateTable<ArticleTable> {
  ArticleUpdateTable(super.table);

  _i1.ColumnValue<String, String> title(String value) => _i1.ColumnValue(
    table.title,
    value,
  );

  _i1.ColumnValue<String, String> slug(String value) => _i1.ColumnValue(
    table.slug,
    value,
  );

  _i1.ColumnValue<String, String> summary(String value) => _i1.ColumnValue(
    table.summary,
    value,
  );

  _i1.ColumnValue<String, String> body(String value) => _i1.ColumnValue(
    table.body,
    value,
  );

  _i1.ColumnValue<String, String> badge(String value) => _i1.ColumnValue(
    table.badge,
    value,
  );

  _i1.ColumnValue<String, String> coverImageUrl(String? value) =>
      _i1.ColumnValue(
        table.coverImageUrl,
        value,
      );

  _i1.ColumnValue<String, String> youtubeUrl(String? value) => _i1.ColumnValue(
    table.youtubeUrl,
    value,
  );

  _i1.ColumnValue<bool, bool> isPublished(bool value) => _i1.ColumnValue(
    table.isPublished,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> publishedAt(DateTime? value) =>
      _i1.ColumnValue(
        table.publishedAt,
        value,
      );
}

class ArticleTable extends _i1.Table<int?> {
  ArticleTable({super.tableRelation}) : super(tableName: 'article') {
    updateTable = ArticleUpdateTable(this);
    title = _i1.ColumnString(
      'title',
      this,
    );
    slug = _i1.ColumnString(
      'slug',
      this,
    );
    summary = _i1.ColumnString(
      'summary',
      this,
    );
    body = _i1.ColumnString(
      'body',
      this,
    );
    badge = _i1.ColumnString(
      'badge',
      this,
    );
    coverImageUrl = _i1.ColumnString(
      'coverImageUrl',
      this,
    );
    youtubeUrl = _i1.ColumnString(
      'youtubeUrl',
      this,
    );
    isPublished = _i1.ColumnBool(
      'isPublished',
      this,
      hasDefault: true,
    );
    publishedAt = _i1.ColumnDateTime(
      'publishedAt',
      this,
    );
  }

  late final ArticleUpdateTable updateTable;

  /// The title of the article.
  late final _i1.ColumnString title;

  /// The URL slug for the article.
  late final _i1.ColumnString slug;

  /// Short summary / lead paragraph.
  late final _i1.ColumnString summary;

  /// Full article content formatted in Markdown.
  late final _i1.ColumnString body;

  /// Editorial category badge (e.g. ARCHITECTURE, POST-MORTEM, SHIPPED).
  late final _i1.ColumnString badge;

  /// Optional URL to the cover banner image.
  late final _i1.ColumnString coverImageUrl;

  /// Optional YouTube video URL or ID for embedded devlogs.
  late final _i1.ColumnString youtubeUrl;

  /// Publication status flag.
  late final _i1.ColumnBool isPublished;

  /// Timestamp when the article was published.
  late final _i1.ColumnDateTime publishedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    title,
    slug,
    summary,
    body,
    badge,
    coverImageUrl,
    youtubeUrl,
    isPublished,
    publishedAt,
  ];
}

class ArticleInclude extends _i1.IncludeObject {
  ArticleInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => Article.t;
}

class ArticleIncludeList extends _i1.IncludeList {
  ArticleIncludeList._({
    _i1.WhereExpressionBuilder<ArticleTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Article.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => Article.t;
}

class ArticleRepository {
  const ArticleRepository._();

  /// Returns a list of [Article]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<Article>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ArticleTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ArticleTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ArticleTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Article>(
      where: where?.call(Article.t),
      orderBy: orderBy?.call(Article.t),
      orderByList: orderByList?.call(Article.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Article] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<Article?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ArticleTable>? where,
    int? offset,
    _i1.OrderByBuilder<ArticleTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ArticleTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Article>(
      where: where?.call(Article.t),
      orderBy: orderBy?.call(Article.t),
      orderByList: orderByList?.call(Article.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Article] by its [id] or null if no such row exists.
  Future<Article?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Article>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Article]s in the list and returns the inserted rows.
  ///
  /// The returned [Article]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<Article>> insert(
    _i1.DatabaseSession session,
    List<Article> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<Article>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [Article] and returns the inserted row.
  ///
  /// The returned [Article] will have its `id` field set.
  Future<Article> insertRow(
    _i1.DatabaseSession session,
    Article row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Article>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Article]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Article>> update(
    _i1.DatabaseSession session,
    List<Article> rows, {
    _i1.ColumnSelections<ArticleTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Article>(
      rows,
      columns: columns?.call(Article.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Article]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Article> updateRow(
    _i1.DatabaseSession session,
    Article row, {
    _i1.ColumnSelections<ArticleTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Article>(
      row,
      columns: columns?.call(Article.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Article] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Article?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<ArticleUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<Article>(
      id,
      columnValues: columnValues(Article.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Article]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<Article>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<ArticleUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<ArticleTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ArticleTable>? orderBy,
    _i1.OrderByListBuilder<ArticleTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<Article>(
      columnValues: columnValues(Article.t.updateTable),
      where: where(Article.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Article.t),
      orderByList: orderByList?.call(Article.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [Article]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Article>> delete(
    _i1.DatabaseSession session,
    List<Article> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Article>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Article].
  Future<Article> deleteRow(
    _i1.DatabaseSession session,
    Article row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Article>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Article>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<ArticleTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Article>(
      where: where(Article.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ArticleTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Article>(
      where: where?.call(Article.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Article] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<ArticleTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Article>(
      where: where(Article.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
