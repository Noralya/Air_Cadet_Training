import "package:flutter/material.dart";

import "app_settings.dart";
import "storage_service.dart";

class SettingsProvider extends ChangeNotifier {
	SettingsProvider(this._storage) {
		_load();
	}

	final StorageService _storage;
	AppSettings _settings = const AppSettings();
	bool _loaded = false;

	AppSettings get settings => _settings;
	bool get loaded => _loaded;

	ThemeMode get themeMode {
		switch (_settings.themeMode) {
		case AppThemeMode.light:
			return ThemeMode.light;
		case AppThemeMode.dark:
			return ThemeMode.dark;
		case AppThemeMode.system:
			return ThemeMode.system;
		}
	}

	Future<void> _load() async {
		_settings = await _storage.loadSettings();
		_loaded = true;
		notifyListeners();
	}

	Future<void> setThemeMode(AppThemeMode mode) async {
		_settings = _settings.copyWith(themeMode: mode);
		notifyListeners();
		await _storage.saveSettings(_settings);
	}

	Future<void> resetStatistics() async {
		await _storage.resetStatistics();
	}

	Future<void> resetAll() async {
		await _storage.resetAll();
		_settings = const AppSettings();
		notifyListeners();
	}
}
