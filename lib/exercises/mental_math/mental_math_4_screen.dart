import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

import "../../core/engine/attempt.dart";
import "../../core/engine/exercise.dart";
import "../../shared/widgets/correction_banner.dart";
import "interval_multi_generator.dart";

class MentalMath4Screen extends StatefulWidget {
	const MentalMath4Screen({
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
	State<MentalMath4Screen> createState() => _MentalMath4ScreenState();
}

class _MentalMath4ScreenState extends State<MentalMath4Screen> {
	static const int _seriesLength = 10;

	late IntervalMultiQuestion _question;
	int _index = 0;
	final Set<int> _selected = {};
	bool _noneSelected = false;
	bool _locked = false;
	bool? _isCorrect;
	final Stopwatch _stopwatch = Stopwatch()..start();

	@override
	void initState() {
		super.initState();
		_question = IntervalMultiGenerator.generate();
	}

	void _toggleOption(int index) {
		if (_locked) return;
		setState(() {
			_noneSelected = false;
			if (_selected.contains(index)) {
				_selected.remove(index);
			} else {
				_selected.add(index);
			}
		});
	}

	void _toggleNone() {
		if (_locked) return;
		setState(() {
			_noneSelected = !_noneSelected;
			if (_noneSelected) _selected.clear();
		});
	}

	void _validate() {
		if (_locked) return;
		final userAnswer = _noneSelected ? <int>{} : _selected;
		final isCorrect = _noneSelected
			? _question.hasNoCorrectAnswer
			: setEquals(userAnswer, _question.correctIndices);

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
			_isCorrect = isCorrect;
		});

		final showsFeedback = widget.mode == SessionMode.training;
		Future.delayed(
			showsFeedback
				? const Duration(milliseconds: 1300)
				: const Duration(milliseconds: 200),
			() {
				if (!mounted) return;
				setState(() {
					_index++;
					_locked = false;
					_isCorrect = null;
					_selected.clear();
					_noneSelected = false;
					if (_index >= _seriesLength) {
						_index = 0;
						widget.onCycleComplete();
					}
					_question = IntervalMultiGenerator.generate();
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

		return SingleChildScrollView(
		child: Column(
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
				"Selectionnez tous les intervalles contenant le resultat",
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
					final isSelected = _selected.contains(i);
					final isCorrectOption = _question.correctIndices.contains(i);
					Color? bg;
					if (_locked && showCorrection) {
						if (isCorrectOption) {
							bg = const Color(0xFF34C759).withOpacity(0.2);
						} else if (isSelected) {
							bg = const Color(0xFFE5484D).withOpacity(0.2);
						}
					}
					return FilterChip(
						label: Text("[${option.lower}, ${option.upper}]"),
						selected: isSelected,
						onSelected: _locked ? null : (_) => _toggleOption(i),
						backgroundColor: bg,
						selectedColor: bg ?? theme.colorScheme.primary.withOpacity(0.2),
					);
				}),
			),
			const SizedBox(height: 12),
			Center(
				child: FilterChip(
					label: const Text("Pas de reponses"),
					selected: _noneSelected,
					onSelected: _locked ? null : (_) => _toggleNone(),
				),
			),
			const SizedBox(height: 20),
			ElevatedButton(
				onPressed: (_locked || (_selected.isEmpty && !_noneSelected))
					? null
					: _validate,
				child: const Text("Valider"),
			),
			const SizedBox(height: 16),
			if (_isCorrect != null && showCorrection)
				CorrectionBanner(
				isCorrect: _isCorrect!,
				message: _isCorrect!
					? "Bonne reponse (resultat : ${_question.result})"
					: _question.hasNoCorrectAnswer
						? "Resultat : ${_question.result} - aucun intervalle ne convenait"
						: "Resultat : ${_question.result}",
				),
			],
		),
		);
	}
}
