import "dart:math";
import "arithmetic_expression.dart";

class IntervalOption {
	const IntervalOption({required this.lower, required this.upper});

	final int lower;
	final int upper;

	int get width => upper - lower;

	@override
	String toString() => "[$lower, $upper]";
}

class IntervalSingleQuestion {
	IntervalSingleQuestion({
		required this.expression,
		required this.result,
		required this.options,
		required this.correctIndex,
	});

	final String expression;
	final int result;
	final List<IntervalOption> options;
	final int correctIndex;
}

class IntervalSingleGenerator {
	static IntervalSingleQuestion generate({Random? random}) {
		final rng = random ?? Random();

		final expr = ArithmeticExpressionGenerator.generate(
			random: rng,
			termCount: 6,
			maxAbs: 40,
		);

		final result = expr.result;
		final widths = <int>{};

		while (widths.length < 8) {
			widths.add(8 + rng.nextInt(300));
		}
		
		final sortedWidths = widths.toList()..sort();

		final baseOptions = sortedWidths.map((w) {
			final offset = 1 + rng.nextInt(w);
			final lower = result - offset;
			final upper = lower + w;
			return IntervalOption(lower: lower, upper: upper);
		}).toList();

		final order = List.generate(baseOptions.length, (i) => i)..shuffle(rng);
		final shuffledOptions = order.map((i) => baseOptions[i]).toList();
		final correctIndex = order.indexOf(0);

		return IntervalSingleQuestion(
			expression: expr.formatted,
			result: result,
			options: shuffledOptions,
			correctIndex: correctIndex,
		);
	}
}
