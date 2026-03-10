import '../../entities/license.dart';
import '../../../data/repositories/license_repository.dart';

class AddLicenseUseCase {
  const AddLicenseUseCase(this._repository);

  final LicenseRepository _repository;

  Future<License> execute(License license) async {
    return _repository.addLicense(license);
  }
}

class GetLicensesUseCase {
  const GetLicensesUseCase(this._repository);

  final LicenseRepository _repository;

  Future<List<License>> execute(String userId) async {
    return _repository.getLicenses(userId);
  }
}
