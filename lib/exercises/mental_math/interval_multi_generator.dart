import "dart:math";
import "arithmetic_expression.dart";

class MultiIntervalOption {
	const MultiIntervalOption({
		required this.lower,
		required this.upper,
		required this.containsResult,
	});

	final int lower;
	final int upper;
	final bool containsResult;

	@override
	String toString() => "[$lower, $upper]";
}

class IntervalMultiQuestion {
	IntervalMultiQuestion({
		required this.expression,
		required this.result,
		required this.options,
		required this.correctIndices,
	});

	final String expression;
	final int result;
	final List<MultiIntervalOption> options;
	final Set<int> correctIndices;

	bool get hasNoCorrectAnswer => correctIndices.isEmpty;
}

class IntervalMultiGenerator {
	static IntervalMultiQuestion generate({Random? random}) {
		final rng = random ?? Random();
		final expr = ArithmeticExpressionGenerator.generate(
			random: rng,
			termCount: 6,
			maxAbs: 50,
		);
		final result = expr.result;

		final containingCount = rng.nextInt(4);
		final options = <MultiIntervalOption>[];

		for (var i = 0; i < 7; i++) {
			final shouldContain = i < containingCount;
			final width = 10 + rng.nextInt(250);
			int lower;
			if (shouldContain) {
				final offset = 1 + rng.nextInt(width);
				lower = result - offset;
			} else {
				final gap = width + 5 + rng.nextInt(100);
				lower = rng.nextBool() ? result + gap : result - gap - width;
			}
			final upper = lower + width;
			options.add(MultiIntervalOption(
				lower: lower,
				upper: upper,
				containsResult: result >= lower && result <= upper,
			));
		}
		options.shuffle(rng);

		final correctIndices = <int>{
		for (var i = 0; i < options.length; i++)
			if (options[i].containsResult) i,
		};

		return IntervalMultiQuestion(
			expression: expr.formatted,
			result: result,
			options: options,
			correctIndices: correctIndices,
		);
	}
}
