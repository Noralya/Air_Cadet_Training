import "package:flutter/material.dart";

import "../../core/engine/attempt.dart";
import "../../core/engine/exercise.dart";
import "../../shared/widgets/correction_banner.dart";
import "../../shared/widgets/signed_integer_field.dart";
import "equation_chain_generator.dart";

class MentalMath3Screen extends StatefulWidget {
	const MentalMath3Screen({
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
	State<MentalMath3Screen> createState() => _MentalMath3ScreenState();
}

class _MentalMath3ScreenState extends State<MentalMath3Screen> {
	static const int _seriesLength = 30;

	late EquationChainQuestion _question;
	int _index = 0;
	bool _locked = false;
	bool? _isCorrect;
	final TextEditingController _controller = TextEditingController();
	final Stopwatch _stopwatch = Stopwatch()..start();

	@override
	void initState() {
		super.initState();
		_question = EquationChainGenerator.generate();
	}

	@override
	void dispose() {
		_controller.dispose();
		super.dispose();
	}

	void _validate() {
		if (_locked) return;
		final input = int.tryParse(_controller.text.trim());
		if (input == null) return;

		final isCorrect = input == _question.finalValue;

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
				: const Duration(milliseconds: 150),
			() {
				if (!mounted) return;
				setState(() {
					_index++;
					_locked = false;
					_isCorrect = null;
					_controller.clear();
					if (_index >= _seriesLength) {
						_index = 0;
						widget.onCycleComplete();
					}
					_question = EquationChainGenerator.generate();
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
				padding: const EdgeInsets.all(16),
				decoration: BoxDecoration(
					color: theme.cardTheme.color,
					borderRadius: BorderRadius.circular(16),
					border: Border.all(color: theme.dividerColor),
				),
				child: Column(
					crossAxisAlignment: CrossAxisAlignment.start,
					children: [
						for (final step in _question.steps)
						Padding(
							padding: const EdgeInsets.symmetric(vertical: 4),
							child: Text(
								step.expression,
								style: theme.textTheme.titleMedium
									?.copyWith(fontWeight: FontWeight.w600),
							),
						),
					],
				),
			),
			const SizedBox(height: 20),
			Text(
				"Entrez la valeur de ${_question.finalLabel}",
				textAlign: TextAlign.center,
				style: theme.textTheme.labelLarge,
			),
			const SizedBox(height: 8),
			Center(
				child: SizedBox(
					width: 160,
					child: SignedIntegerField(
						controller: _controller,
						enabled: !_locked,
						onSubmitted: (_) => _validate(),
					),
				),
			),
			const SizedBox(height: 16),
			ElevatedButton(
				onPressed: _locked ? null : _validate,
				child: const Text("Valider"),
			),
			const SizedBox(height: 16),
			if (_isCorrect != null && showCorrection)
				CorrectionBanner(
					isCorrect: _isCorrect!,
					message: _isCorrect!
						? "Bonne réponse"
						: "Réponse attendue : ${_question.finalValue}",
				),
			],
		),
		);
	}
}
