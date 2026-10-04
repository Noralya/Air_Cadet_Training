import "package:flutter/material.dart";

import "../../core/engine/attempt.dart";
import "../../core/engine/exercise.dart";
import "../../shared/widgets/correction_banner.dart";
import "../../shared/widgets/signed_integer_field.dart";
import "arithmetic_expression.dart";

class MentalMath1Screen extends StatefulWidget {
	const MentalMath1Screen({
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
	State<MentalMath1Screen> createState() => _MentalMath1ScreenState();
}

class _MentalMath1ScreenState extends State<MentalMath1Screen> {
	static const int _seriesLength = 10;

	late ArithmeticExpression _expression;
	int _index = 0;
	bool _locked = false;
	bool? _isCorrect;
	final TextEditingController _controller = TextEditingController();
	final Stopwatch _stopwatch = Stopwatch()..start();

	@override
	void initState() {
		super.initState();
		_expression =
			ArithmeticExpressionGenerator.generate(termCount: 9, maxAbs: 99);
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

		final isCorrect = input == _expression.result;

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
				? const Duration(milliseconds: 1100)
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
					_expression =
						ArithmeticExpressionGenerator.generate(termCount: 9, maxAbs: 99);
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
			const SizedBox(height: 20),
			Container(
				padding: const EdgeInsets.all(20),
				decoration: BoxDecoration(
					color: theme.cardTheme.color,
					borderRadius: BorderRadius.circular(16),
					border: Border.all(color: theme.dividerColor),
				),
				child: Text(
					_expression.formatted,
					textAlign: TextAlign.center,
					style: theme.textTheme.headlineSmall
						?.copyWith(fontWeight: FontWeight.w700),
				),
			),
			const SizedBox(height: 24),
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
					? "Bonne reponse"
					: "Reponse attendue : ${_expression.result}",
			),
		],
		);
	}
}
