enum AppThemeMode { light, dark, system }

class AppSettings {
	const AppSettings({this.themeMode = AppThemeMode.system});

	final AppThemeMode themeMode;

	AppSettings copyWith({AppThemeMode? themeMode}) =>
		AppSettings(themeMode: themeMode ?? this.themeMode);

	Map<String, dynamic> toJson() => {"themeMode": themeMode.name};

	factory AppSettings.fromJson(Map<String, dynamic> json) => AppSettings(
			themeMode: AppThemeMode.values.firstWhere(
			(m) => m.name == json["themeMode"],
			orElse: () => AppThemeMode.system,
			),
		);
}
