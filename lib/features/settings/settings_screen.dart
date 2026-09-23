import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../../core/persistence/app_settings.dart";
import "../../core/persistence/settings_provider.dart";
import "../../core/statistics/statistics_provider.dart";
import "../../shared/widgets/responsive.dart";
import "../../shared/widgets/section_title.dart";

class SettingsScreen extends StatelessWidget {
	const SettingsScreen({super.key});

	@override
	Widget build(BuildContext context) {
		final settingsProvider = context.watch<SettingsProvider>();

		return Scaffold(
		appBar: AppBar(title: const Text("Parametres")),
		body: SafeArea(
			child: Center(
			child: ConstrainedBox(
				constraints: BoxConstraints(
				maxWidth: Responsive.maxContentWidth(context),
				),
				child: ListView(
				padding: EdgeInsets.symmetric(
					horizontal: Responsive.horizontalPadding(context),
					vertical: 20,
				),
				children: [
					const SectionTitle("Apparence"),
					Card(
					child: Column(
						children: [
						RadioListTile<AppThemeMode>(
							title: const Text("Clair"),
							value: AppThemeMode.light,
							groupValue: settingsProvider.settings.themeMode,
							onChanged: (value) =>
								settingsProvider.setThemeMode(value!),
						),
						RadioListTile<AppThemeMode>(
							title: const Text("Sombre (bleu fonce)"),
							value: AppThemeMode.dark,
							groupValue: settingsProvider.settings.themeMode,
							onChanged: (value) =>
								settingsProvider.setThemeMode(value!),
						),
						RadioListTile<AppThemeMode>(
							title: const Text("Systeme"),
							value: AppThemeMode.system,
							groupValue: settingsProvider.settings.themeMode,
							onChanged: (value) =>
								settingsProvider.setThemeMode(value!),
						),
						],
					),
					),
					const SizedBox(height: 24),
					const SectionTitle("Donnees"),
					Card(
					child: Column(
						children: [
						ListTile(
							leading: const Icon(Icons.restart_alt),
							title: const Text("Reinitialiser les statistiques"),
							subtitle: const Text(
							"Efface l'historique des sessions et tentatives",
							),
							onTap: () => _confirmReset(
							context,
							title: "Reinitialiser les statistiques ?",
							message:
								"Cette action est irreversible. Vos statistiques et votre historique seront effaces.",
							onConfirm: () =>
								context.read<StatisticsProvider>().reset(),
							),
						),
						const Divider(height: 1),
						ListTile(
							leading: const Icon(Icons.delete_forever_outlined),
							title: const Text("Reinitialiser toutes les donnees"),
							subtitle: const Text(
							"Efface statistiques et parametres",
							),
							onTap: () => _confirmReset(
							context,
							title: "Reinitialiser toutes les donnees ?",
							message:
								"Cette action est irreversible. Toutes les donnees locales seront effacees.",
							onConfirm: () async {
								await context.read<StatisticsProvider>().reset();
								await context.read<SettingsProvider>().resetAll();
							},
							),
						),
						],
					),
					),
					const SizedBox(height: 24),
					const SectionTitle("A propos"),
					const Card(
					child: ListTile(
						leading: Icon(Icons.info_outline),
						title: Text("Air Cadet Training"),
						subtitle: Text(
						"Application d'entrainement hors ligne aux epreuves de selection des cadets Air France. Aucune donnee n'est envoyee en ligne.",
						),
					),
					),
					const SizedBox(height: 20),
				],
				),
			),
			),
		),
		);
	}

	Future<void> _confirmReset(
		BuildContext context, {
		required String title,
		required String message,
		required Future<void> Function() onConfirm,
	}) async {
		final confirmed = await showDialog<bool>(
		context: context,
		builder: (context) => AlertDialog(
			title: Text(title),
			content: Text(message),
			actions: [
			TextButton(
				onPressed: () => Navigator.of(context).pop(false),
				child: const Text("Annuler"),
			),
			TextButton(
				onPressed: () => Navigator.of(context).pop(true),
				child: const Text("Confirmer"),
			),
			],
		),
		);
		if (confirmed == true) {
		await onConfirm();
		}
	}
}
