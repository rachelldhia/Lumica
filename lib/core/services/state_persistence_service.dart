import 'package:get_storage/get_storage.dart';

/// Service for persisting and restoring app state
class StatePersistenceService {
  final GetStorage _storage = GetStorage();

  // Storage keys
  static const String _journalFilterPrefix = 'journal_filter_';
  static const String _selectedDateKey = '${_journalFilterPrefix}selected_date';
  static const String _searchQueryKey = '${_journalFilterPrefix}search_query';

  // Journal state persistence
  Future<void> saveJournalSelectedDate(DateTime date) async {
    await _storage.write(_selectedDateKey, date.toIso8601String());
  }

  DateTime? loadJournalSelectedDate() {
    final dateStr = _storage.read<String>(_selectedDateKey);
    if (dateStr == null) return null;

    try {
      return DateTime.parse(dateStr);
    } catch (e) {
      return null;
    }
  }

  Future<void> saveJournalSearchQuery(String query) async {
    await _storage.write(_searchQueryKey, query);
  }

  String? loadJournalSearchQuery() {
    return _storage.read<String>(_searchQueryKey);
  }

  Future<void> clearJournalFilters() async {
    await _storage.remove(_selectedDateKey);
    await _storage.remove(_searchQueryKey);
  }

  // Generic state persistence
  Future<void> saveState(String key, dynamic value) async {
    await _storage.write(key, value);
  }

  T? loadState<T>(String key) {
    return _storage.read<T>(key);
  }

  Future<void> removeState(String key) async {
    await _storage.remove(key);
  }

  Future<void> clearAllState() async {
    // Clear all app-specific state
    // Note: This won't clear auth tokens or critical data
    await clearJournalFilters();
  }
}
