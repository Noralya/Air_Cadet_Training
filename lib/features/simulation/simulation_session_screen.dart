import "dart:async";

import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../../core/engine/attempt.dart";
import "../../core/engine/exercise.dart";
import "../../core/engine/psy_category.dart";
import "../../core/persistence/session_record.dart";
import "../../core/statistics/statistics_provider.dart";
import "../../shared/widgets/responsive.dart";
import "simulation_results_screen.dart";

class SimulationSessionScreen extends StatefulWidget {
	const SimulationSessionScreen({
		super.key,
		required this.psyType,
		required this.exercises,
	});

	final PsyType psyType;
	final List<Exercise> exercises;

	static const Duration totalDuration = Duration(minutes: 8);

	@override
	State<SimulationSessionScreen> createState() =>
		_SimulationSessionScreenState();
}

class _SimulationSessionScreenState extends State<SimulationSessionScreen> {
	final List<Attempt> _attempts = [];
	int _exerciseIndex = 0;
	int _cycleToken = 0;
	late final DateTime _startedAt;
	Timer? _timer;
	Duration _remaining = SimulationSessionScreen.totalDuration;
	bool _finished = false;

	@override
	void initState() {
		super.initState();
		_startedAt = DateTime.now();
		_timer = Timer.periodic(const Duration(seconds: 1), (timer) {
			setState(() {
				_remaining -= const Duration(seconds: 1);
			});
			if (_remaining <= Duration.zero) {
				timer.cancel();
				_finish();
			}
		});
	}

	@override
	void dispose() {
		_timer?.cancel();
		super.dispose();
	}

	Exercise get _currentExercise => widget.exercises[_exerciseIndex];

	void _handleAttempt(Attempt attempt) {
		_attempts.add(attempt);
	}

	void _handleCycleComplete() {
		if (_finished) return;
		setState(() {
			_exerciseIndex = (_exerciseIndex + 1) % widget.exercises.length;
			_cycleToken++;
		});
	}

	Future<void> _finish() async {
		if (_finished) return;
		_finished = true;
		_timer?.cancel();

		final record = SessionRecord(
		kind: SessionKind.simulation,
		psyType: widget.psyType.name,
		startedAt: _startedAt,
		endedAt: DateTime.now(),
		attempts: _attempts,
		);

		if (_attempts.isNotEmpty) {
		await context.read<StatisticsProvider>().recordSession(record);
		}

		if (!mounted) return;
		Navigator.of(context).pushReplacement(
			MaterialPageRoute(
				builder: (_) => SimulationResultsScreen(record: record),
			),
		);
	}

	String _formatDuration(Duration d) {
		final minutes = d.inMinutes.remainder(60).toString().padLeft(2, "0");
		final seconds = d.inSeconds.remainder(60).toString().padLeft(2, "0");
		return "$minutes:$seconds";
	}

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);

		return PopScope(
		canPop: false,
		onPopInvokedWithResult: (didPop, _) {
			if (!didPop) _finish();
		},
		child: Scaffold(
			appBar: AppBar(
			title: Text("Simulation ${widget.psyType == PsyType.psy0 ? 'PSY0' : 'PSY1'}"),
			actions: [
				Padding(
				padding: const EdgeInsets.symmetric(horizontal: 16),
				child: Center(
					child: Text(
					_formatDuration(_remaining),
					style: theme.textTheme.titleMedium?.copyWith(
						fontWeight: FontWeight.w800,
						color: _remaining.inSeconds < 30
							? theme.colorScheme.error
							: null,
					),
					),
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
				child: Padding(
					padding: EdgeInsets.symmetric(
					horizontal: Responsive.horizontalPadding(context),
					vertical: 16,
					),
					child: KeyedSubtree(
					key: ValueKey("${_currentExercise.meta.id}-$_cycleToken"),
					child: _currentExercise.buildRunner(
						context: context,
						mode: SessionMode.simulation,
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
