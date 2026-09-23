import "package:flutter/material.dart";

import "../../core/engine/attempt.dart";
import "../../core/engine/exercise.dart";
import "../../shared/widgets/correction_banner.dart";
import "angle_dial_painter.dart";
import "angles_generator.dart";

class AnglesScreen extends StatefulWidget {
	const AnglesScreen({
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
	State<AnglesScreen> createState() => _AnglesScreenState();
}

class _AnglesScreenState extends State<AnglesScreen> {
	late AnglesQuestion _question;
	int _index = 0;
	static const int _seriesLength = 5;
	int? _selectedOption;
	bool? _isCorrect;
	final Stopwatch _stopwatch = Stopwatch()..start();

	@override
	void initState() {
		super.initState();
		_question = AnglesGenerator.generate();
	}

	void _select(int delta) {
		if (_selectedOption != null) return;
		final isCorrect = delta == _question.correctDelta;
		widget.onAttempt(Attempt(
			exerciseId: widget.meta.id,
			categoryKey: widget.meta.category.name,
			psyType: widget.meta.psyType.name,
			isCorrect: isCorrect,
			responseTime: _stopwatch.elapsed,
			timedOut: false,
		));

		setState(() {
			_selectedOption = delta;
			_isCorrect = isCorrect;
		});

		Future.delayed(const Duration(milliseconds: 700), () {
		if (!mounted) return;
		setState(() {
			_index++;
			_selectedOption = null;
			_isCorrect = null;
			if (_index >= _seriesLength) {
			_index = 0;
			widget.onCycleComplete();
			}
			_question = AnglesGenerator.generate();
			_stopwatch
			..reset()
			..start();
		});
		});
	}

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		final showCorrection = widget.mode == SessionMode.training;

		return Column(
		children: [
			Text(
			"Question ${_index + 1} / $_seriesLength",
			style: theme.textTheme.bodyMedium,
			),
			const SizedBox(height: 12),
			Row(
			mainAxisAlignment: MainAxisAlignment.center,
			children: [
				Column(
				children: [
					SizedBox(
					width: 96,
					height: 96,
					child: CustomPaint(
						painter: ReferenceWatchPainter(
						color: theme.colorScheme.primary,
						),
					),
					),
					const SizedBox(height: 6),
					Text("Sens direct", style: theme.textTheme.bodySmall),
				],
				),
				const SizedBox(width: 24),
				SizedBox(
				width: 160,
				height: 160,
				child: CustomPaint(
					painter: AngleDialPainter(
						originDegrees: _question.originDegrees,
						arrivalDegrees: _question.arrivalDegrees,
						color: theme.colorScheme.primary,
					),
				),
				),
			],
			),
			const SizedBox(height: 20),
			Text(
				"Quel est l'angle entre O et A ?",
				style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
			),
			const SizedBox(height: 16),
			Wrap(
			spacing: 12,
			runSpacing: 12,
			alignment: WrapAlignment.center,
			children: _question.options.map((delta) {
				final isSelected = _selectedOption == delta;
				final isThisCorrect = delta == _question.correctDelta;
				Color? bg;
				if (_selectedOption != null && showCorrection) {
				if (isThisCorrect) {
					bg = const Color(0xFF34C759).withOpacity(0.2);
				} else if (isSelected) {
					bg = const Color(0xFFE5484D).withOpacity(0.2);
				}
				}
				return SizedBox(
					width: 96,
					child: OutlinedButton(
						onPressed: _selectedOption == null ? () => _select(delta) : null,
						style: OutlinedButton.styleFrom(
						backgroundColor: bg,
						padding: const EdgeInsets.symmetric(vertical: 14),
						),
						child: Text("$delta°"),
					),
				);
			}).toList(),
			),
			const SizedBox(height: 20),
			if (_isCorrect != null && showCorrection)
			CorrectionBanner(isCorrect: _isCorrect!),
		],
		);
	}
}
