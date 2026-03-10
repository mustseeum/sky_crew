import '../../entities/flight_record.dart';
import '../../../data/repositories/logbook_repository.dart';

class AddFlightRecordUseCase {
  const AddFlightRecordUseCase(this._repository);

  final LogbookRepository _repository;

  Future<FlightRecord> execute(FlightRecord record) async {
    return _repository.addFlightRecord(record);
  }
}

class GetFlightRecordsUseCase {
  const GetFlightRecordsUseCase(this._repository);

  final LogbookRepository _repository;

  Future<List<FlightRecord>> execute(String userId) async {
    return _repository.getFlightRecords(userId);
  }
}

class DeleteFlightRecordUseCase {
  const DeleteFlightRecordUseCase(this._repository);

  final LogbookRepository _repository;

  Future<void> execute(String recordId) async {
    return _repository.deleteFlightRecord(recordId);
  }
}
