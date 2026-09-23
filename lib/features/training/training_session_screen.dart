import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../../core/engine/attempt.dart";
import "../../core/engine/exercise.dart";
import "../../core/persistence/session_record.dart";
import "../../core/statistics/statistics_provider.dart";
import "../../shared/widgets/responsive.dart";

class TrainingSessionScreen extends StatefulWidget {
	const TrainingSessionScreen({super.key, required this.exercises});

	final List<Exercise> exercises;

	@override
	State<TrainingSessionScreen> createState() => _TrainingSessionScreenState();
}

class _TrainingSessionScreenState extends State<TrainingSessionScreen> {
	final List<Attempt> _attempts = [];
	int _exerciseIndex = 0;
	int _cycleToken = 0;
	late final DateTime _startedAt;

	@override
	void initState() {
		super.initState();
		_startedAt = DateTime.now();
	}

	Exercise get _currentExercise => widget.exercises[_exerciseIndex];

	void _handleAttempt(Attempt attempt) {
		_attempts.add(attempt);
	}

	void _handleCycleComplete() {
		if (widget.exercises.length <= 1) return;
		setState(() {
			_exerciseIndex = (_exerciseIndex + 1) % widget.exercises.length;
			_cycleToken++;
		});
	}

	Future<void> _quit() async {
		if (_attempts.isNotEmpty) {
			final record = SessionRecord(
				kind: SessionKind.training,
				psyType: null,
				startedAt: _startedAt,
				endedAt: DateTime.now(),
				attempts: _attempts,
			);
			await context.read<StatisticsProvider>().recordSession(record);
		}
		if (mounted) Navigator.of(context).pop();
	}

	@override
	Widget build(BuildContext context) {
		return PopScope(
		canPop: false,
		onPopInvokedWithResult: (didPop, _) {
			if (!didPop) _quit();
		},
		child: Scaffold(
			appBar: AppBar(
			title: Text(_currentExercise.meta.name),
			actions: [
				TextButton(
				onPressed: _quit,
				child: const Text("Quitter"),
				),
			],
			),
			body: SafeArea(
			child: Center(
				child: ConstrainedBox(
				constraints: BoxConstraints(
					maxWidth: Responsive.maxContentWidth(context),
				),
				child: Padding(
					padding: EdgeInsets.symmetric(
						horizontal: Responsive.horizontalPadding(context),
						vertical: 16,
					),
					child: KeyedSubtree(
						key: ValueKey("${_currentExercise.meta.id}-$_cycleToken"),
						child: _currentExercise.buildRunner(
							context: context,
							mode: SessionMode.training,
							onAttempt: _handleAttempt,
							onCycleComplete: _handleCycleComplete,
					),
					),
				),
				),
			),
			),
		),
		);
	}
}
