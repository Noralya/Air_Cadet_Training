import "dart:async";

import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../../core/engine/attempt.dart";
import "../../core/engine/exercise.dart";
import "../../core/persistence/session_record.dart";
import "../../core/statistics/statistics_provider.dart";
import "../../shared/widgets/responsive.dart";
import "../../shared/widgets/timer_bar.dart";

class TrainingSessionScreen extends StatefulWidget {
	const TrainingSessionScreen({
		super.key,
		required this.exercises,
		this.timerDuration,
	});

	final List<Exercise> exercises;
	final Duration? timerDuration;

	@override
	State<TrainingSessionScreen> createState() => _TrainingSessionScreenState();
}

class _TrainingSessionScreenState extends State<TrainingSessionScreen> {
	final List<Attempt> _attempts = [];
	int _exerciseIndex = 0;
	int _cycleToken = 0;
	late final DateTime _startedAt;
	Timer? _countdown;
	Duration _remaining = Duration.zero;
	bool _finishing = false;

	@override
	void initState() {
		super.initState();
		_startedAt = DateTime.now();
		if (widget.timerDuration != null) {
			_remaining = widget.timerDuration!;
			_countdown = Timer.periodic(const Duration(seconds: 1), (timer) {
				setState(() {
					_remaining -= const Duration(seconds: 1);
				});
				if (_remaining <= Duration.zero) {
					timer.cancel();
					_quit();
				}
			});
		}
	}

	@override
	void dispose() {
		_countdown?.cancel();
		super.dispose();
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
		if (_finishing) return;
		_finishing = true;
		_countdown?.cancel();

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
		final hasTimer = widget.timerDuration != null;
		final progress = hasTimer
			? _remaining.inMilliseconds / widget.timerDuration!.inMilliseconds
			: 1.0;

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
					child: Column(
					crossAxisAlignment: CrossAxisAlignment.stretch,
					children: [
						if (hasTimer) ...[
							TimerBar(progress: progress),
							const SizedBox(height: 16),
						],
						Expanded(
						child: KeyedSubtree(
							key: ValueKey(
								"${_currentExercise.meta.id}-$_cycleToken",
							),
							child: _currentExercise.buildRunner(
								context: context,
								mode: SessionMode.training,
								onAttempt: _handleAttempt,
								onCycleComplete: _handleCycleComplete,
							),
						),
						),
					],
					),
				),
				),
			),
			),
		),
		);
	}
}