import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "app.dart";
import "core/persistence/settings_provider.dart";
import "core/persistence/storage_service.dart";
import "core/statistics/statistics_provider.dart";
import "exercises/exercises_bootstrap.dart";

Future<void> main() async {
	WidgetsFlutterBinding.ensureInitialized();

	registerAllExercises();

	final storageService = await StorageService.create();

	runApp(
		MultiProvider(
		providers: [
			Provider<StorageService>.value(value: storageService),
			ChangeNotifierProvider(
			create: (_) => SettingsProvider(storageService),
			),
			ChangeNotifierProvider(
			create: (_) => StatisticsProvider(storageService),
			),
		],
		child: const AirCadetTrainingApp(),
		),
	);
}
