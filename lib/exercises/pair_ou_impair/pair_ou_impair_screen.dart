import "package:flutter/material.dart";

import "../../core/engine/attempt.dart";
import "../../core/engine/exercise.dart";
import "../../core/theme/app_colors.dart";
import "../../shared/widgets/responsive.dart";
import "pair_ou_impair_generator.dart";

class PairOuImpairScreen extends StatefulWidget {
	const PairOuImpairScreen({
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
	State<PairOuImpairScreen> createState() => _PairOuImpairScreenState();
}

class _PairOuImpairScreenState extends State<PairOuImpairScreen> {
	late PairOuImpairSeries _series;
	int _progressIndex = 0;
	int? _flashWrongValue;
	final Stopwatch _stepStopwatch = Stopwatch()..start();

	@override
	void initState() {
		super.initState();
		_series = PairOuImpairGenerator.generate();
	}

	void _handleTap(int value) {
		final expected = _series.correctOrder[_progressIndex];
		final isCorrect = value == expected;
		final responseTime = _stepStopwatch.elapsed;

		setState(() {
			if (isCorrect) {
			_progressIndex++;
			_flashWrongValue = null;
			_stepStopwatch
				..reset()
				..start();
			if (_progressIndex >= _series.correctOrder.length) {
				widget.onAttempt(Attempt(
					exerciseId: widget.meta.id,
					categoryKey: widget.meta.category.name,
					psyType: widget.meta.psyType.name,
					isCorrect: true,
					responseTime: responseTime,
					timedOut: false,
				));
				Future.delayed(const Duration(milliseconds: 350), () {
					if (!mounted) return;
					setState(() {
						_series = PairOuImpairGenerator.generate();
						_progressIndex = 0;
					});
					widget.onCycleComplete();
					_stepStopwatch
						..reset()
						..start();
				});
			}
			} else {
			widget.onAttempt(Attempt(
				exerciseId: widget.meta.id,
				categoryKey: widget.meta.category.name,
				psyType: widget.meta.psyType.name,
				isCorrect: false,
				responseTime: responseTime,
				timedOut: false,
			));
			_flashWrongValue = value;
			_progressIndex = 0;
			_stepStopwatch
				..reset()
				..start();
			}
		});
	}

	String get _nextTargetLabel {
		if (_progressIndex >= _series.correctOrder.length) return "Termine";
		final isPairTurn = _progressIndex.isEven;
		return isPairTurn ? "Cliquez sur un nombre PAIR" : "Cliquez sur un nombre IMPAIR";
	}

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		final columns = Responsive.gridColumns(context) + 2;

		return Column(
		children: [
			Container(
			width: double.infinity,
			padding: const EdgeInsets.all(16),
			margin: const EdgeInsets.only(bottom: 16),
			decoration: BoxDecoration(
				color: theme.colorScheme.primary.withOpacity(0.1),
				borderRadius: BorderRadius.circular(14),
			),
			child: Column(
				crossAxisAlignment: CrossAxisAlignment.start,
				children: [
				Text(
					"START",
					style: theme.textTheme.labelLarge?.copyWith(
					color: theme.colorScheme.primary,
					fontWeight: FontWeight.w800,
					letterSpacing: 2,
					),
				),
				const SizedBox(height: 4),
				Text(
					_nextTargetLabel,
					style: theme.textTheme.titleMedium
						?.copyWith(fontWeight: FontWeight.w700),
				),
				const SizedBox(height: 6),
				Text(
					"Progression : $_progressIndex / ${_series.correctOrder.length}",
					style: theme.textTheme.bodySmall,
				),
				],
			),
			),
			Expanded(
			child: GridView.builder(
				itemCount: _series.gridValues.length,
				gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
				crossAxisCount: columns,
				mainAxisSpacing: 12,
				crossAxisSpacing: 12,
				childAspectRatio: 1,
				),
				itemBuilder: (context, index) {
				final value = _series.gridValues[index];
				final isWrongFlash = _flashWrongValue == value;
				return GestureDetector(
					onTap: () => _handleTap(value),
					child: AnimatedContainer(
					duration: const Duration(milliseconds: 150),
					decoration: BoxDecoration(
						color: isWrongFlash
							? AppColors.error.withOpacity(0.25)
							: theme.cardTheme.color,
						borderRadius: BorderRadius.circular(14),
						border: Border.all(
						color: isWrongFlash
							? AppColors.error
							: theme.dividerColor,
						width: isWrongFlash ? 2 : 1,
						),
					),
					alignment: Alignment.center,
					child: Text(
						"$value",
						style: theme.textTheme.headlineSmall
							?.copyWith(fontWeight: FontWeight.w700),
					),
					),
				);
				},
			),
			),
		],
		);
	}
}
