import "dart:math";

class EquationStep {
	const EquationStep({
		required this.label,
		required this.expression,
		required this.value,
	});

	final String label;
	final String expression;
	final int value;
}

class EquationChainQuestion {
	const EquationChainQuestion({required this.steps});

	final List<EquationStep> steps;

	String get finalLabel => steps.last.label;
	int get finalValue => steps.last.value;
}

class EquationChainGenerator {
	static const List<String> _labels = ["A", "B", "C", "D"];

	static EquationChainQuestion generate({Random? random, int? stepCount}) {
		final rng = random ?? Random();
		final count = stepCount ?? (3 + rng.nextInt(2));
		final labels = _labels.sublist(0, count);
		final values = <String, int>{};
		final steps = <EquationStep>[];

		for (var i = 0; i < count - 1; i++) {
			final label = labels[i];
			final target = _nonZero(rng, -12, 12);
			final coeff = 2 + rng.nextInt(7);

			final useProduct = rng.nextBool();
			final terms = <String>[];
			int constantTotal;

			if (useProduct) {
				final q = 2 + rng.nextInt(7);
				final p = _nonZero(rng, -40, 40);
				final product = p * q;
				final c1 = _nonZero(rng, -60, 60);
				constantTotal = c1 + product;
				terms.add(_formatFirst(c1));
				terms.add(_formatProduct(p, q));
			} else {
				constantTotal = _nonZero(rng, -120, 120);
				terms.add(_formatFirst(constantTotal));
			}

			String? refLabel;
			var refSign = 1;
			if (i > 0 && rng.nextBool()) {
				refLabel = labels[i - 1];
				refSign = rng.nextBool() ? 1 : -1;
			}
			final refValue = refLabel != null ? values[refLabel]! * refSign : 0;

			final rhs = constantTotal + coeff * target + refValue;

			if (refLabel != null) {
				terms.add(refSign == 1 ? "+ $refLabel" : "- $refLabel");
			}
			terms.add("+ $coeff$label");

			final expression = "${terms.join(' ')} = $rhs";
			values[label] = target;
			steps.add(
				EquationStep(label: label, expression: expression, value: target),
			);
		}

		final finalLabel = labels.last;
		final availableLabels = labels.sublist(0, count - 1);
		final usedCount = 1 + rng.nextInt(availableLabels.length);
		final chosen =
			(availableLabels.toList()..shuffle(rng)).take(usedCount).toList();

		final finalTerms = <String>[];
		var finalValue = 0;
		var first = true;
		for (final label in chosen) {
			final coeff = 2 + rng.nextInt(7);
			final sign = rng.nextBool() ? 1 : -1;
			finalValue += sign * coeff * values[label]!;
			finalTerms.add(_formatCoeffVar(sign * coeff, label, first: first));
			first = false;
		}

		final extraConstant = _nonZero(rng, -90, 90);
		finalValue += extraConstant;
		finalTerms.add(_formatSigned(extraConstant));

		if (rng.nextBool()) {
			final extraConstant2 = _nonZero(rng, -90, 90);
			finalValue += extraConstant2;
			finalTerms.add(_formatSigned(extraConstant2));
		}

		final finalExpression = "$finalLabel = ${finalTerms.join(' ')}";
		steps.add(
			EquationStep(
				label: finalLabel,
				expression: finalExpression,
				value: finalValue,
			),
		);

		return EquationChainQuestion(steps: steps);
	}

	static int _nonZero(Random rng, int min, int max) {
		int value;
		do {
			value = min + rng.nextInt(max - min + 1);
		} while (value == 0);
		return value;
	}

	static String _formatFirst(int value) =>
		value < 0 ? "-${value.abs()}" : "$value";

	static String _formatSigned(int value) =>
		value < 0 ? "- ${value.abs()}" : "+ $value";

	static String _formatProduct(int p, int q) =>
		p < 0 ? "- ${p.abs()} x $q" : "+ $p x $q";

	static String _formatCoeffVar(
		int signedCoeff,
		String label, {
			required bool first,
	}) {
		final abs = signedCoeff.abs();
		if (first) {
			return signedCoeff < 0 ? "- $abs$label" : "$abs$label";
		}
		return signedCoeff < 0 ? "- $abs$label" : "+ $abs$label";
	}
}