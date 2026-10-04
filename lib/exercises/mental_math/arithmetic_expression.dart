import "dart:math";

class ArithmeticExpression {
	const ArithmeticExpression({required this.terms, required this.result});

	final List<int> terms;
	final int result;

	String get formatted {
		final buffer = StringBuffer();
		for (var i = 0; i < terms.length; i++) {
			final term = terms[i];
			if (i == 0) {
				buffer.write(term < 0 ? "-${term.abs()}" : "$term");
			} else {
				buffer.write(term < 0 ? " - ${term.abs()}" : " + $term");
			}
		}
		return buffer.toString();
	}
}

class ArithmeticExpressionGenerator {
	static ArithmeticExpression generate({
		Random? random,
		int termCount = 9,
		int minAbs = 5,
		int maxAbs = 99,
	}) {
		final rng = random ?? Random();
		final terms = List.generate(termCount, (_) {
			final magnitude = minAbs + rng.nextInt(maxAbs - minAbs + 1);
			final sign = rng.nextBool() ? 1 : -1;
			return magnitude * sign;
		});
		final result = terms.fold<int>(0, (sum, t) => sum + t);
		return ArithmeticExpression(terms: terms, result: result);
	}
}
