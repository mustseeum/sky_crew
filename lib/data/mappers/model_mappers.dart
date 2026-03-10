import '../models/flight_record_model.dart';
import '../models/license_model.dart';
import '../models/fatigue_model.dart';
import '../models/user_model.dart';
import '../../domain/entities/flight_record.dart';
import '../../domain/entities/license.dart';
import '../../domain/entities/fatigue_entry.dart';
import '../../domain/entities/user.dart';

/// Utility extension methods for mapping between models and entities.
extension FlightRecordMapper on FlightRecord {
  FlightRecordModel toModel() => FlightRecordModel.fromEntity(this);
}

extension LicenseMapper on License {
  LicenseModel toModel() => LicenseModel.fromEntity(this);
}

extension FatigueEntryMapper on FatigueEntry {
  FatigueModel toModel() => FatigueModel.fromEntity(this);
}

extension UserMapper on User {
  UserModel toModel({required String passwordHash}) =>
      UserModel.fromEntity(this, passwordHash: passwordHash);
}
