import "dart:math";

class AnglesQuestion {
	AnglesQuestion({
		required this.originDegrees,
		required this.arrivalDegrees,
		required this.correctDelta,
		required this.options,
	});

	final int originDegrees;
	final int arrivalDegrees;
	final int correctDelta;
	final List<int> options;
}

class AnglesGenerator {
	static const List<int> possibleDeltas = [
		30,
		45,
		60,
		90,
		120,
		135,
		150,
		180,
		210,
		225,
		270,
		315,
	];

	static AnglesQuestion generate({Random? random}) {
		final rng = random ?? Random();
		final origin = rng.nextInt(12) * 30;
		final correctDelta = possibleDeltas[rng.nextInt(possibleDeltas.length)];
		final arrival = (origin + correctDelta) % 360;

		final distractors = <int>{};
		while (distractors.length < 4) {
		final candidate = possibleDeltas[rng.nextInt(possibleDeltas.length)];
		if (candidate != correctDelta) {
			distractors.add(candidate);
		}
		}

		final options = [correctDelta, ...distractors]..shuffle(rng);

		return AnglesQuestion(
			originDegrees: origin,
			arrivalDegrees: arrival,
			correctDelta: correctDelta,
			options: options,
		);
	}
}
