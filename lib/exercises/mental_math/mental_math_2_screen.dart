import "package:flutter/material.dart";

import "../../core/engine/attempt.dart";
import "../../core/engine/exercise.dart";
import "../../shared/widgets/correction_banner.dart";
import "interval_single_generator.dart";

class MentalMath2Screen extends StatefulWidget {
	const MentalMath2Screen({
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
	State<MentalMath2Screen> createState() => _MentalMath2ScreenState();
}

class _MentalMath2ScreenState extends State<MentalMath2Screen> {
	static const int _seriesLength = 10;

	late IntervalSingleQuestion _question;
	int _index = 0;
	int? _selectedIndex;
	bool? _isCorrect;
	bool _locked = false;
	final Stopwatch _stopwatch = Stopwatch()..start();

	@override
	void initState() {
		super.initState();
		_question = IntervalSingleGenerator.generate();
	}

	void _select(int index) {
		if (_locked) return;
		final isCorrect = index == _question.correctIndex;

		widget.onAttempt(Attempt(
			exerciseId: widget.meta.id,
			categoryKey: widget.meta.category.name,
			psyType: widget.meta.psyType.name,
			isCorrect: isCorrect,
			responseTime: _stopwatch.elapsed,
			timedOut: false,
		));

		setState(() {
			_locked = true;
			_selectedIndex = index;
			_isCorrect = isCorrect;
		});

		final showsFeedback = widget.mode == SessionMode.training;
		Future.delayed(
			showsFeedback
				? const Duration(milliseconds: 1100)
				: const Duration(milliseconds: 200),
			() {
				if (!mounted) return;
				setState(() {
					_index++;
					_locked = false;
					_selectedIndex = null;
					_isCorrect = null;
					if (_index >= _seriesLength) {
						_index = 0;
						widget.onCycleComplete();
					}
					_question = IntervalSingleGenerator.generate();
					_stopwatch
						..reset()
						..start();
				});
			},
		);
	}

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		final showCorrection = widget.mode == SessionMode.training;

		return Column(
		crossAxisAlignment: CrossAxisAlignment.stretch,
		children: [
			Text(
				"Question ${_index + 1} / $_seriesLength",
				style: theme.textTheme.bodyMedium,
			),
			const SizedBox(height: 16),
			Container(
				padding: const EdgeInsets.all(20),
				decoration: BoxDecoration(
					color: theme.cardTheme.color,
					borderRadius: BorderRadius.circular(16),
					border: Border.all(color: theme.dividerColor),
				),
				child: Text(
					_question.expression,
					textAlign: TextAlign.center,
					style: theme.textTheme.headlineSmall
						?.copyWith(fontWeight: FontWeight.w700),
				),
			),
			const SizedBox(height: 8),
			Text(
				"Quel est le plus petit intervalle contenant le resultat ?",
				textAlign: TextAlign.center,
				style: theme.textTheme.titleMedium,
			),
			const SizedBox(height: 16),
			Wrap(
				spacing: 10,
				runSpacing: 10,
				alignment: WrapAlignment.center,
				children: List.generate(_question.options.length, (i) {
					final option = _question.options[i];
					final isSelected = _selectedIndex == i;
					final isCorrectOption = i == _question.correctIndex;
					Color? bg;
					if (_locked && showCorrection) {
						if (isCorrectOption) {
							bg = const Color(0xFF34C759).withOpacity(0.2);
						} else if (isSelected) {
							bg = const Color(0xFFE5484D).withOpacity(0.2);
						}
					}
					return SizedBox(
						width: 130,
						child: OutlinedButton(
							onPressed: _locked ? null : () => _select(i),
							style: OutlinedButton.styleFrom(backgroundColor: bg),
							child: Text("[${option.lower}, ${option.upper}]"),
						),
					);
				}),
			),
			const SizedBox(height: 16),
			if (_isCorrect != null && showCorrection)
			CorrectionBanner(
				isCorrect: _isCorrect!,
				message: _isCorrect!
					? "Bonne reponse (resultat : ${_question.result})"
					: "Resultat : ${_question.result} - reponse attendue : "
						"[${_question.options[_question.correctIndex].lower}, "
						"${_question.options[_question.correctIndex].upper}]",
			),
		],
		);
	}
}
