import 'package:lumica_app/data/datasources/mood_remote_datasource.dart';
import 'package:lumica_app/domain/entities/mood_entry.dart';
import 'package:lumica_app/domain/repositories/mood_repository.dart';

class MoodRepositoryImpl implements MoodRepository {
  final MoodRemoteDataSource _remoteDataSource;

  MoodRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<MoodEntry>> getMoodEntries(String userId) async {
    return await _remoteDataSource.getMoodEntries(userId);
  }

  @override
  Future<void> saveMoodEntry(MoodEntry entry) async {
    await _remoteDataSource.saveMoodEntry(entry);
  }

  @override
  Future<Map<String, double>> getMoodStatistics(String userId) async {
    return await _remoteDataSource.getMoodStatistics(userId);
  }
}
