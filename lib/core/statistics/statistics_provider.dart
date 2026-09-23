import "package:flutter/material.dart";

import "../persistence/session_record.dart";
import "../persistence/storage_service.dart";
import "statistics_engine.dart";

class StatisticsProvider extends ChangeNotifier {
	StatisticsProvider(this._storage) {
		refresh();
	}

	final StorageService _storage;
	List<SessionRecord> _sessions = [];
	bool _loaded = false;

	List<SessionRecord> get sessions => List.unmodifiable(_sessions);
	bool get loaded => _loaded;

	StatisticsEngine get engine => StatisticsEngine(_sessions);

	Future<void> refresh() async {
		_sessions = await _storage.loadSessions();
		_loaded = true;
		notifyListeners();
	}

	Future<void> recordSession(SessionRecord record) async {
		await _storage.saveSession(record);
		await refresh();
	}

	Future<void> reset() async {
		await _storage.resetStatistics();
		await refresh();
	}
}
