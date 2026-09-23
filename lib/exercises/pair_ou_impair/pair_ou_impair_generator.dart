import "dart:math";

class PairOuImpairSeries {
	PairOuImpairSeries({required this.gridValues, required this.correctOrder});

	final List<int> gridValues;
	final List<int> correctOrder;
}

class PairOuImpairGenerator {
	static const int pairsPerParity = 6;

	static PairOuImpairSeries generate({Random? random}) {
		final rng = random ?? Random();
		final evens = <int>{};
		final odds = <int>{};

		while (evens.length < pairsPerParity) {
			final value = (rng.nextInt(49) + 1) * 2;
			evens.add(value);
		}
		while (odds.length < pairsPerParity) {
			final value = (rng.nextInt(49) + 1) * 2 + 1;
			odds.add(value);
		}

		final sortedEvens = evens.toList()..sort();
		final sortedOdds = odds.toList()..sort();

		final correctOrder = <int>[];
		for (int i = 0; i < pairsPerParity; i++) {
			correctOrder.add(sortedEvens[i]);
			correctOrder.add(sortedOdds[i]);
		}

		final gridValues = [...sortedEvens, ...sortedOdds]..shuffle(rng);

		return PairOuImpairSeries(
			gridValues: gridValues,
			correctOrder: correctOrder,
		);
	}
}
