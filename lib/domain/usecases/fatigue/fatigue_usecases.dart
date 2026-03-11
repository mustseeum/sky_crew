import '../../entities/fatigue_entry.dart';
import '../../../data/repositories/fatigue_repository.dart';

class AddFatigueEntryUseCase {
  const AddFatigueEntryUseCase(this._repository);

  final FatigueRepository _repository;

  Future<FatigueEntry> execute(FatigueEntry entry) async {
    return _repository.addFatigueEntry(entry);
  }
}

class GetFatigueEntriesUseCase {
  const GetFatigueEntriesUseCase(this._repository);

  final FatigueRepository _repository;

  Future<List<FatigueEntry>> execute(
    String userId, {
    DateTime? from,
    DateTime? to,
  }) async {
    return _repository.getFatigueEntries(userId, from: from, to: to);
  }
}
