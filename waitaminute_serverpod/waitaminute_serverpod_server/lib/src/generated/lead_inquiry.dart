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

/// A customer lead inquiry submitted from the mobile or web discovery intake.
abstract class LeadInquiry
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  LeadInquiry._({
    this.id,
    required this.name,
    required this.email,
    required this.projectType,
    required this.message,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory LeadInquiry({
    int? id,
    required String name,
    required String email,
    required String projectType,
    required String message,
    DateTime? createdAt,
  }) = _LeadInquiryImpl;

  factory LeadInquiry.fromJson(Map<String, dynamic> jsonSerialization) {
    return LeadInquiry(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      email: jsonSerialization['email'] as String,
      projectType: jsonSerialization['projectType'] as String,
      message: jsonSerialization['message'] as String,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = LeadInquiryTable();

  static const db = LeadInquiryRepository._();

  @override
  int? id;

  /// Contact name of the prospect.
  String name;

  /// Contact email address.
  String email;

  /// High-level project category (e.g. Mobile App, Backend Architecture, Cloud Migration).
  String projectType;

  /// Detailed project scope or inquiry message.
  String message;

  /// Timestamp when the inquiry was received.
  DateTime createdAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [LeadInquiry]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  LeadInquiry copyWith({
    int? id,
    String? name,
    String? email,
    String? projectType,
    String? message,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'LeadInquiry',
      if (id != null) 'id': id,
      'name': name,
      'email': email,
      'projectType': projectType,
      'message': message,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'LeadInquiry',
      if (id != null) 'id': id,
      'name': name,
      'email': email,
      'projectType': projectType,
      'message': message,
      'createdAt': createdAt.toJson(),
    };
  }

  static LeadInquiryInclude include() {
    return LeadInquiryInclude._();
  }

  static LeadInquiryIncludeList includeList({
    _i1.WhereExpressionBuilder<LeadInquiryTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<LeadInquiryTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<LeadInquiryTable>? orderByList,
    LeadInquiryInclude? include,
  }) {
    return LeadInquiryIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(LeadInquiry.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(LeadInquiry.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _LeadInquiryImpl extends LeadInquiry {
  _LeadInquiryImpl({
    int? id,
    required String name,
    required String email,
    required String projectType,
    required String message,
    DateTime? createdAt,
  }) : super._(
         id: id,
         name: name,
         email: email,
         projectType: projectType,
         message: message,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [LeadInquiry]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  LeadInquiry copyWith({
    Object? id = _Undefined,
    String? name,
    String? email,
    String? projectType,
    String? message,
    DateTime? createdAt,
  }) {
    return LeadInquiry(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      projectType: projectType ?? this.projectType,
      message: message ?? this.message,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class LeadInquiryUpdateTable extends _i1.UpdateTable<LeadInquiryTable> {
  LeadInquiryUpdateTable(super.table);

  _i1.ColumnValue<String, String> name(String value) => _i1.ColumnValue(
    table.name,
    value,
  );

  _i1.ColumnValue<String, String> email(String value) => _i1.ColumnValue(
    table.email,
    value,
  );

  _i1.ColumnValue<String, String> projectType(String value) => _i1.ColumnValue(
    table.projectType,
    value,
  );

  _i1.ColumnValue<String, String> message(String value) => _i1.ColumnValue(
    table.message,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );
}

class LeadInquiryTable extends _i1.Table<int?> {
  LeadInquiryTable({super.tableRelation}) : super(tableName: 'lead_inquiry') {
    updateTable = LeadInquiryUpdateTable(this);
    name = _i1.ColumnString(
      'name',
      this,
    );
    email = _i1.ColumnString(
      'email',
      this,
    );
    projectType = _i1.ColumnString(
      'projectType',
      this,
    );
    message = _i1.ColumnString(
      'message',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
  }

  late final LeadInquiryUpdateTable updateTable;

  /// Contact name of the prospect.
  late final _i1.ColumnString name;

  /// Contact email address.
  late final _i1.ColumnString email;

  /// High-level project category (e.g. Mobile App, Backend Architecture, Cloud Migration).
  late final _i1.ColumnString projectType;

  /// Detailed project scope or inquiry message.
  late final _i1.ColumnString message;

  /// Timestamp when the inquiry was received.
  late final _i1.ColumnDateTime createdAt;

  @override
  List<_i1.Column> get columns => [
    id,
    name,
    email,
    projectType,
    message,
    createdAt,
  ];
}

class LeadInquiryInclude extends _i1.IncludeObject {
  LeadInquiryInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => LeadInquiry.t;
}

class LeadInquiryIncludeList extends _i1.IncludeList {
  LeadInquiryIncludeList._({
    _i1.WhereExpressionBuilder<LeadInquiryTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(LeadInquiry.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => LeadInquiry.t;
}

class LeadInquiryRepository {
  const LeadInquiryRepository._();

  /// Returns a list of [LeadInquiry]s matching the given query parameters.
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
  Future<List<LeadInquiry>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<LeadInquiryTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<LeadInquiryTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<LeadInquiryTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<LeadInquiry>(
      where: where?.call(LeadInquiry.t),
      orderBy: orderBy?.call(LeadInquiry.t),
      orderByList: orderByList?.call(LeadInquiry.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [LeadInquiry] matching the given query parameters.
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
  Future<LeadInquiry?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<LeadInquiryTable>? where,
    int? offset,
    _i1.OrderByBuilder<LeadInquiryTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<LeadInquiryTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<LeadInquiry>(
      where: where?.call(LeadInquiry.t),
      orderBy: orderBy?.call(LeadInquiry.t),
      orderByList: orderByList?.call(LeadInquiry.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [LeadInquiry] by its [id] or null if no such row exists.
  Future<LeadInquiry?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<LeadInquiry>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [LeadInquiry]s in the list and returns the inserted rows.
  ///
  /// The returned [LeadInquiry]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<LeadInquiry>> insert(
    _i1.DatabaseSession session,
    List<LeadInquiry> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<LeadInquiry>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [LeadInquiry] and returns the inserted row.
  ///
  /// The returned [LeadInquiry] will have its `id` field set.
  Future<LeadInquiry> insertRow(
    _i1.DatabaseSession session,
    LeadInquiry row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<LeadInquiry>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [LeadInquiry]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<LeadInquiry>> update(
    _i1.DatabaseSession session,
    List<LeadInquiry> rows, {
    _i1.ColumnSelections<LeadInquiryTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<LeadInquiry>(
      rows,
      columns: columns?.call(LeadInquiry.t),
      transaction: transaction,
    );
  }

  /// Updates a single [LeadInquiry]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<LeadInquiry> updateRow(
    _i1.DatabaseSession session,
    LeadInquiry row, {
    _i1.ColumnSelections<LeadInquiryTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<LeadInquiry>(
      row,
      columns: columns?.call(LeadInquiry.t),
      transaction: transaction,
    );
  }

  /// Updates a single [LeadInquiry] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<LeadInquiry?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<LeadInquiryUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<LeadInquiry>(
      id,
      columnValues: columnValues(LeadInquiry.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [LeadInquiry]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<LeadInquiry>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<LeadInquiryUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<LeadInquiryTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<LeadInquiryTable>? orderBy,
    _i1.OrderByListBuilder<LeadInquiryTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<LeadInquiry>(
      columnValues: columnValues(LeadInquiry.t.updateTable),
      where: where(LeadInquiry.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(LeadInquiry.t),
      orderByList: orderByList?.call(LeadInquiry.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [LeadInquiry]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<LeadInquiry>> delete(
    _i1.DatabaseSession session,
    List<LeadInquiry> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<LeadInquiry>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [LeadInquiry].
  Future<LeadInquiry> deleteRow(
    _i1.DatabaseSession session,
    LeadInquiry row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<LeadInquiry>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<LeadInquiry>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<LeadInquiryTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<LeadInquiry>(
      where: where(LeadInquiry.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<LeadInquiryTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<LeadInquiry>(
      where: where?.call(LeadInquiry.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [LeadInquiry] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<LeadInquiryTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<LeadInquiry>(
      where: where(LeadInquiry.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
