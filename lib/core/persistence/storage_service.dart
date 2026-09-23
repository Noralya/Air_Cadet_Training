import "dart:convert";

import "package:shared_preferences/shared_preferences.dart";

import "app_settings.dart";
import "session_record.dart";

class StorageService {
	StorageService(this._prefs);

	static const String _sessionsKey = "sessions";
	static const String _settingsKey = "settings";

	final SharedPreferences _prefs;

	static Future<StorageService> create() async {
		final prefs = await SharedPreferences.getInstance();
		return StorageService(prefs);
	}

	Future<List<SessionRecord>> loadSessions() async {
		final raw = _prefs.getString(_sessionsKey);
		if (raw == null || raw.isEmpty) return [];
		final list = jsonDecode(raw) as List;
		return list
			.map((e) => SessionRecord.fromJson(e as Map<String, dynamic>))
			.toList();
	}

	Future<void> saveSession(SessionRecord session) async {
		final sessions = await loadSessions();
		sessions.add(session);
		await _persistSessions(sessions);
	}

	Future<void> _persistSessions(List<SessionRecord> sessions) async {
		final encoded = jsonEncode(sessions.map((s) => s.toJson()).toList());
		await _prefs.setString(_sessionsKey, encoded);
	}

	Future<AppSettings> loadSettings() async {
		final raw = _prefs.getString(_settingsKey);
		if (raw == null || raw.isEmpty) return const AppSettings();
		return AppSettings.fromJson(jsonDecode(raw) as Map<String, dynamic>);
	}

	Future<void> saveSettings(AppSettings settings) async {
		await _prefs.setString(_settingsKey, jsonEncode(settings.toJson()));
	}

	Future<void> resetStatistics() async {
		await _prefs.remove(_sessionsKey);
	}

	Future<void> resetAll() async {
		await _prefs.clear();
	}
}
