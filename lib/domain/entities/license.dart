/// Status of a license.
enum LicenseStatus {
  valid,
  expiringSoon,
  expired;

  String get displayName {
    switch (this) {
      case LicenseStatus.valid:
        return 'Valid';
      case LicenseStatus.expiringSoon:
        return 'Expiring Soon';
      case LicenseStatus.expired:
        return 'Expired';
    }
  }
}

/// Represents a crew member's license or certification.
class License {
  const License({
    required this.id,
    required this.userId,
    required this.type,
    required this.number,
    required this.issuingAuthority,
    required this.issueDate,
    required this.expiryDate,
    this.ratings = const [],
    this.remarks,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String userId;
  final String type;
  final String number;
  final String issuingAuthority;
  final DateTime issueDate;
  final DateTime expiryDate;
  final List<String> ratings;
  final String? remarks;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  /// Number of days until expiry (negative if already expired).
  int get daysUntilExpiry =>
      expiryDate.difference(DateTime.now()).inDays;

  bool get isExpired => DateTime.now().isAfter(expiryDate);

  bool get isExpiringSoon =>
      !isExpired && daysUntilExpiry <= 90;

  LicenseStatus get status {
    if (isExpired) return LicenseStatus.expired;
    if (isExpiringSoon) return LicenseStatus.expiringSoon;
    return LicenseStatus.valid;
  }

  License copyWith({
    String? id,
    String? userId,
    String? type,
    String? number,
    String? issuingAuthority,
    DateTime? issueDate,
    DateTime? expiryDate,
    List<String>? ratings,
    String? remarks,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return License(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      number: number ?? this.number,
      issuingAuthority: issuingAuthority ?? this.issuingAuthority,
      issueDate: issueDate ?? this.issueDate,
      expiryDate: expiryDate ?? this.expiryDate,
      ratings: ratings ?? this.ratings,
      remarks: remarks ?? this.remarks,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is License &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
