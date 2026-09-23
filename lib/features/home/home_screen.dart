import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../../core/statistics/statistics_provider.dart";
import "../../shared/widgets/responsive.dart";
import "../../shared/widgets/section_title.dart";
import "../../shared/widgets/stat_tile.dart";
import "../settings/settings_screen.dart";
import "../simulation/simulation_screen.dart";
import "../statistics/statistics_screen.dart";
import "../training/training_screen.dart";

class HomeScreen extends StatelessWidget {
	const HomeScreen({super.key});

	@override
	Widget build(BuildContext context) {
		final statisticsProvider = context.watch<StatisticsProvider>();
		final global = statisticsProvider.engine.computeGlobal();

		return Scaffold(
		appBar: AppBar(
			title: const Text("Air Cadet Training"),
			actions: [
			IconButton(
				icon: const Icon(Icons.settings_outlined),
				onPressed: () => Navigator.of(context).push(
				MaterialPageRoute(builder: (_) => const SettingsScreen()),
				),
			),
			],
		),
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
					Text(
					"Preparez votre selection",
					style: Theme.of(context)
						.textTheme
						.headlineSmall
						?.copyWith(fontWeight: FontWeight.w800),
					),
					const SizedBox(height: 6),
					Text(
					"Entrainez-vous aux epreuves cognitives, spatiales, numeriques, verbales et psychomotrices.",
					style: Theme.of(context).textTheme.bodyMedium,
					),
					const SizedBox(height: 24),
					const SectionTitle("Apercu"),
					GridView.count(
					crossAxisCount: Responsive.gridColumns(context) + 1,
					shrinkWrap: true,
					physics: const NeverScrollableScrollPhysics(),
					mainAxisSpacing: 12,
					crossAxisSpacing: 12,
					childAspectRatio: 1.3,
					children: [
						StatTile(
						label: "Questions",
						value: "${global.totalQuestions}",
						icon: Icons.quiz_outlined,
						),
						StatTile(
						label: "Sessions",
						value: "${global.totalSessions}",
						icon: Icons.playlist_add_check,
						),
						StatTile(
						label: "Reussite",
						value: "${(global.successRate * 100).round()} %",
						icon: Icons.trending_up,
						),
					],
					),
					const SizedBox(height: 28),
					const SectionTitle("Modes"),
					_HomeActionCard(
					title: "Entrainement",
					subtitle: "Choisissez un ou plusieurs exercices et progressez a votre rythme.",
					icon: Icons.fitness_center,
					onTap: () => Navigator.of(context).push(
						MaterialPageRoute(builder: (_) => const TrainingScreen()),
					),
					),
					const SizedBox(height: 12),
					_HomeActionCard(
					title: "Simulation PSY0",
					subtitle: "Epreuve chronometree, correction en fin de session.",
					icon: Icons.timer_outlined,
					onTap: () => Navigator.of(context).push(
						MaterialPageRoute(
						builder: (_) => const SimulationScreen(psyLabel: "PSY0"),
						),
					),
					),
					const SizedBox(height: 12),
					_HomeActionCard(
					title: "Simulation PSY1",
					subtitle: "Epreuve chronometree, correction en fin de session.",
					icon: Icons.timer_outlined,
					onTap: () => Navigator.of(context).push(
						MaterialPageRoute(
						builder: (_) => const SimulationScreen(psyLabel: "PSY1"),
						),
					),
					),
					const SizedBox(height: 12),
					_HomeActionCard(
					title: "Statistiques",
					subtitle: "Suivez votre progression et vos points a travailler.",
					icon: Icons.bar_chart,
					onTap: () => Navigator.of(context).push(
						MaterialPageRoute(builder: (_) => const StatisticsScreen()),
					),
					),
					const SizedBox(height: 24),
				],
				),
			),
			),
		),
		);
	}
}

class _HomeActionCard extends StatelessWidget {
	const _HomeActionCard({
		required this.title,
		required this.subtitle,
		required this.icon,
		required this.onTap,
	});

	final String title;
	final String subtitle;
	final IconData icon;
	final VoidCallback onTap;

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		return Card(
		child: InkWell(
			borderRadius: BorderRadius.circular(16),
			onTap: onTap,
			child: Padding(
			padding: const EdgeInsets.all(18),
			child: Row(
				children: [
				Container(
					padding: const EdgeInsets.all(12),
					decoration: BoxDecoration(
					color: theme.colorScheme.primary.withOpacity(0.12),
					borderRadius: BorderRadius.circular(12),
					),
					child: Icon(icon, color: theme.colorScheme.primary),
				),
				const SizedBox(width: 16),
				Expanded(
					child: Column(
					crossAxisAlignment: CrossAxisAlignment.start,
					children: [
						Text(
						title,
						style: theme.textTheme.titleMedium
							?.copyWith(fontWeight: FontWeight.w700),
						),
						const SizedBox(height: 4),
						Text(subtitle, style: theme.textTheme.bodySmall),
					],
					),
				),
				const Icon(Icons.chevron_right),
				],
			),
			),
		),
		);
	}
}
