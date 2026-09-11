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

/// A featured portfolio project or client case study highlight.
abstract class ProjectHighlight
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
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

  static final t = ProjectHighlightTable();

  static const db = ProjectHighlightRepository._();

  @override
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

  @override
  _i1.Table<int?> get table => t;

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
  Map<String, dynamic> toJsonForProtocol() {
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

  static ProjectHighlightInclude include() {
    return ProjectHighlightInclude._();
  }

  static ProjectHighlightIncludeList includeList({
    _i1.WhereExpressionBuilder<ProjectHighlightTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ProjectHighlightTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ProjectHighlightTable>? orderByList,
    ProjectHighlightInclude? include,
  }) {
    return ProjectHighlightIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ProjectHighlight.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(ProjectHighlight.t),
      include: include,
    );
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

class ProjectHighlightUpdateTable
    extends _i1.UpdateTable<ProjectHighlightTable> {
  ProjectHighlightUpdateTable(super.table);

  _i1.ColumnValue<String, String> title(String value) => _i1.ColumnValue(
    table.title,
    value,
  );

  _i1.ColumnValue<String, String> client(String value) => _i1.ColumnValue(
    table.client,
    value,
  );

  _i1.ColumnValue<String, String> summary(String value) => _i1.ColumnValue(
    table.summary,
    value,
  );

  _i1.ColumnValue<String, String> coverImageUrl(String? value) =>
      _i1.ColumnValue(
        table.coverImageUrl,
        value,
      );

  _i1.ColumnValue<String, String> externalUrl(String? value) => _i1.ColumnValue(
    table.externalUrl,
    value,
  );

  _i1.ColumnValue<bool, bool> isFeatured(bool value) => _i1.ColumnValue(
    table.isFeatured,
    value,
  );

  _i1.ColumnValue<int, int> order(int value) => _i1.ColumnValue(
    table.order,
    value,
  );
}

class ProjectHighlightTable extends _i1.Table<int?> {
  ProjectHighlightTable({super.tableRelation})
    : super(tableName: 'project_highlight') {
    updateTable = ProjectHighlightUpdateTable(this);
    title = _i1.ColumnString(
      'title',
      this,
    );
    client = _i1.ColumnString(
      'client',
      this,
    );
    summary = _i1.ColumnString(
      'summary',
      this,
    );
    coverImageUrl = _i1.ColumnString(
      'coverImageUrl',
      this,
    );
    externalUrl = _i1.ColumnString(
      'externalUrl',
      this,
    );
    isFeatured = _i1.ColumnBool(
      'isFeatured',
      this,
      hasDefault: true,
    );
    order = _i1.ColumnInt(
      'order',
      this,
      hasDefault: true,
    );
  }

  late final ProjectHighlightUpdateTable updateTable;

  /// Headline title of the project.
  late final _i1.ColumnString title;

  /// Client name or internal project label.
  late final _i1.ColumnString client;

  /// Concise summary of the project impact and tech stack.
  late final _i1.ColumnString summary;

  /// URL to the featured cover image.
  late final _i1.ColumnString coverImageUrl;

  /// External link to live case study, app, or demo.
  late final _i1.ColumnString externalUrl;

  /// Whether to showcase in the top horizontal carousel.
  late final _i1.ColumnBool isFeatured;

  /// Display order priority for sorting.
  late final _i1.ColumnInt order;

  @override
  List<_i1.Column> get columns => [
    id,
    title,
    client,
    summary,
    coverImageUrl,
    externalUrl,
    isFeatured,
    order,
  ];
}

class ProjectHighlightInclude extends _i1.IncludeObject {
  ProjectHighlightInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => ProjectHighlight.t;
}

class ProjectHighlightIncludeList extends _i1.IncludeList {
  ProjectHighlightIncludeList._({
    _i1.WhereExpressionBuilder<ProjectHighlightTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ProjectHighlight.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => ProjectHighlight.t;
}

class ProjectHighlightRepository {
  const ProjectHighlightRepository._();

  /// Returns a list of [ProjectHighlight]s matching the given query parameters.
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
  Future<List<ProjectHighlight>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ProjectHighlightTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ProjectHighlightTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ProjectHighlightTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ProjectHighlight>(
      where: where?.call(ProjectHighlight.t),
      orderBy: orderBy?.call(ProjectHighlight.t),
      orderByList: orderByList?.call(ProjectHighlight.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [ProjectHighlight] matching the given query parameters.
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
  Future<ProjectHighlight?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ProjectHighlightTable>? where,
    int? offset,
    _i1.OrderByBuilder<ProjectHighlightTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ProjectHighlightTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ProjectHighlight>(
      where: where?.call(ProjectHighlight.t),
      orderBy: orderBy?.call(ProjectHighlight.t),
      orderByList: orderByList?.call(ProjectHighlight.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ProjectHighlight] by its [id] or null if no such row exists.
  Future<ProjectHighlight?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ProjectHighlight>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ProjectHighlight]s in the list and returns the inserted rows.
  ///
  /// The returned [ProjectHighlight]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<ProjectHighlight>> insert(
    _i1.DatabaseSession session,
    List<ProjectHighlight> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<ProjectHighlight>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [ProjectHighlight] and returns the inserted row.
  ///
  /// The returned [ProjectHighlight] will have its `id` field set.
  Future<ProjectHighlight> insertRow(
    _i1.DatabaseSession session,
    ProjectHighlight row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ProjectHighlight>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [ProjectHighlight]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<ProjectHighlight>> update(
    _i1.DatabaseSession session,
    List<ProjectHighlight> rows, {
    _i1.ColumnSelections<ProjectHighlightTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<ProjectHighlight>(
      rows,
      columns: columns?.call(ProjectHighlight.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ProjectHighlight]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ProjectHighlight> updateRow(
    _i1.DatabaseSession session,
    ProjectHighlight row, {
    _i1.ColumnSelections<ProjectHighlightTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<ProjectHighlight>(
      row,
      columns: columns?.call(ProjectHighlight.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ProjectHighlight] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ProjectHighlight?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<ProjectHighlightUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<ProjectHighlight>(
      id,
      columnValues: columnValues(ProjectHighlight.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ProjectHighlight]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<ProjectHighlight>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<ProjectHighlightUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<ProjectHighlightTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ProjectHighlightTable>? orderBy,
    _i1.OrderByListBuilder<ProjectHighlightTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<ProjectHighlight>(
      columnValues: columnValues(ProjectHighlight.t.updateTable),
      where: where(ProjectHighlight.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ProjectHighlight.t),
      orderByList: orderByList?.call(ProjectHighlight.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [ProjectHighlight]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<ProjectHighlight>> delete(
    _i1.DatabaseSession session,
    List<ProjectHighlight> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ProjectHighlight>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [ProjectHighlight].
  Future<ProjectHighlight> deleteRow(
    _i1.DatabaseSession session,
    ProjectHighlight row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ProjectHighlight>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<ProjectHighlight>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<ProjectHighlightTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ProjectHighlight>(
      where: where(ProjectHighlight.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ProjectHighlightTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ProjectHighlight>(
      where: where?.call(ProjectHighlight.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ProjectHighlight] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<ProjectHighlightTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ProjectHighlight>(
      where: where(ProjectHighlight.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
