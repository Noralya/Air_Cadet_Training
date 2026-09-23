import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "core/persistence/settings_provider.dart";
import "core/theme/app_theme.dart";
import "features/home/home_screen.dart";

class AirCadetTrainingApp extends StatelessWidget {
	const AirCadetTrainingApp({super.key});

	@override
	Widget build(BuildContext context) {
		final settingsProvider = context.watch<SettingsProvider>();

		return MaterialApp(
			title: "Air Cadet Training",
			debugShowCheckedModeBanner: false,
			theme: AppTheme.light(),
			darkTheme: AppTheme.dark(),
			themeMode: settingsProvider.themeMode,
			home: const HomeScreen(),
		);
	}
}
