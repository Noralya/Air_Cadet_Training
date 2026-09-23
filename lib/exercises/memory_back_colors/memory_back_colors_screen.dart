import "package:flutter/material.dart";

import "../../core/engine/attempt.dart";
import "../../core/engine/exercise.dart";
import "memory_back_colors_generator.dart";

enum _Phase { showingColor, answering, idle }

class MemoryBackColorsScreen extends StatefulWidget {
	const MemoryBackColorsScreen({
		super.key,
		required this.meta,
		required this.mode,
		required this.onAttempt,
		required this.onCycleComplete,
	});

	final ExerciseMeta meta;
	final SessionMode mode;
	final AttemptCallback onAttempt;
	final ExerciseCycleCompleteCallback onCycleComplete;

	@override
	State<MemoryBackColorsScreen> createState() =>
		_MemoryBackColorsScreenState();
}

class _MemoryBackColorsScreenState extends State<MemoryBackColorsScreen> {
	static const Duration colorDuration = Duration(seconds: 1);
	static const Duration answerDuration = Duration(milliseconds: 1500);

	late List<Color> _sequence;
	int _currentIndex = 0;
	_Phase _phase = _Phase.idle;
	int _generation = 0;
	bool? _lastFeedbackCorrect;
	final Stopwatch _answerStopwatch = Stopwatch();

	@override
	void initState() {
		super.initState();
		_sequence = MemoryBackColorsGenerator.generateSequence();
		_runStep();
	}

	@override
	void dispose() {
		_generation++;
		super.dispose();
	}

	bool get _requiresAnswer => _currentIndex >= 2;

	Future<void> _runStep() async {
		final myGeneration = _generation;
		setState(() {
			_phase = _Phase.showingColor;
			_lastFeedbackCorrect = null;
		});

		await Future.delayed(colorDuration);
		if (!mounted || myGeneration != _generation) return;

		if (!_requiresAnswer) {
			_advance(recordedCorrect: null);
			return;
		}

		setState(() => _phase = _Phase.answering);
		_answerStopwatch
		..reset()
		..start();

		await Future.delayed(answerDuration);
		if (!mounted || myGeneration != _generation) return;
		if (_phase == _Phase.answering) {
			_submitAnswer(null, timedOut: true);
		}
	}

	bool get _expectedIsSame =>
		_currentIndex >= 2 &&
		_sequence[_currentIndex] == _sequence[_currentIndex - 2];

	void _submitAnswer(bool? userSaysYes, {bool timedOut = false}) {
		if (_phase != _Phase.answering) return;
		final responseTime = _answerStopwatch.elapsed;
		final expected = _expectedIsSame;
		final isCorrect = !timedOut && userSaysYes == expected;

		widget.onAttempt(Attempt(
			exerciseId: widget.meta.id,
			categoryKey: widget.meta.category.name,
			psyType: widget.meta.psyType.name,
			isCorrect: isCorrect,
			responseTime: responseTime,
			timedOut: timedOut,
		));

		setState(() {
			_phase = _Phase.idle;
			_lastFeedbackCorrect = isCorrect;
		});

		_advance(recordedCorrect: isCorrect);
	}

	void _advance({required bool? recordedCorrect}) {
		final myGeneration = _generation;
		Future.delayed(const Duration(milliseconds: 250), () {
			if (!mounted || myGeneration != _generation) return;
			setState(() {
				_currentIndex++;
			});
			if (_currentIndex >= _sequence.length) {
				setState(() {
					_sequence = MemoryBackColorsGenerator.generateSequence();
					_currentIndex = 0;
				});
				widget.onCycleComplete();
			}
			_runStep();
		});
	}

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		final showColor = _phase == _Phase.showingColor;
		final currentColor = _currentIndex < _sequence.length
			? _sequence[_currentIndex]
			: _sequence.last;

		return Column(
		children: [
			Text(
			"Couleur ${_currentIndex + 1} / ${_sequence.length}",
			style: theme.textTheme.bodyMedium,
			),
			const SizedBox(height: 24),
			Expanded(
			child: Center(
				child: AnimatedSwitcher(
				duration: const Duration(milliseconds: 150),
				child: showColor
					? Container(
						key: ValueKey("color-$_currentIndex"),
						width: 180,
						height: 180,
						decoration: BoxDecoration(
							color: currentColor,
							borderRadius: BorderRadius.circular(24),
						),
						)
					: SizedBox(
						key: const ValueKey("buttons"),
						width: 260,
						child: _phase == _Phase.answering
							? Column(
								mainAxisSize: MainAxisSize.min,
								children: [
									const Text(
									"Identique a l'avant-derniere couleur ?",
									textAlign: TextAlign.center,
									),
									const SizedBox(height: 16),
									Row(
									children: [
										Expanded(
										child: ElevatedButton(
											onPressed: () => _submitAnswer(true),
											child: const Text("Oui"),
										),
										),
										const SizedBox(width: 12),
										Expanded(
										child: OutlinedButton(
											onPressed: () => _submitAnswer(false),
											child: const Text("Non"),
										),
										),
									],
									),
								],
								)
							: _lastFeedbackCorrect == null
								? const SizedBox(height: 80)
								: Icon(
									_lastFeedbackCorrect!
										? Icons.check_circle
										: Icons.cancel,
									color: _lastFeedbackCorrect!
										? const Color(0xFF34C759)
										: const Color(0xFFE5484D),
									size: 56,
									),
						),
				),
			),
			),
		],
		);
	}
}
