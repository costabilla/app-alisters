import 'dart:convert';

import '../domain/entry.dart';
import '../domain/entry_repository.dart';
import 'storage_io.dart'
    if (dart.library.js_interop) 'storage_web.dart'
    as storage;

class LocalEntryRepository implements EntryRepository {
  const LocalEntryRepository();
  @override
  Future<List<Entry>> readAll() async {
    final data = await storage.read();
    if (data == null) return [];
    return (jsonDecode(data) as List)
        .map((e) => Entry.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  @override
  Future<void> saveAll(List<Entry> entries) =>
      storage.write(jsonEncode(entries.map((e) => e.toJson()).toList()));
}
