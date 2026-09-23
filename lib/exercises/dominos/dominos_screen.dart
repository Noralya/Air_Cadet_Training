import "package:flutter/material.dart";

import "../../core/engine/attempt.dart";
import "../../core/engine/exercise.dart";
import "../../shared/widgets/correction_banner.dart";
import "domino_grid_view.dart";
import "domino_value.dart";
import "dominos_generator.dart";

class DominosScreen extends StatefulWidget {
	const DominosScreen({
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
	State<DominosScreen> createState() => _DominosScreenState();
}

class _DominosScreenState extends State<DominosScreen> {
	static const int _seriesLength = 20;

	late DominosQuestion _question;
	int _index = 0;
	int? _selectedTop;
	int? _selectedBottom;
	bool? _isCorrect;
	bool _locked = false;
	bool _showCorrections = false;
	final Stopwatch _stopwatch = Stopwatch()..start();

	@override
	void initState() {
		super.initState();
		_question = DominosGenerator.generate();
	}

	void _validate() {
		if (_locked || _selectedTop == null || _selectedBottom == null) return;

		final given = DominoValue(_selectedTop!, _selectedBottom!);
		final isCorrect = given == _question.correctAnswer;

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

		_next();
	}

	void _next() {
		final showsFeedback = widget.mode == SessionMode.training && _showCorrections;
		final delay = showsFeedback
			? const Duration(milliseconds: 1100)
			: const Duration(milliseconds: 200);
		Future.delayed(delay, () {
			if (!mounted) return;
			setState(() {
				_index++;
				_selectedTop = null;
				_selectedBottom = null;
				_isCorrect = null;
				_locked = false;
				if (_index >= _seriesLength) {
					_index = 0;
					widget.onCycleComplete();
				}
				_question = DominosGenerator.generate();
				_stopwatch
				..reset()
				..start();
			});
		});
	}

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		final canShowCorrections = widget.mode == SessionMode.training;

		return SingleChildScrollView(
		child: Column(
			crossAxisAlignment: CrossAxisAlignment.stretch,
			children: [
			Text(
				"Construisez le domino manquant",
				textAlign: TextAlign.center,
				style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
			),
			const SizedBox(height: 16),
			DominoGridView(
				grid: _question.grid,
				maskedIndex: _question.maskedIndex,
				previewTop: _selectedTop,
				previewBottom: _selectedBottom,
			),
			const SizedBox(height: 20),
			Row(
				mainAxisAlignment: MainAxisAlignment.center,
				children: [
				_AnswerSelector(
					label: "A",
					value: _selectedTop,
					enabled: !_locked,
					onChanged: (v) => setState(() => _selectedTop = v),
				),
				const SizedBox(width: 20),
				_AnswerSelector(
					label: "B",
					value: _selectedBottom,
					enabled: !_locked,
					onChanged: (v) => setState(() => _selectedBottom = v),
				),
				],
			),
			const SizedBox(height: 20),
			Row(
				mainAxisAlignment: MainAxisAlignment.spaceBetween,
				children: [
				Text(
					"$_index \u2192 $_seriesLength",
					style: theme.textTheme.bodyMedium,
				),
				if (canShowCorrections)
					Row(
					mainAxisSize: MainAxisSize.min,
					children: [
						Checkbox(
						value: _showCorrections,
						onChanged: (v) => setState(() => _showCorrections = v ?? false),
						),
						const Text("Afficher les corrections"),
					],
					),
				SizedBox(
					width: 120,
					child: ElevatedButton(
					onPressed:
						(_selectedTop != null && _selectedBottom != null && !_locked)
							? _validate
							: null,
					child: const Text("Valider"),
					),
				),
				],
			),
			const SizedBox(height: 16),
			if (_isCorrect != null && canShowCorrections && _showCorrections)
				CorrectionBanner(
				isCorrect: _isCorrect!,
				message: _isCorrect!
					? "Bonne reponse (${_question.logicLabel})"
					: "Reponse attendue : ${_question.correctAnswer} (${_question.logicLabel})",
				),
			],
		),
		);
	}
}

class _AnswerSelector extends StatelessWidget {
	const _AnswerSelector({
		required this.label,
		required this.value,
		required this.enabled,
		required this.onChanged,
	});

	final String label;
	final int? value;
	final bool enabled;
	final ValueChanged<int?> onChanged;

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		return Column(
			children: [
				Text(label, style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700)),
				const SizedBox(height: 6),
				DropdownButton<int>(
				value: value,
				hint: const Text("-"),
				onChanged: enabled ? onChanged : null,
				items: List.generate(
					7,
					(i) => DropdownMenuItem(value: i, child: Text("$i")),
				),
				),
			],
		);
	}
}