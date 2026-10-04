import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../../core/engine/exercise.dart";
import "../../core/engine/exercise_registry.dart";
import "../../core/engine/psy_category.dart";
import "../../core/recommendations/recommendation_engine.dart";
import "../../core/statistics/statistics_provider.dart";
import "../../shared/widgets/responsive.dart";
import "../../shared/widgets/section_title.dart";
import "training_session_screen.dart";

const List<Duration> _availableTimerDurations = [
	Duration(minutes: 5),
	Duration(minutes: 10),
	Duration(minutes: 15),
	Duration(minutes: 20),
	Duration(minutes: 30),
];

class TrainingScreen extends StatefulWidget {
	const TrainingScreen({super.key});

	@override
	State<TrainingScreen> createState() => _TrainingScreenState();
}

class _TrainingScreenState extends State<TrainingScreen> {
	final Set<String> _selected = {};
	bool _timerEnabled = false;
	Duration _timerDuration = _availableTimerDurations[1];

	Duration? get _effectiveTimerDuration =>
		_timerEnabled ? _timerDuration : null;

	void _start(List<Exercise> exercises) {
		if (exercises.isEmpty) return;
		Navigator.of(context).push(
			MaterialPageRoute(
				builder: (_) => TrainingSessionScreen(
					exercises: exercises,
					timerDuration: _effectiveTimerDuration,
				),
			),
		);
	}

	@override
	Widget build(BuildContext context) {
		final registry = ExerciseRegistry.instance;
		final statisticsProvider = context.watch<StatisticsProvider>();

		return Scaffold(
		appBar: AppBar(title: const Text("Entrainement")),
		body: SafeArea(
			child: Center(
			child: ConstrainedBox(
				constraints: BoxConstraints(
					maxWidth: Responsive.maxContentWidth(context),
				),
				child: Column(
				children: [
					Expanded(
					child: ListView(
						padding: EdgeInsets.symmetric(
							horizontal: Responsive.horizontalPadding(context),
							vertical: 16,
						),
						children: [
						Card(
							child: ListTile(
							leading: const Icon(Icons.auto_awesome),
							title: const Text("Entrainement personnalisé"),
							subtitle: const Text(
								"Basé sur vos points à travailler",
							),
							trailing: const Icon(Icons.chevron_right),
							onTap: () {
								final recommender = RecommendationEngine(
									statisticsProvider.engine,
									registry,
								);
								final exercises =
									recommender.buildPersonalizedSelection();
								_start(exercises);
							},
							),
						),
						const SizedBox(height: 20),
						const SectionTitle("Chronometre"),
						Card(
							child: Column(
							children: [
								CheckboxListTile(
									value: _timerEnabled,
									onChanged: (value) => setState(
										() => _timerEnabled = value ?? false,
									),
									title: const Text("Activer un chronometre"),
									subtitle: const Text(
										"Une jauge discrete s'affiche en haut de l'ecran pendant la session",
									),
									controlAffinity:
										ListTileControlAffinity.leading,
								),
								if (_timerEnabled)
								Padding(
									padding:
										const EdgeInsets.fromLTRB(16, 0, 16, 16),
									child: Row(
									mainAxisAlignment:
										MainAxisAlignment.spaceBetween,
									children: [
										const Text("Durée"),
										DropdownButton<Duration>(
										value: _timerDuration,
										onChanged: (value) {
											if (value == null) return;
											setState(
												() => _timerDuration = value,
											);
										},
										items: _availableTimerDurations
											.map(
												(d) => DropdownMenuItem(
													value: d,
													child: Text("${d.inMinutes} min"),
												),
											)
											.toList(),
										),
									],
									),
								),
							],
							),
						),
						const SizedBox(height: 20),
						for (final psyType in PsyType.values) ...[
							SectionTitle(
								psyType == PsyType.psy0 ? "PSY0" : "PSY1",
							),
							for (final category in psyCategoryLayout[psyType]!)
							_CategoryBlock(
								psyType: psyType,
								category: category,
								selected: _selected,
								onToggle: (id) {
									setState(() {
										if (_selected.contains(id)) {
											_selected.remove(id);
										} else {
											_selected.add(id);
										}
									});
								},
							),
							const SizedBox(height: 16),
						],
						],
					),
					),
					Padding(
					padding: EdgeInsets.symmetric(
						horizontal: Responsive.horizontalPadding(context),
						vertical: 16,
					),
					child: SizedBox(
						width: double.infinity,
						child: ElevatedButton(
							onPressed: _selected.isEmpty
								? null
								: () {
									final exercises = _selected
										.map((id) => registry.byId(id))
										.whereType<Exercise>()
										.toList();
									_start(exercises);
									},
							child: Text(
								_selected.isEmpty
									? "Selectionnez au moins un exercice"
									: "Commencer (${_selected.length})",
							),
						),
					),
					),
				],
				),
			),
			),
		),
		);
	}
}

class _CategoryBlock extends StatelessWidget {
	const _CategoryBlock({
		required this.psyType,
		required this.category,
		required this.selected,
		required this.onToggle,
	});

	final PsyType psyType;
	final ExerciseCategory category;
	final Set<String> selected;
	final void Function(String id) onToggle;

	@override
	Widget build(BuildContext context) {
		final exercises = ExerciseRegistry.instance.byCategory(psyType, category);
		final theme = Theme.of(context);

		return Padding(
		padding: const EdgeInsets.only(bottom: 8),
		child: Column(
			crossAxisAlignment: CrossAxisAlignment.start,
			children: [
			Text(
				category.label,
				style: theme.textTheme.labelLarge?.copyWith(
					color: theme.textTheme.labelLarge?.color?.withOpacity(0.7),
				),
			),
			const SizedBox(height: 6),
			if (exercises.isEmpty)
				Container(
					padding: const EdgeInsets.all(12),
					decoration: BoxDecoration(
						borderRadius: BorderRadius.circular(12),
						border: Border.all(color: theme.dividerColor),
					),
					child: Text(
						"Aucun exercice disponible pour le moment",
						style: theme.textTheme.bodySmall,
					),
				)
			else
				...exercises.map((exercise) {
					final isSelected = selected.contains(exercise.meta.id);
					return Card(
						margin: const EdgeInsets.only(bottom: 8),
						child: CheckboxListTile(
							value: isSelected,
							onChanged: (_) => onToggle(exercise.meta.id),
							title: Text(exercise.meta.name),
							subtitle: Text(exercise.meta.shortDescription),
							controlAffinity: ListTileControlAffinity.leading,
						),
					);
				}),
			],
		),
		);
	}
}
