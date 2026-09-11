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

/// A customer lead inquiry submitted from the mobile or web discovery intake.
abstract class LeadInquiry implements _i1.SerializableModel {
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

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
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
