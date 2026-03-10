import 'dart:convert';

import '../../domain/entities/license.dart';

/// SQLite/JSON data model for License.
class LicenseModel {
  const LicenseModel({
    required this.id,
    required this.userId,
    required this.type,
    required this.number,
    required this.issuingAuthority,
    required this.issueDate,
    required this.expiryDate,
    this.ratingsJson,
    this.remarks,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String userId;
  final String type;
  final String number;
  final String issuingAuthority;
  final String issueDate;
  final String expiryDate;
  final String? ratingsJson;
  final String? remarks;
  final String? createdAt;
  final String? updatedAt;

  factory LicenseModel.fromMap(Map<String, dynamic> map) {
    return LicenseModel(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      type: map['type'] as String,
      number: map['number'] as String,
      issuingAuthority: map['issuing_authority'] as String,
      issueDate: map['issue_date'] as String,
      expiryDate: map['expiry_date'] as String,
      ratingsJson: map['ratings'] as String?,
      remarks: map['remarks'] as String?,
      createdAt: map['created_at'] as String?,
      updatedAt: map['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'type': type,
      'number': number,
      'issuing_authority': issuingAuthority,
      'issue_date': issueDate,
      'expiry_date': expiryDate,
      'ratings': ratingsJson,
      'remarks': remarks,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  License toEntity() {
    List<String> ratings = [];
    if (ratingsJson != null && ratingsJson!.isNotEmpty) {
      final decoded = jsonDecode(ratingsJson!);
      if (decoded is List) {
        ratings = decoded.cast<String>();
      }
    }
    return License(
      id: id,
      userId: userId,
      type: type,
      number: number,
      issuingAuthority: issuingAuthority,
      issueDate: DateTime.parse(issueDate),
      expiryDate: DateTime.parse(expiryDate),
      ratings: ratings,
      remarks: remarks,
      createdAt: createdAt != null ? DateTime.parse(createdAt!) : null,
      updatedAt: updatedAt != null ? DateTime.parse(updatedAt!) : null,
    );
  }

  factory LicenseModel.fromEntity(License license) {
    return LicenseModel(
      id: license.id,
      userId: license.userId,
      type: license.type,
      number: license.number,
      issuingAuthority: license.issuingAuthority,
      issueDate: license.issueDate.toIso8601String().substring(0, 10),
      expiryDate: license.expiryDate.toIso8601String().substring(0, 10),
      ratingsJson: license.ratings.isNotEmpty
          ? jsonEncode(license.ratings)
          : null,
      remarks: license.remarks,
      createdAt: license.createdAt?.toIso8601String(),
      updatedAt: license.updatedAt?.toIso8601String(),
    );
  }
}
