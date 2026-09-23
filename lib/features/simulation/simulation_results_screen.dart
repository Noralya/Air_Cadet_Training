import "package:flutter/material.dart";

import "../../core/engine/attempt.dart";
import "../../core/persistence/session_record.dart";
import "../../shared/widgets/labeled_progress_bar.dart";
import "../../shared/widgets/responsive.dart";
import "../../shared/widgets/section_title.dart";
import "../../shared/widgets/stat_tile.dart";

class SimulationResultsScreen extends StatelessWidget {
	const SimulationResultsScreen({super.key, required this.record});

	final SessionRecord record;

	Map<String, List<Attempt>> get _byCategory {
		final map = <String, List<Attempt>>{};
		for (final attempt in record.attempts) {
			map.putIfAbsent(attempt.categoryKey, () => []).add(attempt);
		}
		return map;
	}

	Map<String, List<Attempt>> get _byExercise {
		final map = <String, List<Attempt>>{};
		for (final attempt in record.attempts) {
			map.putIfAbsent(attempt.exerciseId, () => []).add(attempt);
		}
		return map;
	}

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);

		return Scaffold(
		appBar: AppBar(
			title: const Text("Resultats"),
			automaticallyImplyLeading: false,
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
					if (record.attempts.isEmpty)
					const Text("Aucune question repondue pendant cette session.")
					else ...[
					GridView.count(
						crossAxisCount: Responsive.gridColumns(context) + 1,
						shrinkWrap: true,
						physics: const NeverScrollableScrollPhysics(),
						mainAxisSpacing: 12,
						crossAxisSpacing: 12,
						childAspectRatio: 1.3,
						children: [
						StatTile(
							label: "Score",
							value: "${(record.successRate * 100).round()} %",
							icon: Icons.emoji_events_outlined,
						),
						StatTile(
							label: "Questions",
							value: "${record.totalQuestions}",
							icon: Icons.quiz_outlined,
						),
						StatTile(
							label: "Temps moyen",
							value:
								"${(record.averageResponseTime.inMilliseconds / 1000).toStringAsFixed(1)} s",
							icon: Icons.speed,
						),
						],
					),
					const SizedBox(height: 28),
					const SectionTitle("Performances par categorie"),
					for (final entry in _byCategory.entries)
						LabeledProgressBar(
						label: entry.key,
						value: entry.value.where((a) => a.isCorrect).length /
							entry.value.length,
						),
					const SizedBox(height: 20),
					const SectionTitle("Performances par exercice"),
					for (final entry in _byExercise.entries)
						LabeledProgressBar(
						label: entry.key,
						value: entry.value.where((a) => a.isCorrect).length /
							entry.value.length,
						),
					],
					const SizedBox(height: 28),
					SizedBox(
					width: double.infinity,
					child: ElevatedButton(
						onPressed: () =>
							Navigator.of(context).popUntil((r) => r.isFirst),
						child: const Text("Retour a l'accueil"),
					),
					),
					const SizedBox(height: 16),
				],
				),
			),
			),
		),
		);
	}
}
