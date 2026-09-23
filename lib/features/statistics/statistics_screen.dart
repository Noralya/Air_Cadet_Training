import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../../core/engine/exercise_registry.dart";
import "../../core/engine/psy_category.dart";
import "../../core/recommendations/recommendation_engine.dart";
import "../../core/statistics/statistics_provider.dart";
import "../../shared/widgets/labeled_progress_bar.dart";
import "../../shared/widgets/responsive.dart";
import "../../shared/widgets/section_title.dart";
import "../../shared/widgets/stat_tile.dart";

class StatisticsScreen extends StatelessWidget {
	const StatisticsScreen({super.key});

	@override
	Widget build(BuildContext context) {
		final statisticsProvider = context.watch<StatisticsProvider>();
		final engine = statisticsProvider.engine;
		final global = engine.computeGlobal();
		final recommender = RecommendationEngine(engine, ExerciseRegistry.instance);
		final weak = recommender.weakCategories();
		final strong = recommender.strongCategories();

		return Scaffold(
		appBar: AppBar(title: const Text("Statistiques")),
		body: SafeArea(
			child: Center(
			child: ConstrainedBox(
				constraints: BoxConstraints(
				maxWidth: Responsive.maxContentWidth(context),
				),
				child: statisticsProvider.loaded && global.totalQuestions == 0
					? const _EmptyState()
					: ListView(
						padding: EdgeInsets.symmetric(
						horizontal: Responsive.horizontalPadding(context),
						vertical: 20,
						),
						children: [
						const SectionTitle("Vue d'ensemble"),
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
							StatTile(
								label: "Temps moyen",
								value:
									"${(global.averageResponseTime.inMilliseconds / 1000).toStringAsFixed(1)} s",
								icon: Icons.speed,
							),
							],
						),
						const SizedBox(height: 28),
						const SectionTitle("Points a travailler"),
						if (weak.isEmpty)
							const Text("Pas encore assez de donnees.")
						else
							for (final entry in weak)
							LabeledProgressBar(
								label: entry.category.label,
								value: entry.successRate,
								color: const Color(0xFFE5484D),
							),
						const SizedBox(height: 24),
						const SectionTitle("Points solides"),
						if (strong.isEmpty)
							const Text("Pas encore assez de donnees.")
						else
							for (final entry in strong)
							LabeledProgressBar(
								label: entry.category.label,
								value: entry.successRate,
								color: const Color(0xFF34C759),
							),
						const SizedBox(height: 28),
						const SectionTitle("Par categorie"),
						for (final category in ExerciseCategory.values)
							Builder(builder: (context) {
								final stats = engine.computeCategory(category.name);
								if (stats.totalQuestions == 0) {
									return const SizedBox.shrink();
								}
								return LabeledProgressBar(
									label:
										"${category.label} (${stats.totalQuestions} questions)",
									value: stats.successRate,
								);
							}),
						const SizedBox(height: 20),
						],
					),
			),
			),
		),
		);
	}
}

class _EmptyState extends StatelessWidget {
	const _EmptyState();

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		return Center(
		child: Padding(
			padding: const EdgeInsets.all(32),
			child: Column(
			mainAxisSize: MainAxisSize.min,
			children: [
				Icon(Icons.bar_chart, size: 48, color: theme.colorScheme.primary),
				const SizedBox(height: 16),
				Text(
					"Aucune statistique pour le moment",
					style: theme.textTheme.titleMedium,
					textAlign: TextAlign.center,
				),
				const SizedBox(height: 4),
				Text(
					"Commencez un entrainement pour voir apparaitre votre progression.",
					style: theme.textTheme.bodySmall,
					textAlign: TextAlign.center,
				),
			],
			),
		),
		);
	}
}
