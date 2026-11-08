import 'entry.dart';

abstract interface class EntryRepository {
  Future<List<Entry>> readAll();
  Future<void> saveAll(List<Entry> entries);
}
